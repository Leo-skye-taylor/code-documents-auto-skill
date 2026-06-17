# 🚀 Code Documents Auto Skill

[![Version](https://img.shields.io/badge/version-3.2.0-blue.svg)](https://github.com/Leo-skye-taylor/code-documents-auto-skill)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude-Code-purple.svg)](https://claude.ai/code)

[English](#english) | [中文](#中文)

---

## English

### 🎯 What is this?

> **AI-driven code documentation management!**
>
> Just tell AI what you want to do, and it handles everything automatically.

```
┌─────────────────────────────────────────────────────────────┐
│                    🔄 Simple Workflow                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🆕 After Plugin Upgrade:                                   │
│  User: "/docs-check"                                        │
│      ↓                                                      │
│  🔧 AI detects & auto-migrates old docs structure           │
│      ↓                                                      │
│  ┌───────────────────────────────────────────────────┐      │
│  │  📂 New Project:                                  │      │
│  │  User: "/docs-scan"                               │      │
│  │      ↓                                            │      │
│  │  🤖 AI scans codebase and generates documentation │      │
│  │      ↓                                            │      │
│  │  User: "/docs-prepare add login feature"          │      │
│  │      ↓                                            │      │
│  │  📖 AI reads related docs and outputs dev plan    │      │
│  │      ↓                                            │      │
│  │  💻 User implements the feature                   │      │
│  │      ↓                                            │      │
│  │  User: "/docs-archive"                            │      │
│  │      ↓                                            │      │
│  │  📝 AI summarizes & updates all related docs      │      │
│  │      ↓                                            │      │
│  │  ✅ Documentation updated!                        │      │
│  └───────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### ✨ Features

| Feature | Description |
|---------|-------------|
| 🤖 **AI-Driven** | All analysis done by AI, not scripts |
| 📖 **Auto Read** | AI reads docs and outputs development plan before coding |
| 📝 **Auto Archive** | AI summarizes changes and updates all related docs |
| 🔄 **Incremental Update** | Support incremental updates, only update changed parts |
| 🔧 **Auto Migrate** | `/docs-check` detects outdated structure and auto-migrates to latest format |
| 📊 **Changelog System** | Complete changelog with statistics, history, and dev cycles |
| 🚀 **Multiple Commands** | `/docs`, `/docs-scan`, `/docs-update`, `/docs-check`, `/docs-prepare`, `/docs-archive` |

### 🆕 What's New in 3.2.0

- **UI Design Asset Support**: `icon.svg`, `logo.svg`, `icon-*.png` and other UI icons are now properly categorized into `docs/design/` instead of being excluded
- **Refined Asset Filtering**: Only `favicon.*` is treated as engineering resource (browser tab icon) — all other design assets are scanned and categorized
- **Icon/Logo Keyword Rules**: New keywords `icon`, `logo`, `图标` route matching files to `design/` (in addition to existing `ui`, `mockup`, `figma`, etc.)

### 🆕 What's New in 3.1.2

- **Doc Structure Check & Auto-Migration**: `/docs-check` - Detects outdated docs structure AND automatically migrates to latest format (one-shot)
- **Batch Doc Categorization**: One scan + one ask + one move for all project docs (no per-file prompts)
- **Smart File Move (not copy)**: Project docs are **moved** to docs/ subdirs, not copied (cleaner state)
- **Auto-Skip CLAUDE.md/AGENTS.md**: Workflow rule files are excluded from categorization
- **Frontend Project Detection**: `/docs-scan` now detects project category (frontend/backend/fullstack) and skips irrelevant docs

### 🆕 What's New in 3.1.1

- **Smart Assistant**: `/docs <description>` - AI automatically detects intent and executes the appropriate workflow
- **Bug Analysis**: Built-in bug detection and analysis capabilities
- **Doc Structure Check**: `/docs-check` - Detect if your existing docs use the latest format (after plugin upgrade)
- **Unified Command**: One command to handle all scenarios - development, bug finding, archiving, scanning, updating

### 📦 Installation

```bash
# Step 1: Add marketplace
/plugin marketplace add Leo-skye-taylor/code-documents-auto-skill

# Step 2: Install plugin
/plugin install code-documents-auto@code-documents-auto-skill
```

### 🔄 Update

When a new version is available, run:

```bash
# Uninstall old version
/plugin uninstall code-documents-auto@code-documents-auto-skill

# Clear cache (optional but recommended)
rm -rf ~/.claude/plugins/cache/code-documents-auto-skill

# Reinstall latest version
/plugin install code-documents-auto@code-documents-auto-skill
```

### 🆙 Upgrade Existing Project

If you're upgrading from an older version (e.g. v3.1.0 or earlier), run `/docs-check` once to auto-migrate your existing docs:

```bash
/docs-check
```

**What `/docs-check` does:**

| Action | Description |
|--------|-------------|
| 🔍 **Detects** | Scans `.ai-context/` for outdated structures |
| 📁 **Splits** | Single-file changelogs → folder with 6 core docs |
| 📊 **Upgrades** | 5-column old table → 8-column new format (with 描述) |
| 📂 **Creates** | Missing docs/ subdirectories (requirements/technical/testing/design/other) |
| 🏷️ **Improves** | Generic titles (just "feat") → descriptive titles from folder names |
| 📦 **Categorizes** | Batch-moves project docs to docs/ subdirs (one prompt, not per-file) |

**Migration example:**

```diff
  ❌ Before (v3.1.0):
  .ai-context/changelog/2026-06-16-initial-scan.md

  ✅ After (v3.1.2 with /docs-check):
  .ai-context/changelog/2026-06-16-initial-scan/
  ├── overview.md
  ├── files.md
  ├── technical.md
  ├── impact.md
  ├── testing.md
  ├── deployment.md
  └── docs/
      ├── requirements/  ← project docs auto-categorized
      ├── technical/
      ├── testing/
      ├── design/
      └── other/
```

> 💡 **Tip**: After running `/docs-check`, you can verify the migration by checking the `.ai-context/changelog/` folder.

### 🎮 Usage

#### Commands

| Command | Description | Use Case |
|---------|-------------|----------|
| `/docs <描述>` | Smart assistant, auto-detect intent | Any scenario |
| `/docs-scan` | Full scan, generate all docs | First time, after major refactor |
| `/docs-update` | Incremental update | After daily development |
| `/docs-check` | Detect & auto-migrate docs structure | After plugin upgrade |
| `/docs-prepare <task>` | Pre-development, output dev plan | Before starting a task |
| `/docs-archive` | Archive mode, update docs | After development |

#### First Time Setup

```
/docs-scan
```

#### Before Development

```
/docs-prepare add cross-origin configuration
/docs-prepare fix login bug
```

#### After Development

```
/docs-archive
```

#### After Plugin Upgrade

```
/docs-check
```

This command detects if your existing docs use the latest format and shows what needs migration.

### 📁 File Structure

```
project-root/
├── CLAUDE.md                        # Workflow rules
├── AGENTS.md                        # AI Agent behavior rules
└── .ai-context/
    ├── README.md                    # Project overview
    ├── architecture.md              # System architecture
    ├── modules/                     # Module docs
    ├── api/                         # API docs
    ├── database/                    # Database design
    ├── middleware/                   # Middleware usage
    ├── guidelines/                  # Coding standards
    ├── changelog/                   # Change history
    │   ├── README.md                # Index (statistics, history list)
    │   ├── {date}-{name}/           # Each iteration folder
    │   │   ├── overview.md          # Change overview
    │   │   ├── files.md             # File list
    │   │   ├── technical.md         # Technical details
    │   │   ├── impact.md            # Impact scope
    │   │   ├── testing.md           # Test verification
    │   │   ├── deployment.md        # Deployment info
    │   │   └── docs/                # User-provided docs (optional)
    │   │       ├── requirements/    # Requirements docs
    │   │       ├── technical/       # Technical docs
    │   │       ├── testing/         # Test reports
    │   │       ├── design/          # Design docs
    │   │       └── other/           # Other docs
    │   └── dev-cycles/              # Development cycle records (optional)
    └── decisions/                   # Decision records
```

---

## 中文

### 🎯 这是什么？

> **AI 驱动的代码文档管理！**
>
> 只需告诉 AI 你想做什么，它会自动处理一切。

```
┌─────────────────────────────────────────────────────────────┐
│                    🔄 简单工作流                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🆕 升级插件后：                                              │
│  用户: "/docs-check"                                         │
│      ↓                                                      │
│  🔧 AI 检测并自动迁移旧文档结构                                │
│      ↓                                                      │
│  ┌───────────────────────────────────────────────────┐      │
│  │  📂 新项目流程：                                   │      │
│  │  用户: "/docs-scan"                                │      │
│  │      ↓                                            │      │
│  │  🤖 AI 扫描代码库并生成文档                        │      │
│  │      ↓                                            │      │
│  │  用户: "/docs-prepare 添加登录功能"                 │      │
│  │      ↓                                            │      │
│  │  📖 AI 自动读取相关文档并输出开发方案              │      │
│  │      ↓                                            │      │
│  │  💻 用户实现功能                                   │      │
│  │      ↓                                            │      │
│  │  用户: "/docs-archive"                            │      │
│  │      ↓                                            │      │
│  │  📝 AI 总结变更并更新所有相关文档                  │      │
│  │      ↓                                            │      │
│  │  ✅ 文档已更新！                                   │      │
│  └───────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### ✨ 功能特性

| 功能 | 描述 |
|------|------|
| 🤖 **AI 驱动** | 所有分析由 AI 完成，不使用脚本 |
| 📖 **自动读取** | 编码前 AI 自动读取文档并输出开发方案 |
| 📝 **自动归档** | AI 总结变更并更新所有相关文档 |
| 🔄 **增量更新** | 支持增量更新，只更新变更部分 |
| 🔧 **自动迁移** | `/docs-check` 检测过时结构并自动迁移到最新格式 |
| 📊 **变更记录系统** | 完整的变更记录，包含统计、历史和开发周期 |
| 🚀 **多指令支持** | `/docs`、`/docs-scan`、`/docs-update`、`/docs-check`、`/docs-prepare`、`/docs-archive` |

### 🆕 3.2.0 版本更新

- **UI 设计资产支持**：`icon.svg`、`logo.svg`、`icon-*.png` 等 UI 图标现在会正确归类到 `docs/design/`，不再被误排除
- **资源过滤更精细**：仅 `favicon.*` 视为工程资源（浏览器标签图标）排除，其他设计资产全部参与归类
- **新增 icon/logo 关键词**：归类规则新增 `icon`、`logo`、`图标` 关键词，与 `ui`、`mockup`、`figma` 等并列

### 🆕 3.1.2 版本更新

- **文档结构检测 + 自动迁移**：`/docs-check` - 检测过时格式并自动迁移到最新版（一键搞定）
- **批量文档归类**：一次性扫描 + 一次性询问 + 一次性移动（不再逐个文件问）
- **智能文件移动（非复制）**：项目文档**移动**到 docs/ 子目录，不在原位置保留
- **自动跳过 CLAUDE.md/AGENTS.md**：工作流规则文件不参与归类
- **前端项目智能识别**：`/docs-scan` 自动判断项目分类（前端/后端/全栈），跳过不相关文档

### 🆕 3.1.1 版本更新

- **智能助手**：`/docs <描述>` - AI 自动识别意图，执行对应的 workflow
- **Bug 分析**：内置 Bug 检测和分析能力
- **文档结构检测**：`/docs-check` - 检测现有文档是否使用最新格式（升级插件版本后使用）
- **统一命令**：一个命令处理所有场景 - 开发、找Bug、归档、扫描、更新

### 📦 安装步骤

```bash
# 第一步：添加市场
/plugin marketplace add Leo-skye-taylor/code-documents-auto-skill

# 第二步：安装插件
/plugin install code-documents-auto@code-documents-auto-skill
```

### 🔄 更新插件

当有新版本可用时，执行以下命令：

```bash
# 卸载旧版本
/plugin uninstall code-documents-auto@code-documents-auto-skill

# 清除缓存（可选但推荐）
rm -rf ~/.claude/plugins/cache/code-documents-auto-skill

# 重新安装最新版本
/plugin install code-documents-auto@code-documents-auto-skill
```

### 🆙 升级现有项目

如果你从旧版本（比如 v3.1.0 或更早）升级，**跑一次 `/docs-check`** 即可自动迁移你的现有文档：

```bash
/docs-check
```

**`/docs-check` 会做什么：**

| 操作 | 说明 |
|------|------|
| 🔍 **检测** | 扫描 `.ai-context/`，识别过时结构 |
| 📁 **拆分** | 单文件 changelog → 文件夹 + 6 个核心文档 |
| 📊 **升级** | 5 列旧表格 → 8 列新格式（含"描述"列） |
| 📂 **创建** | 缺失的 docs/ 子目录（requirements/technical/testing/design/other） |
| 🏷️ **改进** | 通用标题（如只填"feat"）→ 从文件夹名生成描述性标题 |
| 📦 **归类** | 批量移动项目文档到 docs/ 子目录（一次询问，不逐个问） |

**迁移效果示例：**

```diff
  ❌ 升级前 (v3.1.0)：
  .ai-context/changelog/2026-06-16-initial-scan.md

  ✅ 升级后 (v3.1.2 跑 /docs-check)：
  .ai-context/changelog/2026-06-16-initial-scan/
  ├── overview.md
  ├── files.md
  ├── technical.md
  ├── impact.md
  ├── testing.md
  ├── deployment.md
  └── docs/
      ├── requirements/  ← 项目文档自动归类到这里
      ├── technical/
      ├── testing/
      ├── design/
      └── other/
```

> 💡 **贴士**：跑完 `/docs-check` 后，可以查看 `.ai-context/changelog/` 目录确认迁移效果。

### 🎮 使用方法

#### 指令概览

| 指令 | 说明 | 使用场景 |
|------|------|----------|
| `/docs <描述>` | 智能助手，自动识别意图 | 任何场景 |
| `/docs-scan` | 全量扫描，生成完整文档 | 首次使用、重大重构后 |
| `/docs-update` | 增量更新，只更新变更部分 | 日常开发后 |
| `/docs-check` | 检测文档结构并自动迁移 | 升级插件版本后 |
| `/docs-prepare <任务>` | 开发前准备，输出开发方案 | 开始新任务前 |
| `/docs-archive` | 归档模式，更新文档 | 开发完成后 |

#### 首次使用

```
/docs-scan
```

#### 开发前

```
/docs-prepare 加跨域请求配置
/docs-prepare 修复登录 bug
```

#### 开发后

```
/docs-archive
```

#### 升级插件后

```
/docs-check
```

该指令会**自动检测**现有文档格式，**自动迁移**到最新版本，并**批量归类**项目下的散落文档到对应 docs/ 子目录。

### 📁 文件结构

```
项目根目录/
├── CLAUDE.md                        # 工作流规则
├── AGENTS.md                        # AI Agent 行为规则
└── .ai-context/
    ├── README.md                    # 项目概览
    ├── architecture.md              # 系统架构
    ├── modules/                     # 模块文档
    ├── api/                         # API 文档
    ├── database/                    # 数据库设计
    ├── middleware/                   # 中间件使用
    ├── guidelines/                  # 编码规范
    ├── changelog/                   # 变更记录
    │   ├── README.md                # 总索引（变更统计、历史列表）
    │   ├── {日期}-{标识}/           # 每次迭代的文件夹
    │   │   ├── overview.md          # 变更概述
    │   │   ├── files.md             # 文件清单
    │   │   ├── technical.md         # 技术细节
    │   │   ├── impact.md            # 影响范围
    │   │   ├── testing.md           # 测试验证
    │   │   ├── deployment.md        # 部署信息
    │   │   └── docs/                # 用户提供的文档（可选）
    │   │       ├── requirements/    # 需求文档
    │   │       ├── technical/       # 技术文档
    │   │       ├── testing/         # 测试报告
    │   │       ├── design/          # 设计文档
    │   │       └── other/           # 其他文档
    │   └── dev-cycles/              # 开发周期记录（可选）
    └── decisions/                   # 技术决策
```

---

## 🤝 Contributing / 贡献

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

欢迎贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

---

## 📄 License / 许可证

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

本项目采用 MIT 许可证 - 详情请查看 [LICENSE](LICENSE) 文件。

---

<div align="center">

**Made with ❤️ by [Leo-skye-taylor](https://github.com/Leo-skye-taylor)**

[![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?style=for-the-badge&logo=github)](https://github.com/Leo-skye-taylor)

</div>
