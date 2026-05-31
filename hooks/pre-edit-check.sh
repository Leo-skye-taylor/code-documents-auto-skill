#!/bin/bash

# Pre-edit Hook: 检查是否已读取相关文档
# 如果检查失败，退出码非零，阻止编辑操作

set -e

# 配置
DOCS_DIR="ai-context"
WORKFLOW_LOG="$DOCS_DIR/.workflow-log.json"

# 获取即将编辑的文件
TOOL_INPUT="${TOOL_INPUT:-}"
FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // .path // empty' 2>/dev/null || echo "")

# 如果无法获取文件路径，允许继续（可能是其他工具）
if [[ -z "$FILE_PATH" ]]; then
    exit 0
fi

# 检查是否是 ai-context 目录下的文件（允许编辑文档）
if [[ "$FILE_PATH" == *"$DOCS_DIR"* ]]; then
    exit 0
fi

# 检查是否是源代码文件
if [[ ! "$FILE_PATH" =~ \.(ts|tsx|js|jsx|py|java|go|rs|rb|php|c|cpp|h|hpp)$ ]]; then
    exit 0
fi

# 提取文件所属的模块
MODULE=$(echo "$FILE_PATH" | sed -n 's|.*/src/\([^/]*\)/.*|\1|p')

# 检查工作流日志是否存在
if [[ ! -f "$WORKFLOW_LOG" ]]; then
    echo "❌ 错误：未找到工作流日志" >&2
    echo "" >&2
    echo "🔧 AI 必须执行以下命令：" >&2
    echo "  ./scripts/enforce-workflow.sh start -f \"$FILE_PATH\" -m \"$MODULE\"" >&2
    echo "" >&2
    echo "📖 必须读取的文档：" >&2
    echo "  - ai-context/architecture.md" >&2
    echo "  - ai-context/guidelines/README.md" >&2
    if [[ -n "$MODULE" ]]; then
        echo "  - ai-context/modules/$MODULE/README.md" >&2
    fi
    echo "" >&2
    exit 1
fi

# 检查是否有活动的工作流会话
SESSION_ID=$(jq -r '.current_session // empty' "$WORKFLOW_LOG" 2>/dev/null)

if [[ -z "$SESSION_ID" ]] || [[ "$SESSION_ID" == "null" ]]; then
    echo "❌ 错误：没有活动的工作流会话" >&2
    echo "" >&2
    echo "🔧 AI 必须执行以下命令：" >&2
    echo "  ./scripts/enforce-workflow.sh start -f \"$FILE_PATH\" -m \"$MODULE\"" >&2
    echo "" >&2
    echo "📖 必须读取的文档：" >&2
    echo "  - ai-context/architecture.md" >&2
    echo "  - ai-context/guidelines/README.md" >&2
    if [[ -n "$MODULE" ]]; then
        echo "  - ai-context/modules/$MODULE/README.md" >&2
    fi
    echo "" >&2
    exit 1
fi

# 检查会话状态
SESSION_STATUS=$(jq -r ".sessions[\"$SESSION_ID\"].status // empty" "$WORKFLOW_LOG" 2>/dev/null)

if [[ "$SESSION_STATUS" != "in_progress" ]]; then
    echo "❌ 错误：工作流会话未激活" >&2
    echo "" >&2
    echo "当前状态：$SESSION_STATUS" >&2
    echo "" >&2
    echo "🔧 AI 必须执行以下命令：" >&2
    echo "  ./scripts/enforce-workflow.sh start -f \"$FILE_PATH\" -m \"$MODULE\"" >&2
    echo "" >&2
    exit 1
fi

# 检查是否已读取必需的文档
READING_LOG="$DOCS_DIR/.reading-log.json"

if [[ ! -f "$READING_LOG" ]]; then
    echo "❌ 错误：未找到读取日志" >&2
    echo "" >&2
    echo "🔧 AI 必须执行以下命令：" >&2
    echo "  ./scripts/enforce-workflow.sh start -f \"$FILE_PATH\" -m \"$MODULE\"" >&2
    echo "" >&2
    echo "📖 必须读取的文档：" >&2
    echo "  - ai-context/architecture.md" >&2
    echo "  - ai-context/guidelines/README.md" >&2
    if [[ -n "$MODULE" ]]; then
        echo "  - ai-context/modules/$MODULE/README.md" >&2
    fi
    echo "" >&2
    exit 1
fi

# 检查模块文档是否已读取
if [[ -n "$MODULE" ]]; then
    MODULE_DOC="$DOCS_DIR/modules/$MODULE/README.md"
    if [[ -f "$MODULE_DOC" ]]; then
        if ! jq -e ".readings[\"$MODULE_DOC\"]" "$READING_LOG" >/dev/null 2>&1; then
            echo "❌ 错误：未读取模块文档" >&2
            echo "" >&2
            echo "🔧 AI 必须执行以下命令：" >&2
            echo "  cat $MODULE_DOC" >&2
            echo "" >&2
            echo "然后记录读取：" >&2
            echo "  ./scripts/enforce-workflow.sh record -f \"$MODULE_DOC\"" >&2
            echo "" >&2
            exit 1
        fi
    fi
fi

# 检查架构文档是否已读取
ARCH_DOC="$DOCS_DIR/architecture.md"
if [[ -f "$ARCH_DOC" ]]; then
    if ! jq -e ".readings[\"$ARCH_DOC\"]" "$READING_LOG" >/dev/null 2>&1; then
        echo "❌ 错误：未读取架构文档" >&2
        echo "" >&2
        echo "🔧 AI 必须执行以下命令：" >&2
        echo "  cat $ARCH_DOC" >&2
        echo "" >&2
        echo "然后记录读取：" >&2
        echo "  ./scripts/enforce-workflow.sh record -f \"$ARCH_DOC\"" >&2
        echo "" >&2
        exit 1
    fi
fi

# 检查编码规范是否已读取
GUIDELINES_DOC="$DOCS_DIR/guidelines/README.md"
if [[ -f "$GUIDELINES_DOC" ]]; then
    if ! jq -e ".readings[\"$GUIDELINES_DOC\"]" "$READING_LOG" >/dev/null 2>&1; then
        echo "❌ 错误：未读取编码规范" >&2
        echo "" >&2
        echo "🔧 AI 必须执行以下命令：" >&2
        echo "  cat $GUIDELINES_DOC" >&2
        echo "" >&2
        echo "然后记录读取：" >&2
        echo "  ./scripts/enforce-workflow.sh record -f \"$GUIDELINES_DOC\"" >&2
        echo "" >&2
        exit 1
    fi
fi

# 所有检查通过
echo "✅ 文档读取验证通过" >&2
exit 0
