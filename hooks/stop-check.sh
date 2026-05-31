#!/bin/bash

# Stop Hook: 检查是否完成了文档归档
# 在 Claude Code 停止前运行，确保文档已归档

set -e

# 配置
DOCS_DIR="ai-context"
WORKFLOW_LOG="$DOCS_DIR/.workflow-log.json"

# 检查工作流日志是否存在
if [[ ! -f "$WORKFLOW_LOG" ]]; then
    exit 0
fi

# 获取当前会话
SESSION_ID=$(jq -r '.current_session // empty' "$WORKFLOW_LOG" 2>/dev/null)

if [[ -z "$SESSION_ID" ]] || [[ "$SESSION_ID" == "null" ]]; then
    exit 0
fi

# 获取会话状态
SESSION_STATUS=$(jq -r ".sessions[\"$SESSION_ID\"].status // empty" "$WORKFLOW_LOG" 2>/dev/null)

# 如果会话还在进行中，警告 AI
if [[ "$SESSION_STATUS" == "in_progress" ]]; then
    SESSION=$(jq -r ".sessions[\"$SESSION_ID\"]" "$WORKFLOW_LOG" 2>/dev/null)
    FILES_MODIFIED=$(echo "$SESSION" | jq -r '.files_modified // [] | length' 2>/dev/null)
    FILES_LIST=$(echo "$SESSION" | jq -r '.files_modified // [] | join(", ")' 2>/dev/null)

    if [[ "$FILES_MODIFIED" -gt 0 ]]; then
        echo "" >&2
        echo "⚠️  警告：工作流会话未完成！" >&2
        echo "" >&2
        echo "检测到 $FILES_MODIFIED 个文件被修改，但文档尚未归档。" >&2
        echo "" >&2
        echo "修改的文件：" >&2
        echo "  $FILES_LIST" >&2
        echo "" >&2
        echo "🔧 AI 必须执行以下命令完成归档：" >&2
        echo "  ./scripts/record-changes.sh \"描述你的修改\"" >&2
        echo "" >&2
        echo "或者运行：" >&2
        echo "  ./hooks/force-archive.sh" >&2
        echo "" >&2
        echo "❌ 如果不归档，下次编辑代码时将被阻止。" >&2
        echo "" >&2
    fi
fi

exit 0
