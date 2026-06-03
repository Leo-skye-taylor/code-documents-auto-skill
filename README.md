# 🚀 Code Documents Auto Skill

[![Version](https://img.shields.io/badge/version-3.1.1-blue.svg)](https://github.com/Leo-skye-taylor/code-documents-auto-skill)
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
│  User: "/docs-scan"                                         │
│      ↓                                                      │
│  🤖 AI scans codebase and generates documentation           │
│      ↓                                                      │
│  User: "/docs-prepare add login feature"                       │
│      ↓                                                      │
│  📖 AI reads related docs and outputs development plan      │
│      ↓                                                      │
│  💻 User implements the feature                             │
│      ↓                                                      │
│  User: "/docs-archive"                                      │
│      ↓                                                      │
│  📝 AI summarizes & updates all related docs                │
│      ↓                                                      │
│  ✅ Documentation updated!                                  │
└─────────────────────────────────────────────────────────────┘
```

### ✨ Features

| Feature | Description |
|---------|-------------|
| 🤖 **AI-Driven** | All analysis done by AI, not scripts |
| 📖 **Auto Read** | AI reads docs and outputs development plan before coding |
| 📝 **Auto Archive** | AI summarizes changes and updates all related docs |
| 🔄 **Incremental Update** | Support incremental updates, only update changed parts |
| 📊 **Changelog System** | Complete changelog with statistics, history, and dev cycles |
| 🚀 **Multiple Commands** | `/docs-scan`, `/docs-update`, `/docs-prepare`, `/docs-archive` |

### 🆕 What's New in 3.1.1

- **Smart Assistant**: `/docs <description>` - AI automatically detects intent and executes the appropriate workflow
- **Bug Analysis**: Built-in bug detection and analysis capabilities
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

### 🎮 Usage

#### Commands

| Command | Description | Use Case |
|---------|-------------|----------|
| `/docs <描述>` | Smart assistant, auto-detect intent | Any scenario |
| `/docs-scan` | Full scan, generate all docs | First time, after major refactor |
| `/docs-update` | Incremental update | After daily development |
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
│  用户: "/docs-scan"                                          │
│      ↓                                                       │
│  🤖 AI 扫描代码库并生成文档                                    │
│      ↓                                                       │
│  用户: "/docs-prepare 添加登录功能"                               │
│      ↓                                                       │
│  📖 AI 自动读取相关文档并输出开发方案                            │
│      ↓                                                       │
│  💻 用户实现功能                                               │
│      ↓                                                       │
│  用户: "/docs-archive"                                        │
│      ↓                                                       │
│  📝 AI 总结变更并更新所有相关文档                                │
│      ↓                                                       │
│  ✅ 文档已更新！                                               │
└─────────────────────────────────────────────────────────────┘
```

### ✨ 功能特性

| 功能 | 描述 |
|------|------|
| 🤖 **AI 驱动** | 所有分析由 AI 完成，不使用脚本 |
| 📖 **自动读取** | 编码前 AI 自动读取文档并输出开发方案 |
| 📝 **自动归档** | AI 总结变更并更新所有相关文档 |
| 🔄 **增量更新** | 支持增量更新，只更新变更部分 |
| 📊 **变更记录系统** | 完整的变更记录，包含统计、历史和开发周期 |
| 🚀 **多指令支持** | `/docs-scan`、`/docs-update`、`/docs-prepare`、`/docs-archive` |

### 🆕 3.1.1 版本更新

- **智能助手**：`/docs <描述>` - AI 自动识别意图，执行对应的 workflow
- **Bug 分析**：内置 Bug 检测和分析能力
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

### 🎮 使用方法

#### 指令概览

| 指令 | 说明 | 使用场景 |
|------|------|----------|
| `/docs <描述>` | 智能助手，自动识别意图 | 任何场景 |
| `/docs-scan` | 全量扫描，生成完整文档 | 首次使用、重大重构后 |
| `/docs-update` | 增量更新，只更新变更部分 | 日常开发后 |
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
