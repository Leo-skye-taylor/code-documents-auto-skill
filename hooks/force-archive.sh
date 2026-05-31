#!/bin/bash

# 强制归档脚本
# 在代码修改后强制生成完整的文档归档

set -e

# 配置
DOCS_DIR="ai-context"
WORKFLOW_LOG="$DOCS_DIR/.workflow-log.json"
CHANGELOG_DIR="$DOCS_DIR/changelog"
DECISIONS_DIR="$DOCS_DIR/decisions"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# 检查工作流日志
if [[ ! -f "$WORKFLOW_LOG" ]]; then
    log_error "未找到工作流日志"
    log_error "请先运行 /docs-read 启动工作流"
    exit 1
fi

# 获取当前会话
SESSION_ID=$(jq -r '.current_session // empty' "$WORKFLOW_LOG" 2>/dev/null)

if [[ -z "$SESSION_ID" ]] || [[ "$SESSION_ID" == "null" ]]; then
    log_error "没有活动的工作流会话"
    log_error "请先运行 /docs-read 启动工作流"
    exit 1
fi

# 获取会话信息
SESSION=$(jq -r ".sessions[\"$SESSION_ID\"]" "$WORKFLOW_LOG" 2>/dev/null)
FILES_MODIFIED=$(echo "$SESSION" | jq -r '.files_modified // [] | join(",")' 2>/dev/null)
MODULES=$(echo "$SESSION" | jq -r '.modules // ""' 2>/dev/null)

if [[ -z "$FILES_MODIFIED" ]] || [[ "$FILES_MODIFIED" == "null" ]]; then
    log_warning "没有记录到修改的文件"
    log_warning "请使用 /docs-record 命令手动记录变更"
    exit 0
fi

log_info "开始强制归档..."
log_info "修改的文件: $FILES_MODIFIED"
echo ""

# 生成变更记录
TIMESTAMP=$(date +%Y-%m-%d)
CHANGE_RECORD="$CHANGELOG_DIR/${TIMESTAMP}-auto-archive.md"

cat > "$CHANGE_RECORD" << EOF
---
date: $TIMESTAMP
type: auto-archive
title: "自动归档 - 代码修改"
author: "AI 助手"
modules: [$(echo "$MODULES" | tr ',' ', ')]
impact: medium
status: completed
---

# 自动归档 - 代码修改

## 摘要

自动归档的代码修改记录。

## 修改的文件

$(echo "$FILES_MODIFIED" | tr ',' '\n' | sed 's/^/- /')

## 变更详情

### 修改内容
- 请补充具体的修改内容

### 修改原因
- 请补充修改的原因

### 影响分析
- 请补充影响分析

## 文档更新

- [x] 变更记录已生成
- [ ] 模块文档已更新
- [ ] 功能文档已更新
- [ ] API 文档已更新

## 后续步骤

1. 审查并完善此变更记录
2. 补充具体的修改内容和原因
3. 更新相关的模块文档
4. 获取审查者的签字确认

## 决策记录

如果这次修改涉及重要决策，请在 \`ai-context/decisions/\` 目录下创建决策记录。

EOF

log_success "变更记录已生成: $CHANGE_RECORD"

# 更新模块文档
IFS=',' read -ra FILE_ARRAY <<< "$FILES_MODIFIED"
UPDATED_MODULES=()

for file in "${FILE_ARRAY[@]}"; do
    MODULE=$(echo "$file" | sed -n 's|.*/src/\([^/]*\)/.*|\1|p')

    if [[ -n "$MODULE" ]] && [[ ! " ${UPDATED_MODULES[@]} " =~ " ${MODULE} " ]]; then
        MODULE_DOC="$DOCS_DIR/modules/$MODULE/README.md"

        if [[ -f "$MODULE_DOC" ]]; then
            # 检查是否已有最近更新部分
            if ! grep -q "## 最近更新" "$MODULE_DOC"; then
                echo "" >> "$MODULE_DOC"
                echo "## 最近更新" >> "$MODULE_DOC"
                echo "" >> "$MODULE_DOC"
            fi

            # 添加更新记录
            ENTRY="- $TIMESTAMP: 自动归档 - 修改了 \`$(basename "$file")\`"

            # 在最近更新部分添加条目
            sed -i '' "/## 最近更新/a\\
$ENTRY
" "$MODULE_DOC"

            UPDATED_MODULES+=("$MODULE")
            log_success "已更新模块文档: $MODULE_DOC"
        fi
    fi
done

# 完成工作流会话
TEMP_FILE=$(mktemp)
jq --arg session_id "$SESSION_ID" \
   --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
   '.sessions[$session_id].status = "completed" |
    .sessions[$session_id].completed = $timestamp |
    .current_session = null' "$WORKFLOW_LOG" > "$TEMP_FILE"
mv "$TEMP_FILE" "$WORKFLOW_LOG"

log_success "工作流会话已完成"

echo ""
echo "=========================================="
echo "强制归档完成"
echo "=========================================="
echo ""
echo "已生成的文件:"
echo "  - $CHANGE_RECORD"
echo ""
echo "已更新的模块:"
for module in "${UPDATED_MODULES[@]}"; do
    echo "  - $module"
done
echo ""
echo "后续步骤:"
echo "1. 审查并完善变更记录"
echo "2. 补充具体的修改内容和原因"
echo "3. 更新相关的功能/API 文档"
echo "4. 运行 /docs-read 启动新的工作流"
echo ""
