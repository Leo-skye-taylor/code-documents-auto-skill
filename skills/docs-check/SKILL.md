---
name: docs-check
description: >
  检测 .ai-context/ 目录结构是否为最新版本，发现问题自动迁移到新格式。检查 changelog 格式、表格列、docs/ 子目录等。
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
---

# /docs-check — 检测文档结构并自动迁移

**当用户输入 `/docs-check` 时，执行以下完整流程：**

> ⚠️ 本命令**检测到问题会自动迁移**，无需用户确认。
> 如需仅检测不修复，请使用 `/docs-check --report` 模式。

## 步骤 1：检查前置条件

- 检查 `.ai-context/` 目录是否存在
- 如果不存在，提示用户先运行 `/docs-scan` 生成文档

## 步骤 2：检测 changelog 目录结构

使用 Bash 工具列出 `changelog/` 下的所有条目：

```bash
ls -la .ai-context/changelog/
```

**判断规则**：

| 条目类型 | 是否新格式 | 状态 |
|----------|------------|------|
| `{date}-{name}/` 文件夹 | ✅ 新格式 | 跳过 |
| `{date}-{name}.md` 单文件 | ❌ 旧格式 | **需要迁移** |
| 混合存在 | ⚠️ 部分迁移 | **需要迁移旧文件** |

**记录所有非新格式的条目**到迁移列表。

## 步骤 3：检测 changelog/README.md 表格格式

读取 `changelog/README.md`，定位"变更历史"或"最近变更"表格。

**检查表格列头**，判断格式版本：

| 列头模式 | 版本 | 状态 |
|----------|------|------|
| `日期 \| 标题 \| 描述 \| 类型 \| 模块 \| 作者 \| 状态 \| 详情` | v3.1.1+ | ✅ 最新 |
| `日期 \| 类型 \| 标题 \| 作者 \| 状态` | v3.1.0 及之前 | ❌ **需要迁移** |
| `日期 \| 标题 \| 类型 \| 模块 \| 作者 \| 状态 \| 详情` | v3.1.0 | ⚠️ **需要补"描述"列** |

## 步骤 4：检测 docs/ 子目录

对每个 changelog 文件夹，检查 `docs/` 子目录结构：

```bash
ls -la .ai-context/changelog/*/docs/ 2>/dev/null
```

**标准结构**：

```
docs/
├── requirements/
├── technical/
├── testing/
├── design/
└── other/
```

如果 `docs/` 不存在，标记为**可创建**。
如果子目录缺失，创建对应子目录。

## 步骤 4.5：检测项目已有文档并询问归类（**批量处理**）

> 🔴 **关键规则：必须一次性扫描 → 一次性询问 → 一次性归类。禁止逐个文件询问。**

### 触发逻辑

| 当前状态 | 是否询问 |
|----------|----------|
| docs/ 不存在 | ✅ 询问 |
| docs/ 存在但子目录全空 | ✅ 询问 |
| docs/ 存在且已有内容 | ⚠️ 询问是否增量归类（只填空的子目录） |
| 项目下没有任何 .md | ❌ 跳过 |

### 4.5.1 一次性扫描所有待归类文件

**使用 Glob 工具**（不是逐个 find），扫描以下扩展名：

```
# 文档
**/*.md

# 图片
**/*.png
**/*.jpg
**/*.jpeg
**/*.gif
**/*.webp
**/*.svg
```

然后**过滤掉**（不是逐个判断）：
- `.ai-context/**`
- `node_modules/**`
- `dist/**`
- `build/**`
- `.git/**`
- `.claude/**`
- **`CLAUDE.md`**（工作流规则文件，不归类）
- **`AGENTS.md`**（AI Agent 规则文件，不归类）
- 项目 favicon（仅 `favicon.ico`、`favicon.png`、`favicon.svg` 等以 `favicon` 开头）— 浏览器标签图标，工程资源不归类

> ⚠️ **`logo.*`、`icon.*`、`icon-*.*`、`*-icon.*` 等 UI 图标不要排除**——它们是设计资产，应当归类到 `design/`（参见 4.5.2）。

**得到完整待归类文件列表**（比如 N 个）。

### 4.5.2 一次性智能归类所有文件

**批量分析**所有 N 个文件，构建完整归类映射表：

```python
mapping = {
    # 文档
    "README.md": "other/",
    "docs/PRD.md": "requirements/",
    "docs/architecture.md": "technical/",
    "docs/test-report.md": "testing/",
    "docs/ui-mockup.md": "design/",
    "docs/meeting-notes.md": "other/",

    # 图片
    "docs/architecture-diagram.png": "technical/",
    "docs/ui-mockup.png": "design/",
    "docs/figma-export.jpg": "design/",
    "docs/test-screenshot.png": "testing/",
    "docs/flowchart.svg": "design/",
    "icon.svg": "design/",          # UI 图标归 design/
    "logo.svg": "design/",          # 项目 logo 归 design/（如需保留原位可让用户选择）
    # ... 一次性分析完所有 N 个
}
```

**关键词规则（文档 + 图片通用）：**

| 关键词 | 归类到 |
|--------|--------|
| `requirement`、`prd`、`需求`、`用户故事` | `requirements/` |
| `architecture`、`tech`、`api`、`架构`、`技术方案`、`er-diagram`、`schema` | `technical/` |
| `test`、`testing`、`测试`、`qa`、`screenshot`、`截图`、`bug`、`问题` | `testing/` |
| `ui`、`mockup`、`prototype`、`figma`、`设计稿`、`flowchart`、`流程图`、`diagram`、`icon`、`logo`、`图标` | `design/` |
| `meeting`、`notes`、`纪要`、`readme`、`参考` | `other/` |
| 其他文档（.md） | `other/`（默认） |
| 其他图片（.png/.jpg/.svg/...） | `design/`（默认，因图片多与设计相关） |

**图片归类的特殊规则：**

- 默认图片归到 `design/`（因为图片大多是 UI 设计、流程图、架构图）
- 文件名含 `screenshot`/`截图`/`bug` 优先归到 `testing/`
- 文件名含 `architecture`/`er-diagram`/`api` 优先归到 `technical/`
- 文件名含 `flowchart`/`流程图`/`mockup` 归到 `design/`

### 4.5.3 一次性询问用户（关键！）

> 🔴 **必须用 AskUserQuestion 工具一次性询问**。
> ❌ 禁止：numbered menu、逐个确认、每个文件单独问。

**AskUserQuestion 调用示例**：

```python
AskUserQuestion(
    question=f"检测到项目下有 {N} 个待归类文件（含 {M} 个文档 + {K} 个图片），是否批量归类？",
    options=[
        {
            "label": "✅ 全部归类",
            "description": f"将 {N} 个文件一次性移动到 docs/（requirements: X, technical: Y, testing: Z, design: A, other: B）"
        },
        {
            "label": "🔧 选择性归类",
            "description": "我会列出每个文件的归类建议，你选择具体哪些要归类"
        },
        {
            "label": "❌ 不归类",
            "description": "保持原文件位置不变，不创建 docs/ 子目录"
        }
    ]
)
```

**等待用户回答**（一次回答处理所有文件）。

### 4.5.4 一次性执行归类

**根据用户选择执行**：

**用户选择"全部归类"**：

```bash
# 一次性创建所有子目录
mkdir -p .ai-context/changelog/{date}-initial-scan/docs/{requirements,technical,testing,design,other}

# 一次性移动所有文件（mv 而非 cp，原文件位置不保留）
for src, category in mapping.items():
    mv "$src" ".ai-context/changelog/{date}-initial-scan/docs/$category/"
done
```

> 🔴 **关键：使用 `mv` 移动，不是 `cp` 复制**。归类后原文件位置不应保留。

**用户选择"选择性归类"**：

按用户指定的子集执行，**仍然是一次性执行**（不再追问）。

**用户选择"不归类"**：

- 跳过步骤 6.3 的"创建缺失子目录"
- 在最终报告里标注"用户已拒绝归类，docs/ 未创建"
- **不再次询问**

### 4.5.5 输出批量归类报告（一次性）

```
✅ 批量归类完成

归类统计：
- requirements/: X 个
- technical/: Y 个
- testing/: Z 个
- design/: A 个
- other/: B 个
- 总计: N 个

已复制的文件：
- README.md → docs/other/
- docs/PRD.md → docs/requirements/
- docs/architecture.md → docs/technical/
- ...
```

## 步骤 5：检测标题填写质量

读取最近 3 条 changelog 记录的"标题"列，检查是否填写具体描述：

**判断规则**：
- 标题只包含 `feat`/`fix`/`refactor`/`docs`/`chore` 等类型词 → ❌ **需要改进**（自动改用文件夹名作为标题）
- 标题包含具体动作 → ✅ 合格

## 步骤 6：执行自动迁移

> 🔧 **检测到问题后自动执行以下迁移操作**：

### 6.1 迁移旧格式 changelog（单文件 → 文件夹）

对每个旧格式的单文件 `{date}-{name}.md`：

1. **创建文件夹** `.ai-context/changelog/{date}-{name}/`
2. **拆分单文件内容到 6 个核心文档**：

   | 原始章节 | 目标文件 |
   |----------|----------|
   | 概述/背景/需求 | `overview.md` |
   | 文件清单/变更列表 | `files.md` |
   | 技术细节/实现 | `technical.md` |
   | 影响范围/兼容性 | `impact.md` |
   | 测试/验证 | `testing.md` |
   | 部署/回滚 | `deployment.md` |

3. **拆分规则**：
   - 读取原文件全部内容
   - 按 H2 标题（`##`）切分段落
   - 将每个段落写入对应文件
   - 如无明确章节，按默认分配（首段→overview，其余→technical）

4. **创建空的 docs/ 子目录**（如果不存在）

5. **删除原单文件** `rm {date}-{name}.md`

### 6.2 升级 changelog/README.md 表格格式

**情况 A：5 列旧格式 → 8 列新格式**

```diff
- | 日期 | 类型 | 标题 | 作者 | 状态 |
+ | 日期 | 标题 | 描述 | 类型 | 模块 | 作者 | 状态 | 详情 |
```

**情况 B：7 列缺"描述"列 → 8 列**

在"标题"和"类型"之间插入"描述"列。

### 6.3 创建缺失的 docs/ 子目录

> ⚠️ **仅当步骤 4.5 用户拒绝归类时执行**。

```bash
mkdir -p .ai-context/changelog/{folder}/docs/requirements
mkdir -p .ai-context/changelog/{folder}/docs/technical
mkdir -p .ai-context/changelog/{folder}/docs/testing
mkdir -p .ai-context/changelog/{folder}/docs/design
mkdir -p .ai-context/changelog/{folder}/docs/other
```

### 6.4 改进"标题"列质量

如果标题列只填了类型，使用文件夹名推断标题。

## 步骤 7：输出迁移报告

```
🔧 文档结构检测 + 迁移完成

检测时间：{当前时间}
文档位置：.ai-context/
当前插件版本：3.1.2

---

## 📊 总体状态

| 维度 | 检测前 | 检测后 |
|------|--------|--------|
| changelog 结构 | ❌ 旧格式 | ✅ 已迁移 |
| 表格格式 | ❌ 5 列 | ✅ 8 列 |
| docs/ 子目录 | ⚠️ 缺失 | ✅ 已创建 |
| 标题质量 | ⚠️ 不合格 | ✅ 已改进 |
| 项目文档归类 | ⚠️ 散落 | ✅ 已归类 |

---

## 🔧 已执行的迁移操作

### ✅ 1. 单文件 → 文件夹结构

| 旧文件 | 新文件夹 | 状态 |
|--------|----------|------|
| {date}-{name}.md | {date}-{name}/ | ✅ 已迁移 |

### ✅ 2. 表格格式升级

| 文件 | 旧列数 | 新列数 | 状态 |
|------|--------|--------|------|
| changelog/README.md | 5 | 8 | ✅ 已升级 |

### ✅ 3. 批量归类项目文档

| 分类 | 数量 | 文件 |
|------|------|------|
| requirements/ | X | {file1}, {file2} |
| technical/ | Y | {file3} |
| testing/ | Z | {file4} |
| design/ | A | {file5} |
| other/ | B | {file6}, {file7} |

### ✅ 4. docs/ 子目录创建（如未归类）

| changelog 文件夹 | 操作 | 状态 |
|------------------|------|------|
| {folder} | 创建 5 个子目录 | ✅ 已创建 |

### ✅ 5. 标题改进

| 文件 | 旧标题 | 新标题 | 状态 |
|------|--------|--------|------|
| changelog/README.md | "feat" | "添加 XX 功能" | ✅ 已改进 |

---

✅ 迁移完成！所有检测到的问题已自动修复。
```

## 仅检测模式（可选）

如需**只检测不修复**（保留旧格式用于人工处理），使用：

```
/docs-check --report
```

执行流程跳过步骤 6（自动迁移），只输出步骤 2-5 的检测报告。

## 注意事项

- 自动迁移**不可逆**，建议迁移前备份 `.ai-context/changelog/`
- 步骤 4.5 必须**批量**处理，不要逐个文件询问
- 拆分单文件时按 H2 章节切分，如章节不清晰可能需要手动调整
- 表格列升级会保留原"标题"列内容，"描述"列填入"—"占位
- docs/ 子目录是**空目录**，等待用户后续添加文档
