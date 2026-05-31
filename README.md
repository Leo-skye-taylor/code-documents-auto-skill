# 🚀 Code Documents Auto Skill

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/trainMini/code-documents-auto-skill)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude-Code-purple.svg)](https://claude.ai/code)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)]()

[English](#english) | [中文](#中文)

---

## 🎯 What is this?

> **Manage code documentation with simple commands!**
>
> Just tell AI what you want to do, and it handles everything automatically.

```
┌─────────────────────────────────────────────────────────────┐
│                    🔄 Simple Workflow                       │
├─────────────────────────────────────────────────────────────┤
│  User: "/code-documents-auto add login feature"             │
│      ↓                                                      │
│  📖 AI reads related docs automatically                     │
│      ↓                                                      │
│  💻 User implements the feature                             │
│      ↓                                                      │
│  User: "/code-documents-auto done, archive"                 │
│      ↓                                                      │
│  📝 AI summarizes & archives changes                        │
│      ↓                                                      │
│  ✅ Documentation updated!                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## English

### ✨ Features

| Feature | Description |
|---------|-------------|
| 📖 **Auto Read** | AI reads all related docs before coding |
| 📝 **Auto Archive** | AI summarizes and generates changelog |
| 🔄 **Auto Update** | Module docs updated automatically |
| 🚀 **Simple Commands** | Just `/code-documents-auto <task>` |

### 📦 Installation

```bash
# Step 1: Add marketplace
/plugin marketplace add trainMini/code-documents-auto-skill

# Step 2: Install plugin
/plugin install code-documents-auto@code-documents-auto-skill
```

### 🎮 Usage

#### Before Development

Tell AI what you want to do:

```
/code-documents-auto add cross-origin request configuration
/code-documents-auto fix login bug
/code-documents-auto refactor database layer
```

AI will automatically:
1. Parse your task description
2. Find and read all related documentation
3. Show you a summary of what it read

#### After Development

Tell AI you're done:

```
/code-documents-auto done, archive
/code-documents-auto finished
/code-documents-auto archive
```

AI will automatically:
1. Detect changed files
2. Generate changelog
3. Update module documentation
4. Show you a summary of what was archived

### 📁 File Structure

```
your-project/
├── 📂 .ai-context/
│   ├── 📄 README.md              # 📋 Project overview
│   ├── 📄 architecture.md        # 🏗️ System architecture
│   ├── 📂 guidelines/            # 📏 Coding standards
│   ├── 📂 modules/               # 📦 Module docs
│   ├── 📂 features/              # ✨ Feature docs
│   ├── 📂 api/                   # 🔌 API docs
│   ├── 📂 changelog/             # 📝 Change history
│   └── 📂 decisions/             # 🤔 Decision records
├── 📄 CLAUDE.md                   # 🤖 AI rules
└── 📄 AGENTS.md                   # 🎯 Agent rules
```

### 🛠️ Commands

| Command | Description |
|---------|-------------|
| `/code-documents-auto <task>` | 📖 Read docs or 📝 archive changes |
| `/docs-scan` | 🔍 Initial codebase scan |

---

## 中文

### ✨ 功能特性

| 功能 | 描述 |
|------|------|
| 📖 **自动读取** | 编码前 AI 自动读取所有相关文档 |
| 📝 **自动归档** | AI 总结并生成变更日志 |
| 🔄 **自动更新** | 模块文档自动更新 |
| 🚀 **简单指令** | 只需 `/code-documents-auto <任务>` |

### 📦 安装步骤

```bash
# 第一步：添加市场
/plugin marketplace add trainMini/code-documents-auto-skill

# 第二步：安装插件
/plugin install code-documents-auto@code-documents-auto-skill
```

### 🎮 使用方法

#### 开发前

告诉 AI 你要做什么：

```
/code-documents-auto 加跨域请求配置
/code-documents-auto 修改登录功能，添加记住密码
/code-documents-auto 修复认证模块的 bug
/code-documents-auto 重构数据库层
```

AI 会自动：
1. 解析任务描述
2. 查找并读取所有相关文档
3. 展示读取摘要

#### 开发后

告诉 AI 你完成了：

```
/code-documents-auto 开发完了，归档
/code-documents-auto 改完了
/code-documents-auto 完成
/code-documents-auto 归档
```

AI 会自动：
1. 检测修改的文件
2. 生成变更记录
3. 更新模块文档
4. 展示归档摘要

### 📁 文件结构

```
your-project/
├── 📂 .ai-context/
│   ├── 📄 README.md              # 📋 项目概览
│   ├── 📄 architecture.md        # 🏗️ 系统架构
│   ├── 📂 guidelines/            # 📏 编码规范
│   ├── 📂 modules/               # 📦 模块文档
│   ├── 📂 features/              # ✨ 功能文档
│   ├── 📂 api/                   # 🔌 API 文档
│   ├── 📂 changelog/             # 📝 变更历史
│   └── 📂 decisions/             # 🤔 决策记录
├── 📄 CLAUDE.md                   # 🤖 AI 规则
└── 📄 AGENTS.md                   # 🎯 Agent 规则
```

### 🛠️ 命令

| 命令 | 描述 |
|------|------|
| `/code-documents-auto <任务>` | 📖 读取文档 或 📝 归档变更 |
| `/docs-scan` | 🔍 初始代码库扫描 |

---

## 📊 Stats

![GitHub Stars](https://img.shields.io/github/stars/trainMini/code-documents-auto-skill?style=social)
![GitHub Forks](https://img.shields.io/github/forks/trainMini/code-documents-auto-skill?style=social)
![GitHub Issues](https://img.shields.io/github/issues/trainMini/code-documents-auto-skill)
![GitHub Pull Requests](https://img.shields.io/github/issues-pr/trainMini/code-documents-auto-skill)

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ by [trainMini](https://github.com/trainMini)**

[![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?style=for-the-badge&logo=github)](https://github.com/trainMini)

</div>
