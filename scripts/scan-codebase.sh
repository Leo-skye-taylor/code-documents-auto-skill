#!/bin/bash

# Codebase Scanner for AI-Oriented Documentation
# This script scans a codebase and generates structured documentation

set -e

# Configuration
DOCS_DIR=".ai-context"
GUIDELINES_DIR="$DOCS_DIR/guidelines"
MODULES_DIR="$DOCS_DIR/modules"
FEATURES_DIR="$DOCS_DIR/features"
API_DIR="$DOCS_DIR/api"
CHANGELOG_DIR="$DOCS_DIR/changelog"
DECISIONS_DIR="$DOCS_DIR/decisions"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
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

# Help function
show_help() {
    cat << EOF
用法: $0 [选项] [目录]

扫描代码库并生成面向 AI 的文档。

选项:
    -h, --help          显示此帮助信息
    -v, --verbose       启用详细输出
    -f, --force         覆盖现有文档
    -t, --template      使用自定义模板目录
    -o, --output        输出目录 (默认: .ai-context)

参数:
    目录                要扫描的目录 (默认: 当前目录)

示例:
    $0                          # 扫描当前目录
    $0 /path/to/project         # 扫描指定目录
    $0 -f -o custom-docs .      # 强制覆盖，自定义输出目录

EOF
}

# Parse arguments
VERBOSE=false
FORCE=false
TEMPLATE_DIR=""
OUTPUT_DIR="$DOCS_DIR"
SCAN_DIR="."

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -t|--template)
            TEMPLATE_DIR="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -*)
            log_error "未知选项: $1"
            show_help
            exit 1
            ;;
        *)
            SCAN_DIR="$1"
            shift
            ;;
    esac
done

# Validate directory
if [[ ! -d "$SCAN_DIR" ]]; then
    log_error "目录不存在: $SCAN_DIR"
    exit 1
fi

# Create directory structure
create_directory_structure() {
    log_info "正在创建目录结构..."

    mkdir -p "$OUTPUT_DIR"
    mkdir -p "$GUIDELINES_DIR"
    mkdir -p "$MODULES_DIR"
    mkdir -p "$FEATURES_DIR"
    mkdir -p "$API_DIR"
    mkdir -p "$CHANGELOG_DIR"
    mkdir -p "$DECISIONS_DIR"

    log_success "目录结构创建完成"
}

# Detect project type
detect_project_type() {
    local project_type="unknown"

    if [[ -f "$SCAN_DIR/package.json" ]]; then
        project_type="node"
    elif [[ -f "$SCAN_DIR/requirements.txt" ]] || [[ -f "$SCAN_DIR/setup.py" ]] || [[ -f "$SCAN_DIR/pyproject.toml" ]]; then
        project_type="python"
    elif [[ -f "$SCAN_DIR/Cargo.toml" ]]; then
        project_type="rust"
    elif [[ -f "$SCAN_DIR/go.mod" ]]; then
        project_type="go"
    elif [[ -f "$SCAN_DIR/pom.xml" ]] || [[ -f "$SCAN_DIR/build.gradle" ]]; then
        project_type="java"
    elif [[ -f "$SCAN_DIR/Cargo.toml" ]]; then
        project_type="rust"
    elif [[ -f "$SCAN_DIR/Gemfile" ]]; then
        project_type="ruby"
    elif [[ -f "$SCAN_DIR/composer.json" ]]; then
        project_type="php"
    fi

    echo "$project_type"
}

# Progress bar function
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    # Calculate estimated time
    local elapsed=$(($(date +%s) - START_TIME))
    local eta=0
    if [[ $current -gt 0 ]]; then
        eta=$((elapsed * (total - current) / current))
    fi

    # Format time
    local elapsed_min=$((elapsed / 60))
    local elapsed_sec=$((elapsed % 60))
    local eta_min=$((eta / 60))
    local eta_sec=$((eta % 60))

    # Build progress bar
    local bar="["
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    bar+="]"

    # Print progress
    printf "\r${BLUE}[进度]${NC} %s %3d%% (%d/%d) | 已用: %02d:%02d | 预估剩余: %02d:%02d" \
        "$bar" "$percentage" "$current" "$total" \
        "$elapsed_min" "$elapsed_sec" "$eta_min" "$eta_sec"
}

# Scan files
scan_files() {
    log_info "正在扫描 $SCAN_DIR 中的文件..."

    local file_count=0
    local code_files=0
    local doc_files=0
    local config_files=0

    # First, count total files for progress
    local total_files=$(find "$SCAN_DIR" -type f -not -path '*/\.*' -not -path '*/node_modules/*' -not -path '*/vendor/*' -not -path '*/__pycache__/*' -not -path '*/.ai-context/*' | wc -l | tr -d ' ')

    if [[ $total_files -eq 0 ]]; then
        log_warning "未找到任何文件"
        return
    fi

    log_info "共找到 $total_files 个文件，开始扫描..."
    echo ""

    # Record start time
    START_TIME=$(date +%s)

    # Count files by type, excluding .ai-context directory
    while IFS= read -r -d '' file; do
        ((file_count++))

        case "$file" in
            *.md|*.txt|*.rst|*.doc|*.docx)
                ((doc_files++))
                ;;
            *.json|*.yaml|*.yml|*.toml|*.ini|*.cfg|*.conf)
                ((config_files++))
                ;;
            *.js|*.ts|*.jsx|*.tsx|*.py|*.java|*.go|*.rs|*.rb|*.php|*.c|*.cpp|*.h|*.hpp)
                ((code_files++))
                ;;
        esac

        # Update progress every 10 files or on last file
        if [[ $((file_count % 10)) -eq 0 ]] || [[ $file_count -eq $total_files ]]; then
            show_progress $file_count $total_files
        fi
    done < <(find "$SCAN_DIR" -type f -not -path '*/\.*' -not -path '*/node_modules/*' -not -path '*/vendor/*' -not -path '*/__pycache__/*' -not -path '*/.ai-context/*' -print0)

    echo ""  # New line after progress bar
    echo ""

    log_success "扫描完成！"
    log_info "找到 $file_count 个文件:"
    log_info "  - 代码文件: $code_files"
    log_info "  - 文档文件: $doc_files"
    log_info "  - 配置文件: $config_files"
}

# Analyze project structure
analyze_structure() {
    log_info "正在分析项目结构..."

    # Detect project type
    PROJECT_TYPE=$(detect_project_type)
    log_info "检测到项目类型: $PROJECT_TYPE"

    # Find main directories, excluding .ai-context
    MAIN_DIRS=()
    while IFS= read -r -d '' dir; do
        MAIN_DIRS+=("$dir")
    done < <(find "$SCAN_DIR" -maxdepth 2 -type d -not -path '*/\.*' -not -path '*/node_modules/*' -not -path '*/vendor/*' -not -path '*/.ai-context*' -print0)

    log_info "找到 ${#MAIN_DIRS[@]} 个主要目录"

    # Find entry points
    ENTRY_POINTS=()
    for file in "$SCAN_DIR"/*.js "$SCAN_DIR"/*.ts "$SCAN_DIR"/*.py "$SCAN_DIR"/main.* "$SCAN_DIR"/index.*; do
        if [[ -f "$file" ]]; then
            ENTRY_POINTS+=("$file")
        fi
    done

    if [[ ${#ENTRY_POINTS[@]} -gt 0 ]]; then
        log_info "找到 ${#ENTRY_POINTS[@]} 个入口点"
    fi
}

# Generate guidelines documentation
generate_guidelines_docs() {
    log_info "正在生成编码规范文档..."

    # Create guidelines index
    cat > "$GUIDELINES_DIR/README.md" << EOF
---
type: guidelines-index
updated: $(date +%Y-%m-%d)
---

# Coding Guidelines

## Overview

This directory contains coding standards and conventions for the project.

## Guidelines

| Guideline | Description |
|-----------|-------------|
| [Code Style](code-style.md) | Code formatting and style rules |
| [Naming Conventions](naming-conventions.md) | Variable, function, and file naming |
| [Git Workflow](git-workflow.md) | Git branching and commit conventions |

## Why Guidelines Matter

- **Consistency**: Code looks the same across the project
- **Readability**: Easy to understand and maintain
- **Collaboration**: Team can work together efficiently
- **AI Assistance**: AI can follow consistent patterns

## Quick Reference

### Code Style
- Use consistent indentation (2 or 4 spaces)
- Follow language-specific conventions
- Keep functions small and focused

### Naming
- Use descriptive names
- Follow camelCase/PascalCase/snake_case conventions
- Avoid abbreviations

### Git
- Use conventional commits
- Write clear commit messages
- Keep commits focused

## Related Documentation

- [Architecture](../architecture.md) - System design

EOF

    # Generate code-style.md
    cat > "$GUIDELINES_DIR/code-style.md" << EOF
---
type: guideline
updated: $(date +%Y-%m-%d)
---

# Code Style Guide

## General Principles

- Write clean, readable code
- Follow language idioms
- Be consistent

## Formatting

### Indentation
- Use [2/4] spaces for indentation
- Never mix tabs and spaces

### Line Length
- Maximum line length: [80/100/120] characters
- Break long lines at logical points

### Braces
- Opening brace on same line
- Closing brace on own line

### Spacing
- Space after keywords (if, for, while)
- Space around operators (=, ==, +, -)
- No space after function name in calls

## Language-Specific Rules

### TypeScript/JavaScript
\`\`\`typescript
// Use const by default
const value = 'hello';

// Use arrow functions for callbacks
const items = list.map(item => item.name);

// Use template literals
const message = \`Hello \${name}\`;
\`\`\`

### Python
\`\`\`python
# Use snake_case for variables
user_name = 'John'

# Use list comprehensions
squares = [x**2 for x in range(10)]

# Use f-strings
message = f"Hello {name}"
\`\`\`

## Comments

### When to Comment
- Complex logic
- Non-obvious decisions
- Public APIs

### How to Comment
- Keep comments up-to-date
- Explain why, not what
- Use JSDoc/docstrings for APIs

## Error Handling

- Always handle errors
- Use specific error types
- Log errors with context

## Related Documentation

- [Naming Conventions](naming-conventions.md)

EOF

    # Generate naming-conventions.md
    cat > "$GUIDELINES_DIR/naming-conventions.md" << EOF
---
type: guideline
updated: $(date +%Y-%m-%d)
---

# Naming Conventions

## General Rules

- Use descriptive, meaningful names
- Avoid abbreviations and acronyms
- Be consistent across the project

## Variables

### General Variables
\`\`\`typescript
// Good
const userName = 'John';
const itemCount = 42;
const isActive = true;

// Bad
const u = 'John';
const ic = 42;
const flag = true;
\`\`\`

### Boolean Variables
\`\`\`typescript
// Use is/has/can prefix
const isVisible = true;
const hasPermission = false;
const canEdit = true;
\`\`\`

### Collections
\`\`\`typescript
// Use plural nouns
const users = [];
const items = new Map();
const errors = new Set();
\`\`\`

## Functions

### General Functions
\`\`\`typescript
// Use verb + noun
function getUserById(id: string): User {}
function calculateTotal(items: Item[]): number {}
function validateEmail(email: string): boolean {}
\`\`\`

### Event Handlers
\`\`\`typescript
// Use handle/on prefix
function handleClick(event: MouseEvent): void {}
function onSubmit(form: FormData): void {}
\`\`\`

## Classes

### General Classes
\`\`\`typescript
// Use PascalCase
class UserService {}
class DatabaseConnection {}
class ApiResponse {}
\`\`\`

### Interfaces
\`\`\`typescript
// Use PascalCase with I prefix (optional)
interface User {}
interface IUserService {}
\`\`\`

## Files

### General Files
\`\`\`
user-service.ts
database-connection.ts
api-response.ts
\`\`\`

### Test Files
\`\`\`
user-service.test.ts
database-connection.spec.ts
\`\`\`

## Constants

\`\`\`typescript
// Use UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';
const DEFAULT_TIMEOUT = 5000;
\`\`\`

## Related Documentation

- [Code Style](code-style.md)

EOF

    # Generate git-workflow.md
    cat > "$GUIDELINES_DIR/git-workflow.md" << EOF
---
type: guideline
updated: $(date +%Y-%m-%d)
---

# Git Workflow

## Branch Strategy

### Main Branches
- \`main\` - Production-ready code
- \`develop\` - Integration branch

### Feature Branches
\`\`\`
feature/[feature-name]
feature/user-authentication
feature/payment-integration
\`\`\`

### Bug Fix Branches
\`\`\`
bugfix/[bug-description]
bugfix/login-error
bugfix/validation-issue
\`\`\`

### Release Branches
\`\`\`
release/[version]
release/1.0.0
release/2.1.0
\`\`\`

## Commit Messages

### Format
\`\`\`
<type>(<scope>): <description>

[optional body]

[optional footer]
\`\`\`

### Types
- \`feat\` - New feature
- \`fix\` - Bug fix
- \`docs\` - Documentation
- \`style\` - Formatting
- \`refactor\` - Code refactoring
- \`test\` - Adding tests
- \`chore\` - Maintenance

### Examples
\`\`\`
feat(auth): add user login functionality

fix(api): handle null response from server

docs(readme): update installation instructions

test(user): add unit tests for UserService
\`\`\`

## Pull Requests

### Title
- Use conventional commit format
- Be descriptive

### Description
- What changed
- Why it changed
- How to test

### Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or documented)

## Code Review

### Before Reviewing
- Read the PR description
- Understand the context
- Check related issues

### When Reviewing
- Be constructive
- Focus on code, not person
- Suggest improvements

### After Reviewing
- Approve or request changes
- Explain your reasoning
- Be responsive to questions

## Related Documentation

- [Code Style](code-style.md)
- [Naming Conventions](naming-conventions.md)

EOF

    log_success "编码规范文档生成完成"
}

# Generate README
generate_readme() {
    log_info "正在生成 README.md..."

    cat > "$OUTPUT_DIR/README.md" << EOF
# Project Documentation

## Overview

This documentation is auto-generated for AI consumption and project understanding.

## Project Type
$PROJECT_TYPE

## Structure

- [Architecture](architecture.md) - System architecture overview
- [Modules](modules/) - Module-level documentation
- [Features](features/) - Feature-level documentation
- [API](api/) - API documentation
- [Changelog](changelog/) - Change records
- [Decisions](decisions/) - Decision log

## Quick Start

### Prerequisites
- List prerequisites here

### Installation
\`\`\`bash
# Installation commands
\`\`\`

### Usage
\`\`\`bash
# Usage commands
\`\`\`

## Navigation

### For AI
1. Start with [Architecture](architecture.md) for system overview
2. Browse [Modules](modules/) for component details
3. Check [Features](features/) for feature documentation
4. Review [API](api/) for interface details

### For Humans
1. Start with this README for overview
2. Follow links to detailed documentation
3. Check [Changelog](changelog/) for recent changes

## Auto-Generated Information

- **Scan Date**: $(date)
- **Project Type**: $PROJECT_TYPE
- **Total Files**: $(find "$SCAN_DIR" -type f -not -path '*/\.*' -not -path '*/node_modules/*' | wc -l)

EOF

    log_success "README.md 生成完成"
}

# Generate architecture documentation
generate_architecture() {
    log_info "正在生成架构文档..."

    cat > "$OUTPUT_DIR/architecture.md" << EOF
# System Architecture

## Overview

This document describes the architecture of the project.

## Project Type
$PROJECT_TYPE

## Directory Structure

\`\`\`
$(find "$SCAN_DIR" -maxdepth 3 -type d -not -path '*/\.*' -not -path '*/node_modules/*' | head -20 | sort)
\`\`\`

## Entry Points

$(if [[ ${#ENTRY_POINTS[@]} -gt 0 ]]; then
    for entry in "${ENTRY_POINTS[@]}"; do
        echo "- \`$entry\`"
    done
else
    echo "No entry points detected"
fi)

## Main Components

$(for dir in "${MAIN_DIRS[@]}"; do
    if [[ -d "$dir" ]] && [[ "$dir" != "$SCAN_DIR" ]]; then
        local dirname=$(basename "$dir")
        echo "### $dirname"
        echo ""
        echo "Description of $dirname component."
        echo ""
    fi
done)

## Dependencies

### External Dependencies
$(if [[ -f "$SCAN_DIR/package.json" ]]; then
    echo "Node.js dependencies detected. See package.json for details."
elif [[ -f "$SCAN_DIR/requirements.txt" ]]; then
    echo "Python dependencies detected. See requirements.txt for details."
else
    echo "No dependency files detected."
fi)

### Internal Dependencies
Document internal module dependencies here.

## Data Flow

Describe how data flows through the system.

## Control Flow

Describe how control flows through the system.

## Design Decisions

Key architectural decisions are documented in the [decisions](decisions/) directory.

EOF

    log_success "架构文档生成完成"
}

# Generate module documentation
generate_module_docs() {
    log_info "正在生成模块文档..."

    local module_count=0
    local src_dir="$SCAN_DIR/src"

    # Check if src directory exists
    if [[ ! -d "$src_dir" ]]; then
        log_warning "未找到 src/ 目录，跳过模块文档生成"
        return
    fi

    # Only scan modules inside src/
    for dir in "$src_dir"/*/; do
        if [[ -d "$dir" ]]; then
            local module_name=$(basename "$dir")
            local module_dir="$MODULES_DIR/$module_name"

            mkdir -p "$module_dir"

            # Generate module README
            cat > "$module_dir/README.md" << EOF
# $module_name Module

## Overview

Description of the $module_name module.

## Purpose
- Primary responsibility 1
- Primary responsibility 2

## Files
$(find "$dir" -type f -not -path '*/\.*' | head -10 | while read -r file; do
    echo "- \`$(basename "$file")\`"
done)

## Dependencies
List dependencies here.

## Usage
\`\`\`typescript
// Usage example
\`\`\`

## Related Documentation
- [Interfaces](interfaces.md)
- [Implementation](implementation.md)
- [Dependencies](dependencies.md)

EOF

            ((module_count++))
        fi
    done

    log_success "已生成 $module_count 个模块的文档"
}

# Generate feature documentation
generate_feature_docs() {
    log_info "正在生成功能文档..."

    # Create features index
    cat > "$FEATURES_DIR/README.md" << EOF
---
type: features-index
updated: $(date +%Y-%m-%d)
---

# Features Index

## Overview

This directory contains documentation for all project features.

## Structure

Each feature has its own folder:
\`\`\`
features/
├── README.md                  # This index file
├── [feature-1]/
│   ├── README.md              # Feature summary
│   ├── requirements.md        # Requirements
│   ├── design.md              # Design decisions
│   └── implementation.md      # Implementation details
└── [feature-2]/
    └── ...
\`\`\`

## Feature List

| Feature | Status | Description |
|---------|--------|-------------|
| _No features documented yet_ | | |

## How to Add a Feature

1. Create a new folder: \`features/[feature-name]/\`
2. Copy templates from \`assets/templates/feature-doc.md\`
3. Fill in the documentation
4. Update this index file

## Related Documentation

- [Modules](../modules/) - Module documentation
- [API](../api/) - API documentation
- [Versions](../versions/) - Version history

EOF

    log_success "功能文档生成完成"
}

# Generate API documentation
generate_api_docs() {
    log_info "正在生成 API 文档..."

    # Create API index
    cat > "$API_DIR/README.md" << EOF
---
type: api-index
updated: $(date +%Y-%m-%d)
---

# API Index

## Overview

This directory contains documentation for all project APIs.

## Structure

Each API has its own folder:
\`\`\`
api/
├── README.md                  # This index file
├── [api-1]/
│   ├── README.md              # API overview
│   ├── endpoints.md           # Endpoint documentation
│   ├── schemas.md             # Data schemas
│   └── examples.md            # Usage examples
└── [api-2]/
    └── ...
\`\`\`

## API List

| API | Version | Base URL | Description |
|-----|---------|----------|-------------|
| _No APIs documented yet_ | | | |

## Authentication

Document authentication methods here.

## Common Patterns

- Error handling
- Rate limiting
- Pagination

## How to Add an API

1. Create a new folder: \`api/[api-name]/\`
2. Copy templates from \`assets/templates/\`
3. Fill in the documentation
4. Update this index file

## Related Documentation

- [Modules](../modules/) - Module documentation
- [Features](../features/) - Feature documentation
- [Architecture](../architecture.md) - System architecture

EOF

    log_success "API 文档生成完成"
}

# Generate changelog
generate_changelog() {
    log_info "正在生成变更日志..."

    cat > "$CHANGELOG_DIR/README.md" << EOF
# Changelog

## Overview

This directory contains change records for the project.

## Format

Each change record follows the format defined in the audit specification.

## Recent Changes

$(date +%Y-%m-%d): Initial documentation generation

EOF

    # Create initial change record
    cat > "$CHANGELOG_DIR/$(date +%Y-%m-%d)-initial-docs.md" << EOF
---
date: $(date +%Y-%m-%d)
type: docs
title: "Initial Documentation Generation"
author: "Auto-generated"
modules: [all]
impact: low
status: completed
---

# Initial Documentation Generation

## Summary
Auto-generated documentation for the codebase.

## Changes Made
- Generated README.md
- Generated architecture.md
- Generated module documentation
- Generated feature documentation templates
- Generated API documentation templates

## Motivation
Establish documentation foundation for AI consumption.

## Testing
N/A - Documentation only

## Rollback Plan
Delete the docs/ directory.

EOF

    log_success "变更日志生成完成"
}

# Generate decisions log
generate_decisions() {
    log_info "正在生成决策日志..."

    cat > "$DECISIONS_DIR/README.md" << EOF
# Decision Log

## Overview

This directory contains architectural and design decisions.

## Format

Each decision follows the decision record format.

## Decisions

$(date +%Y-%m-%d): Initial documentation structure

EOF

    # Create initial decision record
    cat > "$DECISIONS_DIR/$(date +%Y-%m-%d)-documentation-structure.md" << EOF
---
date: $(date +%Y-%m-%d)
status: accepted
modules: [documentation]
---

# Documentation Structure Decision

## Status
Accepted

## Context
Need to establish documentation structure for AI consumption.

## Decision
Use hierarchical documentation structure optimized for AI.

## Consequences
### Positive
- Clear structure for AI navigation
- Consistent format across documents
- Easy to maintain and update

### Negative
- Initial setup required
- Must follow conventions

## Alternatives Considered
1. **Flat structure**: Simpler but harder to navigate
2. **Wiki-style**: More flexible but less structured
3. **Hierarchical**: Clear organization, easy navigation

## Rationale
Hierarchical structure best fits AI consumption patterns.

EOF

    log_success "决策日志生成完成"
}

# Generate summary
generate_summary() {
    log_info "正在生成摘要..."

    echo ""
    echo "=========================================="
    echo "文档生成完成"
    echo "=========================================="
    echo ""
    echo "已生成的文件:"
    find "$OUTPUT_DIR" -type f -name "*.md" | sort | while read -r file; do
        echo "  - $file"
    done
    echo ""
    echo "后续步骤:"
    echo "1. 审查生成的文档"
    echo "2. 根据需要自定义模板"
    echo "3. 为每个文档添加具体细节"
    echo "4. 开发前运行 /docs-read"
    echo "5. 开发后运行 /docs-record"
    echo ""
}

# Show step progress
show_step() {
    local step=$1
    local total=$2
    local description=$3

    echo ""
    echo -e "${BLUE}[步骤 $step/$total]${NC} $description"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Main function
main() {
    local TOTAL_STEPS=8
    local CURRENT_STEP=0
    local MAIN_START_TIME=$(date +%s)

    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║           代码文档自动扫描系统                            ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    log_info "扫描目录: $SCAN_DIR"
    log_info "输出目录: $OUTPUT_DIR"
    echo ""

    # Check if this is a rescan
    if [[ -d "$OUTPUT_DIR" ]]; then
        log_warning "检测到已存在的 .ai-context 目录"
        log_warning "这看起来是一次重新扫描（非首次）"
        echo ""
        read -p "是否继续重新扫描？(y/N): " confirm
        if [[ "$confirm" != "y" ]] && [[ "$confirm" != "Y" ]]; then
            log_info "已取消"
            exit 0
        fi
        echo ""
    fi

    # Step 1: Create directory structure
    ((CURRENT_STEP++))
    show_step $CURRENT_STEP $TOTAL_STEPS "创建目录结构"
    create_directory_structure

    # Step 2: Scan files
    ((CURRENT_STEP++))
    show_step $CURRENT_STEP $TOTAL_STEPS "扫描代码文件"
    scan_files

    # Step 3: Analyze structure
    ((CURRENT_STEP++))
    show_step $CURRENT_STEP $TOTAL_STEPS "分析项目结构"
    analyze_structure

    # Step 4: Generate README
    ((CURRENT_STEP++))
    show_step $CURRENT_STEP $TOTAL_STEPS "生成项目概览"
    generate_readme

    # Step 5: Generate architecture
    ((CURRENT_STEP++))
    show_step $CURRENT_STEP $TOTAL_STEPS "生成架构文档"
    generate_architecture

    # Step 6: Generate guidelines
    ((CURRENT_STEP++))
    show_step $CURRENT_STEP $TOTAL_STEPS "生成编码规范"
    generate_guidelines_docs

    # Step 7: Generate modules
    ((CURRENT_STEP++))
    show_step $CURRENT_STEP $TOTAL_STEPS "生成模块文档"
    generate_module_docs
    generate_feature_docs
    generate_api_docs

    # Step 8: Generate changelog and decisions
    ((CURRENT_STEP++))
    show_step $CURRENT_STEP $TOTAL_STEPS "生成变更记录和决策日志"
    generate_changelog
    generate_decisions

    # Calculate total time
    local MAIN_END_TIME=$(date +%s)
    local TOTAL_TIME=$((MAIN_END_TIME - MAIN_START_TIME))
    local TOTAL_MIN=$((TOTAL_TIME / 60))
    local TOTAL_SEC=$((TOTAL_TIME % 60))

    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                    扫描完成！                             ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
    log_success "文档生成完成！总耗时: ${TOTAL_MIN}分${TOTAL_SEC}秒"

    # Generate summary
    generate_summary
}

# Run main function
main
