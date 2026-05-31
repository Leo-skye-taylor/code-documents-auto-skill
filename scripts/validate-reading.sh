#!/bin/bash

# Pre-development Reading Validator
# This script validates that required documentation has been read before development

set -e

# Configuration
DOCS_DIR="ai-context"
READING_LOG="$DOCS_DIR/.reading-log.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[成功]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

log_error() {
    echo -e "${RED}[错误]${NC} $1"
}

# Help function
show_help() {
    cat << EOF
用法: $0 [选项] [功能/模块]

验证开发前是否已读取必需的文档。

选项:
    -h, --help          显示此帮助信息
    -v, --verbose       启用详细输出
    -f, --force         强制验证（即使日志不存在）
    -l, --list          列出所有必需的读取
    -c, --check         检查读取状态

参数:
    功能/模块           要验证的功能或模块（可选）

示例:
    $0                          # 验证所有读取
    $0 auth                     # 验证 auth 模块的读取
    $0 --list                   # 列出所有必需的读取
    $0 --check                  # 检查读取状态

EOF
}

# Parse arguments
VERBOSE=false
FORCE=false
LIST_ONLY=false
CHECK_ONLY=false
TARGET=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -l|--list)
            LIST_ONLY=true
            shift
            ;;
        -c|--check)
            CHECK_ONLY=true
            shift
            ;;
        -*)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

# Check if docs directory exists
if [[ ! -d "$DOCS_DIR" ]]; then
    log_error "文档目录不存在: $DOCS_DIR"
    log_error "请先运行 /docs-scan 生成文档"
    exit 1
fi

# Initialize reading log if it doesn't exist
init_reading_log() {
    if [[ ! -f "$READING_LOG" ]] || [[ "$FORCE" == true ]]; then
        log_info "正在初始化读取日志..."
        cat > "$READING_LOG" << EOF
{
  "version": "1.0",
  "lastUpdated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "readings": {}
}
EOF
        log_success "读取日志初始化完成"
    fi
}

# List all required readings
list_required_readings() {
    log_info "必需的读取:"
    echo ""

    # Architecture documentation
    if [[ -f "$DOCS_DIR/architecture.md" ]]; then
        echo "1. 架构概览"
        echo "   - 文件: ai-context/architecture.md"
        echo "   - 必需: 是"
        echo "   - 目的: 理解系统架构"
        echo ""
    fi

    # Module documentation
    if [[ -d "$DOCS_DIR/modules" ]]; then
        local module_count=0
        for module_dir in "$DOCS_DIR/modules"/*/; do
            if [[ -d "$module_dir" ]]; then
                ((module_count++))
                local module_name=$(basename "$module_dir")
                echo "$((module_count + 1)). 模块: $module_name"
                echo "   - 文件: ai-context/modules/$module_name/README.md"
                echo "   - 必需: 是"
                echo "   - 目的: 理解模块结构"
                echo ""
            fi
        done
    fi

    # Feature documentation
    if [[ -d "$DOCS_DIR/features" ]]; then
        local feature_count=0
        for feature_dir in "$DOCS_DIR/features"/*/; do
            if [[ -d "$feature_dir" ]]; then
                ((feature_count++))
                local feature_name=$(basename "$feature_dir")
                echo "$((feature_count + module_count + 1)). 功能: $feature_name"
                echo "   - 文件: ai-context/features/$feature_name/README.md"
                echo "   - 必需: 是"
                echo "   - 目的: 理解功能需求"
                echo ""
            fi
        done
    fi

    # API documentation
    if [[ -d "$DOCS_DIR/api" ]]; then
        echo "API 文档:"
        echo "   - 文件: ai-context/api/README.md"
        echo "   - 必需: 是"
        echo "   - 目的: 理解 API 接口"
        echo ""
    fi
}

# Check reading status
check_reading_status() {
    log_info "正在检查读取状态..."
    echo ""

    if [[ ! -f "$READING_LOG" ]]; then
        log_warning "未找到读取日志"
        log_warning "使用 -f 选项初始化"
        return 1
    fi

    # Parse reading log
    local total_readings=$(jq '.readings | length' "$READING_LOG" 2>/dev/null || echo "0")
    local last_updated=$(jq -r '.lastUpdated' "$READING_LOG" 2>/dev/null || echo "未知")

    echo "读取日志状态:"
    echo "  - 已记录的读取总数: $total_readings"
    echo "  - 最后更新: $last_updated"
    echo ""

    # List recent readings
    if [[ $total_readings -gt 0 ]]; then
        echo "最近的读取:"
        jq -r '.readings | to_entries | sort_by(.value.timestamp) | reverse | .[0:5][] | "  - \(.key): \(.value.timestamp)"' "$READING_LOG" 2>/dev/null || echo "  未找到读取记录"
    fi
}

# Record a reading
record_reading() {
    local doc_path="$1"
    local doc_type="$2"
    local doc_name="$3"

    if [[ ! -f "$READING_LOG" ]]; then
        init_reading_log
    fi

    # Update reading log
    local temp_file=$(mktemp)
    jq --arg path "$doc_path" \
       --arg type "$doc_type" \
       --arg name "$doc_name" \
       --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
       '.readings[$path] = {
          "type": $type,
          "name": $name,
          "timestamp": $timestamp,
          "acknowledged": true
        } | .lastUpdated = $timestamp' "$READING_LOG" > "$temp_file"

    mv "$temp_file" "$READING_LOG"

    log_success "已记录读取: $doc_name"
}

# Validate reading for specific target
validate_target() {
    local target="$1"

    log_info "正在验证读取: $target"
    echo ""

    # Check if target exists in docs
    local found=false

    # Check modules
    if [[ -d "$DOCS_DIR/modules/$target" ]]; then
        found=true
        local module_readme="$DOCS_DIR/modules/$target/README.md"

        if [[ -f "$module_readme" ]]; then
            # Check if already read
            if jq -e ".readings[\"$module_readme\"]" "$READING_LOG" >/dev/null 2>&1; then
                local last_read=$(jq -r ".readings[\"$module_readme\"].timestamp" "$READING_LOG")
                log_success "模块文档已读取: $last_read"
            else
                log_warning "模块文档未读取"
                echo "请读取: $module_readme"
                echo ""
                echo "记录读取请运行:"
                echo "  $0 --record $module_readme"
            fi
        fi
    fi

    # Check features
    if [[ -d "$DOCS_DIR/features/$target" ]]; then
        found=true
        local feature_readme="$DOCS_DIR/features/$target/README.md"

        if [[ -f "$feature_readme" ]]; then
            # Check if already read
            if jq -e ".readings[\"$feature_readme\"]" "$READING_LOG" >/dev/null 2>&1; then
                local last_read=$(jq -r ".readings[\"$feature_readme\"].timestamp" "$READING_LOG")
                log_success "功能文档已读取: $last_read"
            else
                log_warning "功能文档未读取"
                echo "请读取: $feature_readme"
                echo ""
                echo "记录读取请运行:"
                echo "  $0 --record $feature_readme"
            fi
        fi
    fi

    if [[ "$found" == false ]]; then
        log_warning "未找到目标: $target"
        echo "可用模块:"
        ls -1 "$DOCS_DIR/modules" 2>/dev/null || echo "  无"
        echo ""
        echo "可用功能:"
        ls -1 "$DOCS_DIR/features" 2>/dev/null || echo "  无"
    fi
}

# Validate all readings
validate_all() {
    log_info "正在验证所有必需的读取..."
    echo ""

    local all_read=true
    local missing_readings=()

    # Check architecture
    if [[ -f "$DOCS_DIR/architecture.md" ]]; then
        if ! jq -e ".readings[\"$DOCS_DIR/architecture.md\"]" "$READING_LOG" >/dev/null 2>&1; then
            all_read=false
            missing_readings+=("ai-context/architecture.md")
        fi
    fi

    # Check modules
    if [[ -d "$DOCS_DIR/modules" ]]; then
        for module_dir in "$DOCS_DIR/modules"/*/; do
            if [[ -d "$module_dir" ]]; then
                local module_readme="$module_dir/README.md"
                if [[ -f "$module_readme" ]]; then
                    if ! jq -e ".readings[\"$module_readme\"]" "$READING_LOG" >/dev/null 2>&1; then
                        all_read=false
                        missing_readings+=("$module_readme")
                    fi
                fi
            fi
        done
    fi

    # Check features
    if [[ -d "$DOCS_DIR/features" ]]; then
        for feature_dir in "$DOCS_DIR/features"/*/; do
            if [[ -d "$feature_dir" ]]; then
                local feature_readme="$feature_dir/README.md"
                if [[ -f "$feature_readme" ]]; then
                    if ! jq -e ".readings[\"$feature_readme\"]" "$READING_LOG" >/dev/null 2>&1; then
                        all_read=false
                        missing_readings+=("$feature_readme")
                    fi
                fi
            fi
        done
    fi

    # Report results
    if [[ "$all_read" == true ]]; then
        log_success "所有必需的读取都已完成！"
        echo ""
        echo "可以继续开发。"
    else
        log_error "缺少必需的读取:"
        echo ""
        for reading in "${missing_readings[@]}"; do
            echo "  - $reading"
        done
        echo ""
        echo "请在继续之前读取上述文档。"
        echo ""
        echo "记录读取请运行:"
        echo "  $0 --record <文件路径>"
        exit 1
    fi
}

# Main function
main() {
    # Initialize reading log if needed
    init_reading_log

    # Handle different modes
    if [[ "$LIST_ONLY" == true ]]; then
        list_required_readings
    elif [[ "$CHECK_ONLY" == true ]]; then
        check_reading_status
    elif [[ -n "$TARGET" ]]; then
        validate_target "$TARGET"
    else
        validate_all
    fi
}

# Run main function
main
