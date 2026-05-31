#!/bin/bash

# 设置强制规则脚本
# 将强制工作流规则追加到项目的 CLAUDE.md 和 AGENTS.md 文件

set -e

# 配置
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_MD="CLAUDE.md"
AGENTS_MD="AGENTS.md"

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

# 检查标记是否存在
has_marker() {
    local file="$1"
    local marker="$2"

    if [[ -f "$file" ]]; then
        grep -q "$marker" "$file" 2>/dev/null
        return $?
    fi
    return 1
}

# 追加 CLAUDE.md 内容
append_claude_md() {
    local target_file="$1"
    local marker="# CODE-DOCUMENTS-AUTO-RULES-START"
    local marker_end="# CODE-DOCUMENTS-AUTO-RULES-END"

    # 检查是否已存在
    if has_marker "$target_file" "$marker"; then
        log_warning "CLAUDE.md 中已存在强制规则，跳过"
        return 0
    fi

    log_info "追加强制规则到 CLAUDE.md..."

    # 追加内容
    cat >> "$target_file" << 'RULES_EOF'

# CODE-DOCUMENTS-AUTO-RULES-START
## 强制工作流规则（code-documents-auto-skill）

**CRITICAL: 以下规则是强制性的，不可跳过。**

### 规则 1：开发前必须读取文档

**当请求修改代码时，必须：**

1. **识别影响范围**
   - 分析要修改的文件
   - 确定涉及的模块
   - 确定涉及的功能

2. **自动读取相关文档**
   - 读取架构文档：`ai-context/architecture.md`
   - 读取编码规范：`ai-context/guidelines/README.md`
   - 读取模块文档：`ai-context/modules/[模块名]/README.md`
   - 读取功能文档：`ai-context/features/[功能名]/README.md`（如果存在）
   - 读取 API 文档：`ai-context/api/[API名]/README.md`（如果存在）

3. **启动工作流会话**
   ```bash
   ./scripts/enforce-workflow.sh start -f "文件列表" -m "模块列表"
   ```

4. **验证读取完成**
   ```bash
   ./scripts/enforce-workflow.sh check -f "文件列表"
   ```

5. **只有读取完成后才能编辑代码**

### 规则 2：开发后必须归档文档

**当代码修改完成后，必须：**

1. **生成变更记录**
   ```bash
   ./scripts/record-changes.sh "变更描述"
   ```

2. **更新相关文档**
   - 更新模块文档：`ai-context/modules/[模块名]/README.md`
   - 更新功能文档：`ai-context/features/[功能名]/README.md`（如果存在）
   - 更新 API 文档：`ai-context/api/[API名]/README.md`（如果存在）

3. **完成工作流会话**
   ```bash
   ./scripts/enforce-workflow.sh complete -f "修改的文件列表"
   ```

4. **只有归档完成后才能继续其他工作**

### 规则 3：禁止跳过任何步骤

**以下行为是严格禁止的：**

- ❌ 跳过文档读取直接编辑代码
- ❌ 跳过文档归档直接结束工作
- ❌ 忽略 hooks 的警告信息
- ❌ 不记录工作流会话

### 快速参考

```bash
# 读取文档
cat ai-context/architecture.md
cat ai-context/guidelines/README.md
cat ai-context/modules/[模块名]/README.md

# 工作流命令
./scripts/enforce-workflow.sh start -f "文件列表" -m "模块列表"
./scripts/enforce-workflow.sh check -f "文件列表"
./scripts/enforce-workflow.sh complete -f "修改的文件列表"

# 归档命令
./scripts/record-changes.sh "变更描述"
./hooks/force-archive.sh
```

# CODE-DOCUMENTS-AUTO-RULES-END
RULES_EOF

    log_success "已追加强制规则到 CLAUDE.md"
}

# 追加 AGENTS.md 内容
append_agents_md() {
    local target_file="$1"
    local marker="# CODE-DOCUMENTS-AUTO-AGENTS-START"
    local marker_end="# CODE-DOCUMENTS-AUTO-AGENTS-END"

    # 检查是否已存在
    if has_marker "$target_file" "$marker"; then
        log_warning "AGENTS.md 中已存在 Agent 规则，跳过"
        return 0
    fi

    log_info "追加 Agent 规则到 AGENTS.md..."

    # 追加内容
    cat >> "$target_file" << 'AGENTS_EOF'

# CODE-DOCUMENTS-AUTO-AGENTS-START
## Code Documents Auto Agent 规则

### CodeEditor Agent（代码编辑 Agent）

**职责**：执行代码修改任务

**强制规则**：

#### 开发前（必须执行）

```yaml
步骤 1: 识别影响范围
  - 分析要修改的文件路径
  - 确定涉及的模块（从路径提取）
  - 确定涉及的功能

步骤 2: 自动读取文档
  必读文档:
    - ai-context/architecture.md
    - ai-context/guidelines/README.md
    - ai-context/modules/{module}/README.md

  条件读取:
    - ai-context/features/{feature}/README.md（如果存在）
    - ai-context/api/{api}/README.md（如果存在）

步骤 3: 启动工作流
  命令: ./scripts/enforce-workflow.sh start -f "{files}" -m "{modules}"

步骤 4: 验证读取
  命令: ./scripts/enforce-workflow.sh check -f "{files}"
  要求: 必须返回成功才能继续
```

#### 开发中（执行修改）

```yaml
步骤 5: 执行代码修改
  - 使用 Edit 工具修改代码
  - 遵循编码规范
  - 保持代码风格一致
```

#### 开发后（必须执行）

```yaml
步骤 6: 生成变更记录
  命令: ./scripts/record-changes.sh "{description}"

步骤 7: 更新模块文档
  文件: ai-context/modules/{module}/README.md
  内容: 添加最近更新记录

步骤 8: 完成工作流
  命令: ./scripts/enforce-workflow.sh complete -f "{modified_files}"

步骤 9: 验证归档
  - 确认变更记录已生成
  - 确认模块文档已更新
  - 确认工作流会话已完成
```

### DocumentReader Agent（文档读取 Agent）

**职责**：读取和理解项目文档

**强制规则**：

```yaml
读取顺序:
  1. ai-context/README.md（项目概览）
  2. ai-context/architecture.md（系统架构）
  3. ai-context/guidelines/README.md（编码规范）
  4. ai-context/modules/{module}/README.md（模块文档）

读取要求:
  - 必须完整读取，不能跳过
  - 必须理解内容
  - 必须记录读取状态

输出:
  - 读取确认
  - 关键信息摘要
  - 影响分析
```

### DocumentWriter Agent（文档写入 Agent）

**职责**：生成和更新项目文档

**强制规则**：

```yaml
生成文档:
  变更记录:
    位置: ai-context/changelog/
    格式: YYYY-MM-DD-{type}-{name}.md
    内容: 完整的变更记录

  模块文档:
    位置: ai-context/modules/{module}/README.md
    内容: 最近更新记录

  决策记录:
    位置: ai-context/decisions/
    格式: YYYY-MM-DD-{decision}.md
    内容: 重要决策记录

更新要求:
  - 必须更新所有相关文档
  - 必须保持文档一致性
  - 必须记录完整信息
```

### Agent 交互流程

```
用户请求
    ↓
CodeEditor Agent 启动
    ↓
DocumentReader Agent 读取文档
    ↓
CodeEditor Agent 执行修改
    ↓
DocumentWriter Agent 生成文档
    ↓
CodeEditor Agent 完成工作流
    ↓
返回结果给用户
```

### 强制检查点

```yaml
检查点 1: 开发前
  - 工作流会话是否活跃？
  - 必需文档是否已读取？
  - 如果失败: 阻止编辑，提示读取文档

检查点 2: 开发后
  - 变更记录是否已生成？
  - 模块文档是否已更新？
  - 工作流会话是否已完成？
  - 如果失败: 提示完成归档

检查点 3: 停止前
  - 是否有未归档的修改？
  - 如果失败: 警告需要归档
```
# CODE-DOCUMENTS-AUTO-AGENTS-END
AGENTS_EOF

    log_success "已追加 Agent 规则到 AGENTS.md"
}

# 主函数
main() {
    log_info "设置强制工作流规则..."
    echo ""

    # 检查是否在项目根目录
    if [[ ! -d "ai-context" ]] && [[ ! -d "scripts" ]]; then
        log_warning "未检测到 ai-context 目录或 scripts 目录"
        log_warning "请在项目根目录运行此脚本"
        echo ""
        read -p "是否继续？(y/N): " confirm
        if [[ "$confirm" != "y" ]] && [[ "$confirm" != "Y" ]]; then
            log_info "已取消"
            exit 0
        fi
    fi

    # 处理 CLAUDE.md
    if [[ -f "$CLAUDE_MD" ]]; then
        log_info "检测到已存在的 CLAUDE.md"
        append_claude_md "$CLAUDE_MD"
    else
        log_info "创建新的 CLAUDE.md"
        append_claude_md "$CLAUDE_MD"
    fi

    echo ""

    # 处理 AGENTS.md
    if [[ -f "$AGENTS_MD" ]]; then
        log_info "检测到已存在的 AGENTS.md"
        append_agents_md "$AGENTS_MD"
    else
        log_info "创建新的 AGENTS.md"
        append_agents_md "$AGENTS_MD"
    fi

    echo ""
    log_success "强制规则设置完成！"
    echo ""
    echo "已更新的文件："
    echo "  - $CLAUDE_MD（追加强制工作流规则）"
    echo "  - $AGENTS_MD（追加 Agent 行为规则）"
    echo ""
    echo "后续步骤："
    echo "  1. 审查追加的规则"
    echo "  2. 根据需要调整规则内容"
    echo "  3. 运行 /docs-scan 扫描代码库"
    echo ""
}

# 运行主函数
main
