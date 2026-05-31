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

---

## Installation

### Prerequisites
- Claude Code CLI installed
- Bash shell available
- jq installed (for JSON processing)

### Setup

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd code-documents-auto-skill
   ```

2. Copy the skill to your Claude Code skills directory:
   ```bash
   cp -r . ~/.claude/skills/code-documents-auto
   ```

3. Verify installation:
   ```bash
   ls -la ~/.claude/skills/code-documents-auto
   ```

## Usage

### How It Works

**User just says what they want to do. AI handles everything automatically.**

#### Example Conversation

```
User: "I want to add a remember password feature to the login"

AI automatically:
1. Detects project doesn't have ai-context/ → runs /docs-scan
2. Detects CLAUDE.md doesn't have rules → appends rules
3. Reads all related documentation:
   - ai-context/architecture.md
   - ai-context/guidelines/README.md
   - ai-context/modules/auth/README.md
4. Starts workflow session
5. Implements the feature
6. Generates change record
7. Updates module documentation
8. Completes workflow session

User: "Done! What's next?"
```

### No Manual Actions Required

**User does NOT need to:**
- ❌ Run any commands
- ❌ Read any documentation manually
- ❌ Create any files manually
- ❌ Configure anything manually

**AI automatically handles:**
- ✅ Project initialization
- ✅ Rule setup (CLAUDE.md, AGENTS.md)
- ✅ Codebase scanning
- ✅ Document reading
- ✅ Code implementation
- ✅ Document generation
- ✅ Workflow management

### Development Workflow

#### What User Does

```
User: "Fix the authentication bug"
User: "Add user profile feature"
User: "Refactor the database layer"
```

#### What AI Does Automatically

1. **Initialize if needed**
   - Check project status
   - Setup rules if missing
   - Scan codebase if needed

2. **Before development**
   - Read all related documentation
   - Start workflow session
   - Verify reading completion

3. **During development**
   - Implement the requested changes
   - Follow coding standards
   - Document decisions

4. **After development**
   - Generate change record
   - Update module documentation
   - Complete workflow session

2. **Track changes**:
   - Note what's changing
   - Record decision rationale
   - Document impacts

#### After Development

1. **Record changes**:
   ```
   /docs-record [description]
   ```

2. **Complete the audit trail**:
   - Document all changes
   - Record testing results
   - Update impact analysis

3. **Get sign-off**:
   - Review change record
   - Get approvals
   - Update documentation

## Documentation Structure

### For AI Consumption

```
ai-context/
├── README.md                    # Project overview and navigation
├── architecture.md              # System architecture
├── guidelines/                  # Coding standards and conventions
│   ├── README.md                # Guidelines index
│   ├── code-style.md            # Code style and formatting
│   ├── naming-conventions.md    # Naming conventions
│   └── git-workflow.md          # Git workflow and branching
├── modules/                     # Module documentation
│   └── [module-name]/
│       ├── README.md            # Module overview
│       ├── interfaces.md        # Public interfaces
│       ├── implementation.md    # Implementation details
│       └── dependencies.md      # Dependencies
├── features/                    # Feature documentation
│   ├── README.md                # Features index and overview
│   └── [feature-name]/
│       ├── README.md            # Feature overview
│       ├── requirements.md      # Requirements
│       ├── design.md            # Design decisions
│       └── implementation.md    # Implementation details
├── api/                         # API documentation
│   ├── README.md                # APIs index and overview
│   └── [api-name]/
│       ├── README.md            # API overview
│       ├── endpoints.md         # Endpoint documentation
│       └── schemas.md           # Data schemas
├── changelog/                   # Change records
│   └── YYYY-MM-DD-type-description.md
└── decisions/                   # Decision log
    └── YYYY-MM-DD-decision-description.md
```

### AI Readability Standards

1. **Clear hierarchy**: Consistent heading levels
2. **Structured content**: YAML frontmatter for metadata
3. **Explicit relationships**: Clear dependency documentation
4. **Actionable information**: Clear instructions and examples

## Commands Reference

### `/docs-scan`

Scan codebase and generate documentation.

**Usage:**
```
/docs-scan [directory]
```

**Options:**
- `-f, --force`: Overwrite existing documentation
- `-v, --verbose`: Enable verbose output
- `-o, --output`: Output directory (default: docs)

**Examples:**
```bash
# Scan current directory
/docs-scan

# Scan specific directory
/docs-scan /path/to/project

# Force overwrite
/docs-scan -f .
```

### `/docs-read` - MANDATORY

**MUST be called before ANY code changes. CANNOT be skipped.**

Automatically finds and reads ALL related documentation.

**Usage:**
```
/docs-read [files or modules]
```

**Examples:**
```bash
# Read docs for specific files
/docs-read src/auth/login.ts src/user/user.service.ts

# Read docs for entire modules
/docs-read auth,user

# Read docs for a feature
/docs-read login-feature
```

**What Happens:**
1. AI analyzes files/modules to be modified
2. Finds ALL related documentation (modules, features, APIs, architecture, guidelines)
3. Reads ALL documents
4. Records reading in workflow log
5. Starts workflow session
6. Verifies completion

**Cannot Proceed Until:**
- ALL related documents are read
- Reading is recorded
- Workflow session is active

### `/docs-record` - MANDATORY

**MUST be called after ANY code changes. CANNOT be skipped.**

Automatically generates/updates ALL affected documentation.

**Usage:**
```
/docs-record [description]
```

**Examples:**
```bash
# Record a feature change
/docs-record "Add user login functionality"

# Record a bugfix
/docs-record "Fix authentication error"

# Record a refactor
/docs-record "Refactor database layer"
```

**What Happens:**
1. AI detects ALL affected documentation
2. Generates change record in `ai-context/changelog/`
3. Updates module documentation
4. Updates feature documentation
5. Updates API documentation
6. Generates decision records (if applicable)
7. Completes workflow session

**Cannot Complete Until:**
- ALL affected documentation is updated
- Change record is generated
- Workflow session is completed

# Interactive mode
/docs-record --interactive
```

## Templates

### Module Documentation
- **File**: `assets/templates/module-doc.md`
- **Purpose**: Template for module-level documentation
- **Sections**: Overview, Architecture, Interfaces, Implementation, Dependencies

### Feature Documentation
- **File**: `assets/templates/feature-doc.md`
- **Purpose**: Template for feature-level documentation
- **Sections**: Overview, Requirements, Design, Implementation, Testing

### Change Record
- **File**: `assets/templates/change-record.md`
- **Purpose**: Template for change audit trails
- **Sections**: Summary, Motivation, Changes, Impact, Decisions, Testing

## Best Practices

### 1. Documentation First
- Write docs before code when possible
- Keep docs updated in real-time
- Never let docs fall behind

### 2. AI Optimization
- Use consistent formatting
- Provide clear structure
- Include explicit relationships

### 3. Complete Records
- Document all decisions
- Record all changes
- Maintain audit trails

### 4. Regular Reviews
- Review docs regularly
- Update stale information
- Improve documentation quality

## Integration

### With Git

#### Pre-commit Hook
```bash
#!/bin/bash
# Validate documentation before commit

# Check if audit record exists
if [ ! -f "docs/changelog/$(date +%Y-%m-%d)*.md" ]; then
    echo "Error: No audit record for today"
    exit 1
fi

# Validate documentation
python scripts/validate-docs.py docs/
```

#### Post-commit Hook
```bash
#!/bin/bash
# Update documentation after commit

# Update changelog
/scripts/record-changes.sh "Update documentation"
```

### With CI/CD

#### GitHub Actions
```yaml
name: Documentation Validation

on:
  pull_request:
    paths:
      - 'src/**'
      - 'docs/**'

jobs:
  validate-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate Documentation
        run: |
          python scripts/validate-docs.py docs/
```

## Troubleshooting

### Common Issues

#### 1. Documentation not generated
**Symptoms**: No docs/ directory after running /docs-scan
**Solution**: Check file permissions and directory structure

#### 2. Reading validation fails
**Symptoms**: /docs-read returns error
**Solution**: Ensure documentation exists and reading log is initialized

#### 3. Change record not created
**Symptoms**: /docs-record fails
**Solution**: Check required fields and file permissions

### Debug Mode

Enable verbose output for debugging:
```bash
# For scanning
/docs-scan -v

# For reading validation
/docs-read -v

# For change recording
/docs-record -v
```

## Contributing

### Development Setup

1. Clone the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Code Standards

- Follow bash scripting best practices
- Use consistent naming conventions
- Include error handling
- Write clear documentation

### Testing

```bash
# Run tests
./scripts/test.sh

# Validate scripts
shellcheck scripts/*.sh
```

## License

[License information]

## Support

### Documentation
- [Skill Documentation](SKILL.md)
- [Reference Guides](references/)
- [Templates](assets/templates/)

### Issues
- Report bugs via GitHub issues
- Request features via GitHub discussions
- Ask questions in community forums

### Community
- Join the community Discord
- Follow on Twitter
- Subscribe to newsletter

## Changelog

### Version 1.0.0
- Initial release
- Core scanning functionality
- Reading validation
- Change recording
- Documentation templates

## Roadmap

### Version 1.1.0
- Enhanced AI readability
- Better error handling
- Performance improvements
- Additional templates

### Version 1.2.0
- Integration with more tools
- Advanced analytics
- Custom workflows
- Team collaboration features

### Version 2.0.0
- Complete rewrite
- New architecture
- Advanced AI features
- Enterprise features
