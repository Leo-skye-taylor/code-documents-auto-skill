#!/bin/bash

# Change Recording Script
# This script records changes with complete audit trail

set -e

# Configuration
DOCS_DIR="ai-context"
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
用法: $0 [选项] [描述]

记录变更并生成完整的审计跟踪。

选项:
    -h, --help          显示此帮助信息
    -v, --verbose       启用详细输出
    -t, --type          变更类型 (feature|bugfix|refactor|docs|test|config|deps|perf|security|style)
    -m, --modules       受影响的模块（逗号分隔）
    -i, --impact        影响级别 (low|medium|high|critical)
    -a, --author        作者姓名
    -T, --tickets       相关工单（逗号分隔）
    -r, --reviewers     审查者（逗号分隔）
    -b, --breaking      标记为重大变更
    -V, --version       引入的版本
    -I, --interactive   交互模式
    -T, --template      使用自定义模板

参数:
    描述                变更的简要描述

示例:
    $0 "添加用户登录功能"
    $0 -t feature -m auth,user -i high "实现身份验证"
    $0 --interactive

EOF
}

# Parse arguments
VERBOSE=false
INTERACTIVE=false
CHANGE_TYPE=""
MODULES=""
IMPACT_LEVEL=""
AUTHOR=""
TICKETS=""
REVIEWERS=""
BREAKING=false
VERSION=""
DESCRIPTION=""
TEMPLATE_FILE=""

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
        -t|--type)
            CHANGE_TYPE="$2"
            shift 2
            ;;
        -m|--modules)
            MODULES="$2"
            shift 2
            ;;
        -i|--impact)
            IMPACT_LEVEL="$2"
            shift 2
            ;;
        -a|--author)
            AUTHOR="$2"
            shift 2
            ;;
        -T|--tickets)
            TICKETS="$2"
            shift 2
            ;;
        -r|--reviewers)
            REVIEWERS="$2"
            shift 2
            ;;
        -b|--breaking)
            BREAKING=true
            shift
            ;;
        -V|--version)
            VERSION="$2"
            shift 2
            ;;
        -I|--interactive)
            INTERACTIVE=true
            shift
            ;;
        -T|--template)
            TEMPLATE_FILE="$2"
            shift 2
            ;;
        -*)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            DESCRIPTION="$1"
            shift
            ;;
    esac
done

# Check if docs directory exists
if [[ ! -d "$DOCS_DIR" ]]; then
    log_error "文档目录不存在: $DOCS_DIR"
    log_error "请先运行 /docs-scan 生成文档"
    exit 1
fi

# Create changelog directory if it doesn't exist
mkdir -p "$CHANGELOG_DIR"
mkdir -p "$DECISIONS_DIR"

# Interactive mode
interactive_mode() {
    log_info "交互式变更记录模式"
    echo ""

    # Get description
    if [[ -z "$DESCRIPTION" ]]; then
        read -p "变更描述: " DESCRIPTION
    fi

    # Get change type
    if [[ -z "$CHANGE_TYPE" ]]; then
        echo ""
        echo "选择变更类型:"
        echo "1) feature (功能)"
        echo "2) bugfix (Bug修复)"
        echo "3) refactor (重构)"
        echo "4) docs (文档)"
        echo "5) test (测试)"
        echo "6) config (配置)"
        echo "7) deps (依赖)"
        echo "8) perf (性能)"
        echo "9) security (安全)"
        echo "10) style (风格)"
        echo ""
        read -p "请输入选择 (1-10): " type_choice

        case $type_choice in
            1) CHANGE_TYPE="feature" ;;
            2) CHANGE_TYPE="bugfix" ;;
            3) CHANGE_TYPE="refactor" ;;
            4) CHANGE_TYPE="docs" ;;
            5) CHANGE_TYPE="test" ;;
            6) CHANGE_TYPE="config" ;;
            7) CHANGE_TYPE="deps" ;;
            8) CHANGE_TYPE="perf" ;;
            9) CHANGE_TYPE="security" ;;
            10) CHANGE_TYPE="style" ;;
            *) CHANGE_TYPE="feature" ;;
        esac
    fi

    # Get modules
    if [[ -z "$MODULES" ]]; then
        echo ""
        read -p "受影响的模块（逗号分隔）: " MODULES
    fi

    # Get impact level
    if [[ -z "$IMPACT_LEVEL" ]]; then
        echo ""
        echo "选择影响级别:"
        echo "1) low (低)"
        echo "2) medium (中)"
        echo "3) high (高)"
        echo "4) critical (严重)"
        echo ""
        read -p "请输入选择 (1-4): " impact_choice

        case $impact_choice in
            1) IMPACT_LEVEL="low" ;;
            2) IMPACT_LEVEL="medium" ;;
            3) IMPACT_LEVEL="high" ;;
            4) IMPACT_LEVEL="critical" ;;
            *) IMPACT_LEVEL="medium" ;;
        esac
    fi

    # Get author
    if [[ -z "$AUTHOR" ]]; then
        echo ""
        read -p "作者姓名: " AUTHOR
    fi

    # Get tickets
    if [[ -z "$TICKETS" ]]; then
        echo ""
        read -p "相关工单（逗号分隔，可选）: " TICKETS
    fi

    # Get reviewers
    if [[ -z "$REVIEWERS" ]]; then
        echo ""
        read -p "审查者（逗号分隔，可选）: " REVIEWERS
    fi

    # Get breaking change
    if [[ "$BREAKING" == false ]]; then
        echo ""
        read -p "这是重大变更吗？(y/N): " breaking_choice
        if [[ "$breaking_choice" == "y" ]] || [[ "$breaking_choice" == "Y" ]]; then
            BREAKING=true
        fi
    fi

    # Get version
    if [[ -z "$VERSION" ]]; then
        echo ""
        read -p "引入的版本（可选）: " VERSION
    fi
}

# Validate inputs
validate_inputs() {
    local valid=true

    if [[ -z "$DESCRIPTION" ]]; then
        log_error "描述是必需的"
        valid=false
    fi

    if [[ -z "$CHANGE_TYPE" ]]; then
        log_error "变更类型是必需的"
        valid=false
    fi

    if [[ -z "$IMPACT_LEVEL" ]]; then
        log_error "影响级别是必需的"
        valid=false
    fi

    if [[ -z "$AUTHOR" ]]; then
        log_error "作者是必需的"
        valid=false
    fi

    if [[ "$valid" == false ]]; then
        exit 1
    fi
}

# Generate change record filename
generate_filename() {
    local date=$(date +%Y-%m-%d)
    local slug=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
    local filename="$date-$CHANGE_TYPE-$slug.md"

    echo "$filename"
}

# Generate change record
generate_change_record() {
    local filename="$1"
    local filepath="$CHANGELOG_DIR/$filename"

    log_info "正在生成变更记录: $filename"

    # Convert modules string to YAML array
    local modules_yaml=""
    if [[ -n "$MODULES" ]]; then
        modules_yaml=$(echo "$MODULES" | tr ',' '\n' | sed 's/^/  - /' | tr '\n' '\n')
    fi

    # Convert tickets string to YAML array
    local tickets_yaml=""
    if [[ -n "$TICKETS" ]]; then
        tickets_yaml=$(echo "$TICKETS" | tr ',' '\n' | sed 's/^/  - /' | tr '\n' '\n')
    fi

    # Convert reviewers string to YAML array
    local reviewers_yaml=""
    if [[ -n "$REVIEWERS" ]]; then
        reviewers_yaml=$(echo "$REVIEWERS" | tr ',' '\n' | sed 's/^/  - /' | tr '\n' '\n')
    fi

    # Generate file
    cat > "$filepath" << EOF
---
date: $(date +%Y-%m-%d)
type: $CHANGE_TYPE
title: "$DESCRIPTION"
author: "$AUTHOR"
modules:
$modules_yaml
impact: $IMPACT_LEVEL
status: completed
tickets:
$tickets_yaml
reviewers:
$reviewers_yaml
breaking: $BREAKING
version: "$VERSION"
---

# $DESCRIPTION

## Summary

### What Changed
- [ ] Change 1: Description
- [ ] Change 2: Description
- [ ] Change 3: Description

### Why Changed
- Reason 1: Description
- Reason 2: Description

### Scope
- **Modules affected**: $MODULES
- **Files changed**: [Count]
- **Lines added**: [Count]
- **Lines removed**: [Count]

## Motivation

### Business Context
Why this change was needed from a business perspective.

#### Problem Statement
What problem this change solves.

#### Business Impact
How this change affects the business.

#### User Impact
How this change affects users.

### Technical Context
Why this change was needed from a technical perspective.

#### Technical Debt
What technical debt this addresses.

#### Performance Issues
What performance issues this resolves.

#### Security Concerns
What security concerns this addresses.

### User Feedback
If applicable, what users requested.

## Changes Made

### Code Changes

#### New Files
- \`path/to/file1.ts\`: Description of what it does
- \`path/to/file2.ts\`: Description of what it does

#### Modified Files
- \`path/to/file1.ts\`: Description of changes
- \`path/to/file2.ts\`: Description of changes

#### Deleted Files
- \`path/to/file1.ts\`: Reason for deletion

### Configuration Changes

#### Environment Variables
- **Added**: NEW_VARIABLE - Description
- **Modified**: EXISTING_VARIABLE - Old value → New value

#### Configuration Files
- \`config/app.json\`: Description of changes

### Database Changes

#### New Tables
\`\`\`sql
CREATE TABLE new_table (
  id UUID PRIMARY KEY,
  field1 VARCHAR(255) NOT NULL
);
\`\`\`

#### Modified Tables
\`\`\`sql
ALTER TABLE existing_table
ADD COLUMN new_column TYPE;
\`\`\`

### API Changes

#### New Endpoints
- \`POST /api/new-endpoint\`: Description

#### Modified Endpoints
- \`PUT /api/existing-endpoint\`: Description of changes

### Documentation Changes

#### New Documentation
- \`docs/new-doc.md\`: Description

#### Updated Documentation
- \`docs/existing-doc.md\`: Description of updates

## Before State

### System State
Describe the state of the system before the change.

### Code State
Describe the state of the code before the change.

### Data State
Describe the state of the data before the change.

## After State

### System State
Describe the state of the system after the change.

### Code State
Describe the state of the code after the change.

### Data State
Describe the state of the data after the change.

## Impact Analysis

### Direct Impacts

#### Module 1
- **Impact**: Description
- **Risk Level**: Low/Medium/High
- **Mitigation**: How to reduce risk
- **Testing**: How to verify

### Indirect Impacts

#### System 1
- **Impact**: Description
- **Risk Level**: Low/Medium/High
- **Mitigation**: How to reduce risk
- **Monitoring**: How to monitor

### Performance Impact

#### Latency
- **Before**: [X]ms
- **After**: [Y]ms
- **Change**: +/- [Z]ms

#### Throughput
- **Before**: [X] requests/second
- **After**: [Y] requests/second
- **Change**: +/- [Z] requests/second

### Security Impact

#### Positive Impacts
- Impact 1: Description

#### Negative Impacts
- Impact 1: Description
- Mitigation: How to address

### User Impact

#### Positive Impacts
- Impact 1: Description

#### Negative Impacts
- Impact 1: Description
- Mitigation: How to address

## Decision Log

### Decision 1: [Decision Title]

**Context:**
What was the situation that required a decision?

**Decision:**
What was decided?

**Alternatives Considered:**

1. **Alternative 1**
   - Pros: List
   - Cons: List
   - Why not: Reason

2. **Alternative 2**
   - Pros: List
   - Cons: List
   - Why not: Reason

**Rationale:**
Why was this decision made?

**Consequences:**
What are the implications of this decision?

## Testing Results

### Unit Tests

#### Test Coverage
- **Overall**: [X]%
- **Module 1**: [X]%
- **Module 2**: [X]%

#### Test Results
\`\`\`
Test Suites: X passed, Y total
Tests:       A passed, B total
\`\`\`

### Integration Tests

#### Test Scenarios
1. **Scenario 1**: Description
   - Result: ✅ Passed

### Security Tests

#### Vulnerability Scanning
- Dependencies: ✅ No known vulnerabilities
- Code analysis: ✅ No issues found

### Performance Tests

#### Load Testing
- **Concurrent Users**: [X]
- **Average Response Time**: [Y]ms

### Manual Testing

#### Test Cases Executed
1. **Test Case 1**: Description
   - Result: ✅ Pass

## Rollback Plan

### Immediate Rollback (Critical Issues)

#### Step 1: Disable Feature Flag
\`\`\`bash
FEATURE_[NAME]_ENABLED=false
\`\`\`

#### Step 2: Revert Database Migration
\`\`\`bash
npm run migrate:rollback -- --steps=1
\`\`\`

#### Step 3: Deploy Previous Version
\`\`\`bash
git checkout v1.2.3
npm run deploy
\`\`\`

### Gradual Rollback (Non-Critical Issues)

#### Step 1: Reduce Feature Flag Percentage
\`\`\`bash
FEATURE_[NAME]_ROLLOUT_PERCENTAGE=10
\`\`\`

### Communication Plan

#### Internal Team
- **Channel**: Slack #engineering
- **Message**: Description of rollback

#### External Users
- **Channel**: Email notification
- **Message**: Description of impact

## Lessons Learned

### What Went Well

1. **Success 1**: Description
   - Why it went well
   - How to replicate

### What Could Be Improved

1. **Improvement 1**: Description
   - What happened
   - What should have happened
   - How to improve

### Action Items

1. **Action 1**: Description
   - Owner: Who is responsible
   - Due date: When it should be done

### Knowledge Gained

1. **Knowledge 1**: Description
   - Context: When this applies
   - Application: How to use it

## Related Changes

### Dependencies
- Change 1: Description and relationship

### Follow-ups
- Change 1: Description and timeline

## References

### Documentation
- [Doc 1]: Link and description

### Code
- [PR 1]: Link and description

### External Resources
- [Resource 1]: Link and description

## Sign-off

### Developer
- **Name**: $AUTHOR
- **Date**: $(date +%Y-%m-%d)
- **Confirmation**: I confirm this change is complete and tested

### Reviewer
- **Name**: [Reviewer Name]
- **Date**: [Date]
- **Confirmation**: I confirm this change has been reviewed

### Approver
- **Name**: [Approver Name]
- **Date**: [Date]
- **Confirmation**: I confirm this change is approved for deployment
EOF

    log_success "Change record generated: $filepath"
}

# Generate decision record if needed
generate_decision_record() {
    if [[ "$CHANGE_TYPE" == "feature" ]] || [[ "$CHANGE_TYPE" == "refactor" ]]; then
        log_info "正在生成决策记录..."

        local date=$(date +%Y-%m-%d)
        local slug=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
        local filename="$date-decision-$slug.md"
        local filepath="$DECISIONS_DIR/$filename"

        cat > "$filepath" << EOF
---
date: $date
status: accepted
modules: [$(echo "$MODULES" | tr ',' ', ')]
---

# Decision: $DESCRIPTION

## Status
Accepted

## Context
What was the situation that required a decision?

## Decision
What was decided?

## Consequences

### Positive
- Benefit 1: Description
- Benefit 2: Description

### Negative
- Drawback 1: Description
- Drawback 2: Description

## Alternatives Considered

### Alternative 1: [Name]
**Pros:**
- Pro 1: Description
- Pro 2: Description

**Cons:**
- Con 1: Description
- Con 2: Description

**Why not:**
Reason for not choosing this alternative.

### Alternative 2: [Name]
**Pros:**
- Pro 1: Description
- Pro 2: Description

**Cons:**
- Con 1: Description
- Con 2: Description

**Why not:**
Reason for not choosing this alternative.

## Rationale
Why was this decision made?

## Review Date
When should this decision be reviewed?
EOF

        log_success "决策记录已生成: $filepath"
    fi
}

# Update documentation
update_documentation() {
    log_info "正在更新文档..."

    # Update changelog README
    if [[ -f "$CHANGELOG_DIR/README.md" ]]; then
        # Add entry to changelog README
        local entry="- $(date +%Y-%m-%d): $DESCRIPTION"
        sed -i '' "/## Recent Changes/a\\
$entry
" "$CHANGELOG_DIR/README.md"
    fi

    # Update decisions README if decision was generated
    if [[ "$CHANGE_TYPE" == "feature" ]] || [[ "$CHANGE_TYPE" == "refactor" ]]; then
        if [[ -f "$DECISIONS_DIR/README.md" ]]; then
            local entry="- $(date +%Y-%m-%d): Decision for $DESCRIPTION"
            sed -i '' "/## Decisions/a\\
$entry
" "$DECISIONS_DIR/README.md"
        fi
    fi

    log_success "文档更新完成"
}

# Print summary
print_summary() {
    local filename="$1"

    echo ""
    echo "=========================================="
    echo "变更记录已创建"
    echo "=========================================="
    echo ""
    echo "详情:"
    echo "  - 描述: $DESCRIPTION"
    echo "  - 类型: $CHANGE_TYPE"
    echo "  - 影响: $IMPACT_LEVEL"
    echo "  - 作者: $AUTHOR"
    echo "  - 模块: $MODULES"
    echo "  - 重大变更: $BREAKING"
    echo ""
    echo "已创建的文件:"
    echo "  - $CHANGELOG_DIR/$filename"
    if [[ "$CHANGE_TYPE" == "feature" ]] || [[ "$CHANGE_TYPE" == "refactor" ]]; then
        echo "  - $DECISIONS_DIR/$(date +%Y-%m-%d)-decision-*.md"
    fi
    echo ""
    echo "后续步骤:"
    echo "1. 审查并完善变更记录"
    echo "2. 为每个部分添加具体细节"
    echo "3. 获取审查者的签字确认"
    echo "4. 更新相关文档"
    echo ""
}

# Main function
main() {
    log_info "开始记录变更..."
    echo ""

    # Run interactive mode if requested
    if [[ "$INTERACTIVE" == true ]]; then
        interactive_mode
    fi

    # Validate inputs
    validate_inputs

    # Generate filename
    local filename=$(generate_filename)

    # Check if file already exists
    if [[ -f "$CHANGELOG_DIR/$filename" ]]; then
        log_warning "变更记录已存在: $filename"
        read -p "是否覆盖？(y/N): " overwrite
        if [[ "$overwrite" != "y" ]] && [[ "$overwrite" != "Y" ]]; then
            log_info "已取消"
            exit 0
        fi
    fi

    # Generate change record
    generate_change_record "$filename"

    # Generate decision record if needed
    generate_decision_record

    # Update documentation
    update_documentation

    # Print summary
    print_summary "$filename"

    log_success "变更记录完成！"
}

# Run main function
main
