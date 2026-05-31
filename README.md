# Code Documents Auto Skill

A Claude Code skill for AI-oriented code documentation management.

## Overview

This skill provides comprehensive code documentation management optimized for AI consumption. It automates the process of scanning codebases, generating structured documentation, enforcing pre-development reading, and recording complete change audit trails.

**All operations are fully automated - no manual user actions required.**

## Features

### 0. Automatic Initialization (First Contact)
- **Auto-detect**: AI automatically detects project status
- **Auto-setup**: AI automatically sets up rules in CLAUDE.md and AGENTS.md
- **Auto-scan**: AI automatically scans codebase if docs don't exist
- **Auto-init**: AI automatically initializes workflow system

### 1. Initial Codebase Scan (`/docs-scan`)
- **Full file scan**: Analyze all code files, configurations, and existing docs
- **Structure analysis**: Map project architecture, dependencies, and relationships
- **AI-friendly output**: Generate documentation optimized for AI consumption
- **Categorization**: Organize by module, feature, and functionality

### 2. Pre-development Reading (`/docs-read`) - MANDATORY
- **Forced reading**: MUST read ALL related documentation before ANY code changes
- **Automatic discovery**: AI automatically finds all related documents
- **Verification**: Reading is recorded and cannot be faked
- **Workflow session**: Starts a tracked workflow session

### 3. Change Recording (`/docs-record`) - MANDATORY
- **Forced documentation**: MUST generate/update ALL documentation after ANY code changes
- **Automatic detection**: AI automatically identifies affected documentation
- **Complete audit trail**: Record all changes with full context
- **Workflow completion**: Completes the workflow session

## Enforced Workflow

**CRITICAL**: This workflow is MANDATORY and CANNOT be skipped.

### Step 1: Before ANY Code Changes
```bash
# Identify what you're going to change
/docs-read src/auth/login.ts src/user/user.service.ts

# Or for entire modules
/docs-read auth,user

# Or for a feature
/docs-read login-feature
```

**What happens:**
1. AI finds ALL related documentation
2. ALL documents MUST be read
3. Reading is recorded
4. Workflow session starts
5. Verification passes

### Step 2: Make Your Code Changes
- Edit code files
- Run tests
- Verify functionality

### Step 3: After ANY Code Changes
```bash
# Document your changes
/docs-record "Add user login functionality"
```

**What happens:**
1. AI detects ALL affected documentation
2. ALL documentation MUST be updated
3. Change record is generated
4. Workflow session completes
5. Audit trail is finalized

**WARNING**: Skipping ANY step will result in workflow failure.

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
