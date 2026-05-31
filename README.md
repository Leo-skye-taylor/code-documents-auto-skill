# Code Documents Auto Skill

[English](#english) | [中文](#中文)

---

## English

### Overview

This skill provides comprehensive code documentation management optimized for AI consumption. It automates the process of scanning codebases, generating structured documentation, enforcing pre-development reading, and recording complete change audit trails.

**All operations are fully automated - no manual user actions required.**

### Features

- **Auto Documentation Scanning**: Scans codebase and generates structured documentation
- **Auto Change Recording**: Automatically records modified files during code editing
- **Auto Archiving**: AI summarizes changes and auto-generates changelog
- **Auto Module Updates**: Automatically updates module documentation
- **Force Workflow**: Ensures documentation is always up-to-date

### Installation

**Method 1: Via Marketplace (Recommended)**

1. Add the marketplace:
```bash
/plugin marketplace add trainMini/code-documents-auto-skill
```

2. Install the plugin:
```bash
/plugin install code-documents-auto@code-documents-auto-skill
```

**Method 2: Manual Installation**

1. Clone the repository:
```bash
git clone https://github.com/trainMini/code-documents-auto-skill.git ~/.claude/skills/code-documents-auto-skill
```

2. Configure hooks in `~/.claude/settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/skills/code-documents-auto-skill/hooks/pre-edit-check.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write|Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/skills/code-documents-auto-skill/hooks/post-edit-archive.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/skills/code-documents-auto-skill/hooks/stop-check.sh"
          }
        ]
      }
    ]
  }
}
```

### How It Works

1. **Before Editing**: PreToolUse hook checks if there are unarchived changes
2. **After Editing**: PostToolUse hook records modified files and prompts AI to summarize
3. **Auto Archive**: AI summarizes changes and runs archive command
4. **Before Stopping**: Stop hook ensures all changes are archived

### File Structure

```
your-project/
├── .ai-context/
│   ├── .workflow-log.json          # Workflow log
│   ├── README.md                   # Project overview
│   ├── architecture.md             # System architecture
│   ├── guidelines/                 # Coding guidelines
│   ├── modules/                    # Module documentation
│   ├── features/                   # Feature documentation
│   ├── api/                        # API documentation
│   ├── changelog/                  # Change logs
│   └── decisions/                  # Decision records
├── CLAUDE.md                       # Project rules
└── AGENTS.md                       # Agent rules
```

### Commands

- **Scan Codebase**: `bash ~/.claude/skills/code-documents-auto-skill/scripts/scan-codebase.sh`
- **Force Archive**: `bash ~/.claude/skills/code-documents-auto-skill/hooks/force-archive.sh "summary"`

### License

MIT License

---

## 中文

### 概述

这是一个 Claude Code 技能，用于自动管理代码文档。它自动扫描代码库、生成结构化文档、强制开发前读取文档，并记录完整的变更审计跟踪。

**所有操作都是全自动的，用户无需手动操作。**

### 功能特性

- **自动文档扫描**：扫描代码库并生成结构化文档
- **自动变更记录**：在代码编辑过程中自动记录修改的文件
- **自动归档**：AI 总结改动内容并自动生成变更日志
- **自动模块更新**：自动更新模块文档
- **强制工作流**：确保文档始终保持最新

### 安装步骤

**方式一：通过市场安装（推荐）**

1. 添加市场：
```bash
/plugin marketplace add trainMini/code-documents-auto-skill
```

2. 安装插件：
```bash
/plugin install code-documents-auto@code-documents-auto-skill
```

**方式二：手动安装**

1. 克隆仓库：
```bash
git clone https://github.com/trainMini/code-documents-auto-skill.git ~/.claude/skills/code-documents-auto-skill
```

2. 在 `~/.claude/settings.json` 中配置 hooks：
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/skills/code-documents-auto-skill/hooks/pre-edit-check.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write|Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/skills/code-documents-auto-skill/hooks/post-edit-archive.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/skills/code-documents-auto-skill/hooks/stop-check.sh"
          }
        ]
      }
    ]
  }
}
```

### 工作原理

1. **编辑前**：PreToolUse hook 检查是否有未归档的修改
2. **编辑后**：PostToolUse hook 记录修改的文件并提示 AI 总结
3. **自动归档**：AI 总结改动内容并执行归档命令
4. **停止前**：Stop hook 确保所有修改都已归档

### 文件结构

```
your-project/
├── .ai-context/
│   ├── .workflow-log.json          # 工作流日志
│   ├── README.md                   # 项目概览
│   ├── architecture.md             # 系统架构
│   ├── guidelines/                 # 编码规范
│   ├── modules/                    # 模块文档
│   ├── features/                   # 功能文档
│   ├── api/                        # API 文档
│   ├── changelog/                  # 变更日志
│   └── decisions/                  # 决策记录
├── CLAUDE.md                       # 项目规则
└── AGENTS.md                       # Agent 规则
```

### 命令

- **扫描代码库**：`bash ~/.claude/skills/code-documents-auto-skill/scripts/scan-codebase.sh`
- **强制归档**：`bash ~/.claude/skills/code-documents-auto-skill/hooks/force-archive.sh "总结内容"`

### 许可证

MIT License
