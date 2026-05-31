# Audit Format Specification

This document defines the format and requirements for complete change audit trails.

## Overview

Every change to the codebase must be recorded with a complete audit trail that includes:
- What changed
- Why it changed
- How it changed
- What's affected
- Decision rationale
- Testing results

## Audit Record Structure

### File Naming Convention

```
changelog/
├── YYYY-MM-DD-type-description.md
├── 2024-01-15-feature-user-login.md
├── 2024-01-16-bugfix-auth-validation.md
├── 2024-01-17-refactor-database-layer.md
└── 2024-01-18-docs-api-endpoints.md
```

**Format:** `YYYY-MM-DD-type-description.md`

**Types:**
- `feature`: New feature implementation
- `bugfix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `test`: Test additions/modifications
- `config`: Configuration changes
- `deps`: Dependency updates
- `perf`: Performance improvements
- `security`: Security fixes
- `style`: Code style changes

### YAML Frontmatter

```yaml
---
date: 2024-01-15
type: feature
title: "User Login Feature"
author: "Developer Name"
modules: [auth, user, database]
impact: medium
status: completed
tickets: [AUTH-123, USER-456]
reviewers: [reviewer1, reviewer2]
---
```

**Required Fields:**
- `date`: When the change was made
- `type`: Type of change
- `title`: Brief description
- `author`: Who made the change
- `modules`: Affected modules
- `impact`: Impact level (low/medium/high/critical)

**Optional Fields:**
- `status`: Change status (completed/in-progress/reverted)
- `tickets`: Related issue tickets
- `reviewers`: Who reviewed the change
- `breaking`: Whether this is a breaking change
- `version`: Version introduced

## Audit Sections

### 1. Summary

Brief, clear description of what changed.

```markdown
## Summary

Implemented user login functionality with email/password authentication, including:
- Login API endpoint
- Authentication middleware
- Session management
- Remember me functionality
```

**Requirements:**
- One paragraph maximum
- List key changes
- Be specific, not vague
- Include scope

### 2. Motivation

Why this change was made.

```markdown
## Motivation

### Business Need
Users need to authenticate to access protected resources and personalize their experience.

### Technical Need
- Secure access control required for API endpoints
- User-specific data needs authenticated context
- Compliance requirements for user authentication

### User Request
Feature requested by multiple users in feedback surveys.
```

**Requirements:**
- Explain business context
- Explain technical context
- Reference user feedback if applicable
- Link to requirements/tickets

### 3. Changes Made

Detailed list of all changes.

```markdown
## Changes Made

### Code Changes

#### New Files
- `src/auth/login.controller.ts`: Login endpoint handler
- `src/auth/login.service.ts`: Login business logic
- `src/auth/auth.middleware.ts`: Authentication middleware
- `src/auth/auth.types.ts`: Authentication type definitions

#### Modified Files
- `src/user/user.service.ts`: Added password validation
- `src/database/migrations/002_add_auth_tables.ts`: Auth tables migration
- `src/config/auth.config.ts`: Authentication configuration

#### Deleted Files
- None

### Configuration Changes
- Added JWT_SECRET to environment variables
- Added session configuration to app config
- Updated CORS settings for auth endpoints

### Database Changes
- Added `sessions` table
- Added `login_attempts` table
- Modified `users` table (added `last_login` column)

### Documentation Changes
- Created `docs/api/auth.md`: Authentication API docs
- Updated `docs/modules/auth.md`: Auth module documentation
- Added `docs/guides/login-guide.md`: User login guide
```

**Requirements:**
- List all file changes
- Group by type (new/modified/deleted)
- Include configuration changes
- Include database changes
- Include documentation changes

### 4. Before/After States

Document the state before and after the change.

```markdown
## Before State

### System State
- No authentication mechanism
- All endpoints publicly accessible
- No user sessions

### Code State
- No auth-related code
- No middleware for authentication
- No session management

### Data State
- Users table exists but no auth fields
- No session storage
- No login tracking

## After State

### System State
- JWT-based authentication
- Protected endpoints require auth
- Session management active

### Code State
- Auth module with controllers, services, middleware
- Authentication middleware on protected routes
- Session management with Redis

### Data State
- Sessions table for tracking
- Login attempts table for security
- Users table with auth fields
```

**Requirements:**
- Document system state
- Document code state
- Document data state
- Be specific about changes

### 5. Impact Analysis

Document all impacts of the change.

```markdown
## Impact Analysis

### Direct Impacts

#### Auth Module
- **Impact**: New module created
- **Risk**: Medium (new authentication flow)
- **Mitigation**: Comprehensive testing, gradual rollout

#### User Module
- **Impact**: Added password validation
- **Risk**: Low (additive change)
- **Mitigation**: Backward compatible

#### Database
- **Impact**: New tables and columns
- **Risk**: Medium (schema change)
- **Mitigation**: Migration script, rollback plan

### Indirect Impacts

#### All Protected Endpoints
- **Impact**: Now require authentication
- **Risk**: Medium (breaking change for clients)
- **Mitigation**: Documentation, client SDK updates

#### Logging System
- **Impact**: New auth-related log events
- **Risk**: Low (additive)
- **Mitigation**: None needed

#### Monitoring
- **Impact**: New auth metrics
- **Risk**: Low (additive)
- **Mitigation**: None needed

### Performance Impact
- **Latency**: +50ms per authenticated request (JWT validation)
- **Memory**: +100MB for session cache
- **Storage**: +1GB for session data (estimated)

### Security Impact
- **Positive**: Secure authentication
- **Risk**: New attack surface (mitigated)
- **Mitigation**: Rate limiting, account lockout, secure token handling

### User Impact
- **Positive**: Secure access, personalized experience
- **Negative**: Additional login step
- **Mitigation**: Remember me feature, clear error messages
```

**Requirements:**
- Document direct impacts
- Document indirect impacts
- Assess performance impact
- Assess security impact
- Assess user impact
- Provide mitigation strategies

### 6. Decision Log

Record all decisions made during the change.

```markdown
## Decision Log

### Decision 1: Authentication Method

**Decision:** Use JWT for session management

**Context:**
- Need stateless authentication
- Microservices architecture
- Mobile app support required

**Alternatives Considered:**
1. **Server-side sessions**
   - Pros: Simple, well-understood
   - Cons: Stateful, scaling issues
   
2. **OAuth 2.0**
   - Pros: Industry standard, secure
   - Cons: Complex, requires external provider
   
3. **JWT**
   - Pros: Stateless, scalable, works everywhere
   - Cons: Token size, revocation challenges

**Rationale:**
JWT best fits our stateless architecture and multi-client requirements.

**Consequences:**
- Must handle token refresh
- Must implement token revocation
- Must secure token storage

---

### Decision 2: Password Hashing

**Decision:** Use bcrypt with salt rounds of 12

**Context:**
- Need secure password storage
- Must resist brute force attacks
- Performance acceptable

**Alternatives Considered:**
1. **Argon2**
   - Pros: Most secure
   - Cons: Slower, less library support
   
2. **scrypt**
   - Pros: Memory-hard
   - Cons: Complex implementation
   
3. **bcrypt**
   - Pros: Well-tested, good security, fast enough
   - Cons: Not memory-hard

**Rationale:**
bcrypt provides good security with acceptable performance and broad library support.

**Consequences:**
- Password verification takes ~100ms
- Must use proper salt rounds
- Must handle migration if algorithm changes
```

**Requirements:**
- Document each decision
- Provide context
- List alternatives
- Explain rationale
- Note consequences

### 7. Testing Results

Document all testing performed.

```markdown
## Testing Results

### Unit Tests

#### Test Coverage
- Overall: 95%
- Auth module: 98%
- User module: 92%

#### Test Results
```
Test Suites: 15 passed, 15 total
Tests:       142 passed, 142 total
Snapshots:   0 total
Time:        45.234s
```

### Integration Tests

#### API Endpoint Tests
- Login endpoint: ✅ Passed
- Logout endpoint: ✅ Passed
- Token refresh: ✅ Passed
- Protected endpoints: ✅ Passed

#### Database Tests
- Migration: ✅ Passed
- CRUD operations: ✅ Passed
- Data integrity: ✅ Passed

### Security Tests

#### Penetration Testing
- SQL injection: ✅ Protected
- XSS attacks: ✅ Protected
- CSRF attacks: ✅ Protected
- Brute force: ✅ Protected (rate limiting)

#### Vulnerability Scanning
- Dependencies: ✅ No known vulnerabilities
- Code analysis: ✅ No issues found

### Performance Tests

#### Load Testing
- Concurrent users: 1000
- Requests per second: 500
- Average response time: 150ms
- 95th percentile: 250ms
- 99th percentile: 400ms

#### Stress Testing
- Breaking point: 5000 concurrent users
- Recovery time: 30 seconds
- Resource usage: Acceptable

### Manual Testing

#### Test Scenarios
1. **Happy path**: Login with valid credentials ✅
2. **Invalid password**: Login with wrong password ✅
3. **Invalid email**: Login with non-existent email ✅
4. **Account lockout**: After 5 failed attempts ✅
5. **Password reset**: Full flow ✅
6. **Remember me**: Token persistence ✅
7. **Logout**: Session invalidation ✅

#### Browser Testing
- Chrome: ✅ Passed
- Firefox: ✅ Passed
- Safari: ✅ Passed
- Edge: ✅ Passed

#### Mobile Testing
- iOS Safari: ✅ Passed
- Android Chrome: ✅ Passed
```

**Requirements:**
- Document unit test results
- Document integration test results
- Document security test results
- Document performance test results
- Document manual testing
- Include coverage metrics

### 8. Rollback Plan

How to revert the change if needed.

```markdown
## Rollback Plan

### Immediate Rollback (if critical issue)

1. **Disable feature flag**
   ```bash
   # Set feature flag to false
   FEATURE_AUTH_ENABLED=false
   ```

2. **Revert database migration**
   ```bash
   # Run rollback migration
   npm run migrate:rollback -- --steps=1
   ```

3. **Deploy previous version**
   ```bash
   # Deploy last known good version
   git checkout v1.2.3
   npm run deploy
   ```

### Gradual Rollback (if non-critical)

1. **Disable for specific users**
   - Update user feature flags
   - Monitor for issues

2. **Increase monitoring**
   - Add alerts for auth errors
   - Monitor performance metrics

3. **Prepare rollback scripts**
   - Test rollback procedure
   - Document rollback steps

### Data Recovery

1. **Session data**
   - Sessions will be invalidated
   - Users will need to re-login

2. **Login attempts**
   - Data preserved for analysis
   - No recovery needed

3. **User data**
   - No data loss expected
   - Backup available if needed

### Communication Plan

1. **Internal team**
   - Notify via Slack
   - Update status page

2. **External users**
   - Send email notification
   - Update documentation

3. **Stakeholders**
   - Provide incident report
   - Schedule review meeting
```

**Requirements:**
- Provide immediate rollback steps
- Provide gradual rollback steps
- Document data recovery
- Plan communication

### 9. Lessons Learned

Document what was learned from this change.

```markdown
## Lessons Learned

### What Went Well
1. **Comprehensive testing**: Caught issues early
2. **Documentation**: Clear and complete
3. **Code review**: Multiple reviewers caught problems

### What Could Be Improved
1. **Performance testing**: Should have tested earlier
2. **Security review**: Could have been more thorough
3. **Communication**: Users needed more notice

### Action Items
1. **Performance**: Add performance testing to CI/CD
2. **Security**: Implement security review checklist
3. **Communication**: Create user notification template

### Knowledge Gained
1. **JWT best practices**: Learned proper token handling
2. **Security patterns**: Improved security understanding
3. **Testing strategies**: Better testing approaches
```

**Requirements:**
- Document successes
- Document improvements
- Create action items
- Record knowledge gained

## Validation Rules

### Required Sections

Every audit record must include:
- [ ] Summary
- [ ] Motivation
- [ ] Changes Made
- [ ] Impact Analysis
- [ ] Decision Log
- [ ] Testing Results

### Completeness Checks

- [ ] All file changes listed
- [ ] All decisions documented
- [ ] All impacts assessed
- [ ] All tests recorded
- [ ] Rollback plan provided

### Quality Checks

- [ ] Clear and specific language
- [ ] No vague statements
- [ ] Actionable information
- [ ] Proper formatting
- [ ] Consistent structure

## Automation

### Pre-commit Hooks

```bash
#!/bin/bash
# Validate audit record before commit

# Check if audit record exists
if [ ! -f "docs/changelog/$(date +%Y-%m-%d)*.md" ]; then
    echo "Error: No audit record for today"
    exit 1
fi

# Validate audit record structure
python scripts/validate-audit.py docs/changelog/$(date +%Y-%m-%d)*.md
```

### CI/CD Integration

```yaml
# .github/workflows/audit.yml
name: Audit Validation

on:
  pull_request:
    paths:
      - 'src/**'
      - 'docs/**'

jobs:
  validate-audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate Audit Record
        run: |
          python scripts/validate-audit.py docs/changelog/
```

### Validation Script

```python
#!/usr/bin/env python3
"""Validate audit records against specification."""

import yaml
import sys
from pathlib import Path

REQUIRED_SECTIONS = [
    'Summary',
    'Motivation',
    'Changes Made',
    'Impact Analysis',
    'Decision Log',
    'Testing Results',
]

REQUIRED_FRONTMATTER = [
    'date',
    'type',
    'title',
    'author',
    'modules',
    'impact',
]

def validate_audit_record(filepath):
    """Validate a single audit record."""
    with open(filepath) as f:
        content = f.read()
    
    # Check frontmatter
    if not content.startswith('---'):
        return False, "Missing YAML frontmatter"
    
    # Parse frontmatter
    parts = content.split('---', 2)
    if len(parts) < 3:
        return False, "Invalid frontmatter format"
    
    try:
        frontmatter = yaml.safe_load(parts[1])
    except yaml.YAMLError as e:
        return False, f"Invalid YAML: {e}"
    
    # Check required frontmatter fields
    for field in REQUIRED_FRONTMATTER:
        if field not in frontmatter:
            return False, f"Missing frontmatter field: {field}"
    
    # Check required sections
    for section in REQUIRED_SECTIONS:
        if f"## {section}" not in content:
            return False, f"Missing section: {section}"
    
    return True, "Valid"

def main():
    """Main validation function."""
    if len(sys.argv) < 2:
        print("Usage: validate-audit.py <directory>")
        sys.exit(1)
    
    directory = Path(sys.argv[1])
    if not directory.exists():
        print(f"Directory not found: {directory}")
        sys.exit(1)
    
    errors = []
    for filepath in directory.glob("*.md"):
        valid, message = validate_audit_record(filepath)
        if not valid:
            errors.append(f"{filepath}: {message}")
    
    if errors:
        print("Validation errors:")
        for error in errors:
            print(f"  - {error}")
        sys.exit(1)
    else:
        print("All audit records valid")

if __name__ == '__main__':
    main()
```

## Best Practices

### 1. Write Audit Records as You Code

Don't wait until the end. Write the audit record alongside the code changes.

### 2. Be Specific

Avoid vague statements. Be precise about what changed and why.

### 3. Include All Context

AI needs complete context. Don't assume knowledge.

### 4. Document Decisions

Record all decisions, even small ones. They provide context.

### 5. Test Thoroughly

Document all testing, including manual testing.

### 6. Plan for Rollback

Always have a rollback plan, even for small changes.

### 7. Learn from Each Change

Document lessons learned to improve future changes.

### 8. Keep Records Updated

Update audit records if issues are found after the fact.

## Examples

### Good Audit Record

See the complete example in the [Audit Record Structure](#audit-record-structure) section.

### Bad Audit Record

```markdown
---
date: 2024-01-15
type: feature
---

# Login Feature

Added login feature.

## Changes
- Added login endpoint
- Added auth middleware

## Testing
Tests pass.
```

**Problems:**
- Missing required frontmatter fields
- Missing required sections
- Vague descriptions
- No impact analysis
- No decision log
- No rollback plan

## Maintenance

### Regular Reviews

1. **Weekly**: Review recent audit records
2. **Monthly**: Check for completeness
3. **Quarterly**: Update specification if needed

### Updates

- Add new sections as needed
- Update validation rules
- Improve examples
- Refine best practices

### Quality Metrics

- Audit record completeness
- Time to create audit records
- Quality of impact analysis
- Usefulness for future reference
