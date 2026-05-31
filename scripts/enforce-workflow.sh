#!/bin/bash

# Workflow Enforcement Script
# Ensures mandatory document reading before development and document generation after development

set -e

# Configuration
DOCS_DIR="ai-context"
WORKFLOW_LOG="$DOCS_DIR/.workflow-log.json"
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
用法: $0 [选项] [操作]

强制工作流：确保开发前必须读取文档，开发后必须生成文档。

选项:
    -h, --help          显示此帮助信息
    -v, --verbose       启用详细输出
    -f, --files         被修改的文件（逗号分隔）
    -m, --modules       被修改的模块（逗号分隔）
    -t, --type          操作类型 (read|write|both)

参数:
    操作                要执行的操作 (check|start|complete|verify)

示例:
    $0 check -f "src/auth/login.ts,src/user/user.service.ts"
    $0 start -m "auth,user"
    $0 complete -f "src/auth/login.ts"
    $0 verify

EOF
}

# Parse arguments
VERBOSE=false
FILES=""
MODULES=""
OPERATION_TYPE="both"
ACTION=""

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
        -f|--files)
            FILES="$2"
            shift 2
            ;;
        -m|--modules)
            MODULES="$2"
            shift 2
            ;;
        -t|--type)
            OPERATION_TYPE="$2"
            shift 2
            ;;
        -*)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            ACTION="$1"
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

# Initialize workflow log
init_workflow_log() {
    if [[ ! -f "$WORKFLOW_LOG" ]]; then
        cat > "$WORKFLOW_LOG" << EOF
{
  "version": "1.0",
  "sessions": {},
  "current_session": null
}
EOF
    fi
}

# Initialize reading log
init_reading_log() {
    if [[ ! -f "$READING_LOG" ]]; then
        cat > "$READING_LOG" << EOF
{
  "version": "1.0",
  "lastUpdated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "readings": {}
}
EOF
    fi
}

# Find related documents for files
find_related_docs() {
    local files="$1"
    local related_docs=()

    # Split files by comma
    IFS=',' read -ra FILE_ARRAY <<< "$files"

    for file in "${FILE_ARRAY[@]}"; do
        # Extract module name from file path
        # e.g., src/auth/login.ts -> auth
        local module=$(echo "$file" | sed -n 's|.*/src/\([^/]*\)/.*|\1|p')

        if [[ -n "$module" ]]; then
            # Check for module documentation
            if [[ -d "$DOCS_DIR/modules/$module" ]]; then
                related_docs+=("$DOCS_DIR/modules/$module/README.md")
            fi

            # Check for related features
            for feature_dir in "$DOCS_DIR/features"/*/; do
                if [[ -d "$feature_dir" ]]; then
                    # Check if feature mentions this module
                    if grep -q "$module" "$feature_dir/README.md" 2>/dev/null; then
                        related_docs+=("$feature_dir/README.md")
                    fi
                fi
            done

            # Check for related APIs
            for api_dir in "$DOCS_DIR/api"/*/; do
                if [[ -d "$api_dir" ]]; then
                    # Check if API mentions this module
                    if grep -q "$module" "$api_dir/README.md" 2>/dev/null; then
                        related_docs+=("$api_dir/README.md")
                    fi
                fi
            done
        fi
    done

    # Always include architecture and guidelines
    related_docs+=("$DOCS_DIR/architecture.md")
    related_docs+=("$DOCS_DIR/guidelines/README.md")

    # Remove duplicates
    printf '%s\n' "${related_docs[@]}" | sort -u
}

# Find related documents for modules
find_related_docs_for_modules() {
    local modules="$1"
    local related_docs=()

    # Split modules by comma
    IFS=',' read -ra MODULE_ARRAY <<< "$modules"

    for module in "${MODULE_ARRAY[@]}"; do
        # Check for module documentation
        if [[ -d "$DOCS_DIR/modules/$module" ]]; then
            related_docs+=("$DOCS_DIR/modules/$module/README.md")
        fi

        # Check for related features
        for feature_dir in "$DOCS_DIR/features"/*/; do
            if [[ -d "$feature_dir" ]]; then
                if grep -q "$module" "$feature_dir/README.md" 2>/dev/null; then
                    related_docs+=("$feature_dir/README.md")
                fi
            fi
        done

        # Check for related APIs
        for api_dir in "$DOCS_DIR/api"/*/; do
            if [[ -d "$api_dir" ]]; then
                if grep -q "$module" "$api_dir/README.md" 2>/dev/null; then
                    related_docs+=("$api_dir/README.md")
                fi
            fi
        done
    done

    # Always include architecture and guidelines
    related_docs+=("$DOCS_DIR/architecture.md")
    related_docs+=("$DOCS_DIR/guidelines/README.md")

    # Remove duplicates
    printf '%s\n' "${related_docs[@]}" | sort -u
}

# Check if document has been read
is_document_read() {
    local doc_path="$1"

    if [[ ! -f "$READING_LOG" ]]; then
        return 1
    fi

    # Check if document exists in reading log
    if jq -e ".readings[\"$doc_path\"]" "$READING_LOG" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Record document reading
record_reading() {
    local doc_path="$1"
    local doc_name=$(basename "$doc_path" .md)

    if [[ ! -f "$READING_LOG" ]]; then
        init_reading_log
    fi

    # Update reading log
    local temp_file=$(mktemp)
    jq --arg path "$doc_path" \
       --arg name "$doc_name" \
       --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
       '.readings[$path] = {
          "name": $name,
          "timestamp": $timestamp,
          "acknowledged": true
        } | .lastUpdated = $timestamp' "$READING_LOG" > "$temp_file"

    mv "$temp_file" "$READING_LOG"
}

# Check workflow: verify all required documents have been read
check_workflow() {
    log_info "正在检查工作流要求..."
    echo ""

    local all_read=true
    local missing_docs=()

    # Find related documents
    local related_docs=()

    if [[ -n "$FILES" ]]; then
        while IFS= read -r doc; do
            related_docs+=("$doc")
        done < <(find_related_docs "$FILES")
    elif [[ -n "$MODULES" ]]; then
        while IFS= read -r doc; do
            related_docs+=("$doc")
        done < <(find_related_docs_for_modules "$MODULES")
    else
        log_error "未指定文件或模块"
        exit 1
    fi

    # Check each document
    for doc in "${related_docs[@]}"; do
        if [[ -f "$doc" ]]; then
            if ! is_document_read "$doc"; then
                all_read=false
                missing_docs+=("$doc")
            fi
        fi
    done

    # Report results
    if [[ "$all_read" == true ]]; then
        log_success "所有必需的文档都已读取！"
        echo ""
        echo "可以继续开发。"
        return 0
    else
        log_error "缺少必需的文档读取:"
        echo ""
        for doc in "${missing_docs[@]}"; do
            echo "  - $doc"
        done
        echo ""
        echo "请在继续之前读取上述文档。"
        echo ""
        echo "读取文档请使用:"
        echo "  cat $doc"
        echo ""
        echo "然后记录读取:"
        echo "  $0 record -f \"$doc\""
        return 1
    fi
}

# Start workflow: begin development session
start_workflow() {
    log_info "正在启动开发工作流..."
    echo ""

    # Initialize logs
    init_workflow_log
    init_reading_log

    # Create new session
    local session_id="session_$(date +%Y%m%d_%H%M%S)"
    local timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

    # Update workflow log
    local temp_file=$(mktemp)
    jq --arg session_id "$session_id" \
       --arg timestamp "$timestamp" \
       --arg files "$FILES" \
       --arg modules "$MODULES" \
       --arg operation_type "$OPERATION_TYPE" \
       '.sessions[$session_id] = {
          "started": $timestamp,
          "files": $files,
          "modules": $modules,
          "operation_type": $operation_type,
          "status": "in_progress",
          "documents_read": [],
          "documents_generated": []
        } | .current_session = $session_id' "$WORKFLOW_LOG" > "$temp_file"

    mv "$temp_file" "$WORKFLOW_LOG"

    log_success "工作流会话已启动: $session_id"
    echo ""

    # Check required documents
    check_workflow
}

# Complete workflow: finish development session
complete_workflow() {
    log_info "正在完成开发工作流..."
    echo ""

    if [[ ! -f "$WORKFLOW_LOG" ]]; then
        log_error "未找到工作流会话"
        exit 1
    fi

    # Get current session
    local session_id=$(jq -r '.current_session' "$WORKFLOW_LOG")

    if [[ "$session_id" == "null" ]]; then
        log_error "没有活动的工作流会话"
        exit 1
    fi

    # Update session status
    local temp_file=$(mktemp)
    jq --arg session_id "$session_id" \
       --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
       --arg files "$FILES" \
       '.sessions[$session_id].status = "completed" |
        .sessions[$session_id].completed = $timestamp |
        .sessions[$session_id].files_modified = $files |
        .current_session = null' "$WORKFLOW_LOG" > "$temp_file"

    mv "$temp_file" "$WORKFLOW_LOG"

    log_success "工作流会话已完成: $session_id"
    echo ""

    # Generate documentation
    generate_documentation
}

# Generate documentation for modified files
generate_documentation() {
    log_info "正在为修改的文件生成文档..."
    echo ""

    if [[ -z "$FILES" ]]; then
        log_warning "未指定文件，跳过文档生成"
        return
    fi

    # Split files by comma
    IFS=',' read -ra FILE_ARRAY <<< "$FILES"

    for file in "${FILE_ARRAY[@]}"; do
        # Extract module name from file path
        local module=$(echo "$file" | sed -n 's|.*/src/\([^/]*\)/.*|\1|p')

        if [[ -n "$module" ]]; then
            # Update module documentation
            local module_doc="$DOCS_DIR/modules/$module/README.md"

            if [[ -f "$module_doc" ]]; then
                # Add update entry
                local timestamp=$(date +%Y-%m-%d)
                local entry="- $timestamp: 更新了 $file"

                # Append to module documentation
                echo "" >> "$module_doc"
                echo "## 最近更新" >> "$module_doc"
                echo "" >> "$module_doc"
                echo "$entry" >> "$module_doc"

                log_success "已更新模块文档: $module_doc"
            fi
        fi
    done

    # Generate change record
    local change_record="$DOCS_DIR/changelog/$(date +%Y-%m-%d)-workflow-update.md"

    cat > "$change_record" << EOF
---
date: $(date +%Y-%m-%d)
type: workflow
title: "工作流更新"
author: "AI 助手"
modules: [$(echo "$MODULES" | tr ',' ', ')]
impact: medium
status: completed
---

# 工作流更新

## 摘要

来自工作流强制执行的自动文档更新。

## 修改的文件

$(echo "$FILES" | tr ',' '\n' | sed 's/^/- /')

## 已更新的文档

- 模块文档已更新
- 变更记录已生成

## 后续步骤

1. 审查更新的文档
2. 验证更改是否正确
3. 提交更改

EOF

    log_success "变更记录已生成: $change_record"
}

# Record document reading
record_document_reading() {
    log_info "正在记录文档读取..."
    echo ""

    if [[ -z "$FILES" ]]; then
        log_error "未指定文件"
        exit 1
    fi

    # Split files by comma
    IFS=',' read -ra FILE_ARRAY <<< "$FILES"

    for file in "${FILE_ARRAY[@]}"; do
        if [[ -f "$file" ]]; then
            record_reading "$file"
            log_success "已记录读取: $file"
        else
            log_warning "文件不存在: $file"
        fi
    done
}

# Verify workflow completion
verify_workflow() {
    log_info "正在验证工作流完成情况..."
    echo ""

    if [[ ! -f "$WORKFLOW_LOG" ]]; then
        log_error "未找到工作流日志"
        exit 1
    fi

    # Get current session
    local session_id=$(jq -r '.current_session' "$WORKFLOW_LOG")

    if [[ "$session_id" == "null" ]]; then
        log_warning "没有活动的工作流会话"
        echo ""
        echo "启动新工作流请使用:"
        echo "  $0 start -f \"file1.ts,file2.ts\""
        exit 0
    fi

    # Get session details
    local session=$(jq -r ".sessions[\"$session_id\"]" "$WORKFLOW_LOG")
    local status=$(echo "$session" | jq -r '.status')
    local files=$(echo "$session" | jq -r '.files')
    local modules=$(echo "$session" | jq -r '.modules')

    echo "会话: $session_id"
    echo "状态: $status"
    echo "文件: $files"
    echo "模块: $modules"
    echo ""

    # Check required documents
    if [[ -n "$files" ]]; then
        FILES="$files"
        check_workflow
    elif [[ -n "$modules" ]]; then
        MODULES="$modules"
        check_workflow_for_modules
    fi
}

# Main function
main() {
    case "$ACTION" in
        check)
            check_workflow
            ;;
        start)
            start_workflow
            ;;
        complete)
            complete_workflow
            ;;
        record)
            record_document_reading
            ;;
        verify)
            verify_workflow
            ;;
        *)
            log_error "未知操作: $ACTION"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main
