#!/bin/bash

# Post-edit Hook: 强制归档/生成文档
# 编辑完成后自动触发，生成变更记录和更新文档

set -e

# 配置
SKILL_DIR="$HOME/.claude/skills/code-documents-auto-skill"
DOCS_DIR=".ai-context"
WORKFLOW_LOG="$DOCS_DIR/.workflow-log.json"
CHANGELOG_DIR="$DOCS_DIR/changelog"

# 获取编辑的文件
TOOL_INPUT="${TOOL_INPUT:-}"
FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // .path // empty' 2>/dev/null || echo "")

# 如果无法获取文件路径，跳过
if [[ -z "$FILE_PATH" ]]; then
    exit 0
fi

# 检查是否是 ai-context 目录下的文件（跳过文档编辑）
if [[ "$FILE_PATH" == *"$DOCS_DIR"* ]]; then
    exit 0
fi

# 检查是否是源代码文件
if [[ ! "$FILE_PATH" =~ \.(ts|tsx|js|jsx|py|java|go|rs|rb|php|c|cpp|h|hpp)$ ]]; then
    exit 0
fi

# 提取文件所属的模块
# 支持 Java/Maven/Gradle 项目结构
if [[ "$FILE_PATH" == *"/src/main/java/"* ]] || [[ "$FILE_PATH" == "src/main/java/"* ]]; then
    # Java 项目：提取包名中的模块（如 controller、service、repository 等）
    MODULE=$(echo "$FILE_PATH" | sed -n 's|.*src/main/java/[^/]*/[^/]*/[^/]*/\([^/]*\)/.*|\1|p')
else
    # 其他项目：提取 src 下的直接子目录
    MODULE=$(echo "$FILE_PATH" | sed -n 's|.*/src/\([^/]*\)/.*|\1|p')
fi

# 记录到工作流会话
if [[ -f "$WORKFLOW_LOG" ]]; then
    SESSION_ID=$(jq -r '.current_session // empty' "$WORKFLOW_LOG" 2>/dev/null)

    # 如果没有活动会话，自动创建一个
    if [[ -z "$SESSION_ID" ]] || [[ "$SESSION_ID" == "null" ]]; then
        SESSION_ID="session_$(date +%Y%m%d_%H%M%S)"
        TEMP_FILE=$(mktemp)
        jq --arg session_id "$SESSION_ID" \
           --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
           '.sessions[$session_id] = {
              "started": $timestamp,
              "files": "",
              "modules": "",
              "operation_type": "both",
              "status": "in_progress",
              "files_modified": [],
              "documents_read": [],
              "documents_generated": []
            } | .current_session = $session_id' "$WORKFLOW_LOG" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$WORKFLOW_LOG"
        echo "📝 已自动创建会话：$SESSION_ID" >&2
    fi

    # 将文件添加到会话的修改文件列表
    TEMP_FILE=$(mktemp)
    jq --arg session_id "$SESSION_ID" \
       --arg file "$FILE_PATH" \
       '.sessions[$session_id].files_modified = (.sessions[$session_id].files_modified // []) + [$file] | .current_session = $session_id' \
       "$WORKFLOW_LOG" > "$TEMP_FILE"
    mv "$TEMP_FILE" "$WORKFLOW_LOG"

    echo "📝 已记录修改：$FILE_PATH" >&2
fi

# 如果有模块信息，更新模块文档
if [[ -n "$MODULE" ]]; then
    MODULE_DOC="$DOCS_DIR/modules/$MODULE/README.md"

    if [[ -f "$MODULE_DOC" ]]; then
        # 检查是否已有最近更新部分
        if ! grep -q "## 最近更新" "$MODULE_DOC"; then
            echo "" >> "$MODULE_DOC"
            echo "## 最近更新" >> "$MODULE_DOC"
            echo "" >> "$MODULE_DOC"
        fi

        # 添加更新记录
        TIMESTAMP=$(date +%Y-%m-%d)
        ENTRY="- $TIMESTAMP: 修改了 \`$(basename "$FILE_PATH")\`"

        # 在最近更新部分添加条目
        sed -i '' "/## 最近更新/a\\
$ENTRY
" "$MODULE_DOC"

        echo "📄 已更新模块文档：$MODULE_DOC" >&2
    fi
fi

# 提示 AI 需要完成归档
echo "" >&2
echo "⚠️  警告：代码已修改，必须完成文档归档！" >&2
echo "" >&2
echo "🔧 AI 必须执行以下命令完成归档：" >&2
echo "  bash $SKILL_DIR/scripts/record-changes.sh \"描述你的修改\"" >&2
echo "" >&2
echo "或者运行：" >&2
echo "  bash $SKILL_DIR/hooks/force-archive.sh" >&2
echo "" >&2
echo "📝 必须更新的文档：" >&2
if [[ -n "$MODULE" ]]; then
    echo "  - .ai-context/modules/$MODULE/README.md" >&2
fi
echo "  - .ai-context/changelog/$(date +%Y-%m-%d)-*.md" >&2
echo "" >&2
echo "❌ 如果不归档，下次编辑代码时将被阻止。" >&2
echo "" >&2

exit 0
