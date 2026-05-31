---
date: YYYY-MM-DD
type: feature|bugfix|refactor|docs|test|config|deps|perf|security|style
title: "[Change Title]"
author: "[Author Name]"
modules: [list of affected modules]
impact: low|medium|high|critical
status: completed|in-progress|reverted
tickets: [list of related tickets]
reviewers: [list of reviewers]
breaking: true|false
version: "[version]"
---

# [Change Title]

## Summary

Brief, clear description of what changed and why.

### What Changed
- Change 1: Description
- Change 2: Description
- Change 3: Description

### Why Changed
- Reason 1: Description
- Reason 2: Description

### Scope
- **Modules affected**: List
- **Files changed**: Count
- **Lines added**: Count
- **Lines removed**: Count

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

#### Feature Requests
Links to feature requests.

#### Bug Reports
Links to bug reports.

#### Support Tickets
Links to support tickets.

## Changes Made

### Code Changes

#### New Files
- `path/to/file1.ts`: Description of what it does
- `path/to/file2.ts`: Description of what it does
- `path/to/file3.ts`: Description of what it does

#### Modified Files
- `path/to/file1.ts`: Description of changes
- `path/to/file2.ts`: Description of changes
- `path/to/file3.ts`: Description of changes

#### Deleted Files
- `path/to/file1.ts`: Reason for deletion
- `path/to/file2.ts`: Reason for deletion

### Configuration Changes

#### Environment Variables
- **Added**: NEW_VARIABLE - Description
- **Modified**: EXISTING_VARIABLE - Old value → New value
- **Removed**: OLD_VARIABLE - Reason

#### Configuration Files
- `config/app.json`: Description of changes
- `config/database.json`: Description of changes

### Database Changes

#### New Tables
```sql
CREATE TABLE new_table (
  id UUID PRIMARY KEY,
  field1 VARCHAR(255) NOT NULL,
  field2 INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Modified Tables
```sql
ALTER TABLE existing_table
ADD COLUMN new_column TYPE;

ALTER TABLE existing_table
MODIFY COLUMN existing_column NEW_TYPE;
```

#### Data Migrations
- Migration 1: Description
- Migration 2: Description

### API Changes

#### New Endpoints
- `POST /api/new-endpoint`: Description
- `GET /api/new-endpoint/:id`: Description

#### Modified Endpoints
- `PUT /api/existing-endpoint`: Description of changes

#### Deprecated Endpoints
- `DELETE /api/old-endpoint`: Deprecated, use new-endpoint instead

#### Removed Endpoints
- `GET /api/removed-endpoint`: Removed in version X.Y.Z

### Documentation Changes

#### New Documentation
- `docs/new-doc.md`: Description
- `docs/guides/new-guide.md`: Description

#### Updated Documentation
- `docs/existing-doc.md`: Description of updates
- `README.md`: Description of updates

## Before State

### System State
Describe the state of the system before the change.

#### Components
- Component 1: State description
- Component 2: State description

#### Data
- Data 1: State description
- Data 2: State description

#### Configuration
- Config 1: State description
- Config 2: State description

### Code State
Describe the state of the code before the change.

#### Architecture
- How the system was structured
- Key components and their relationships

#### Dependencies
- What the system depended on
- Versions of dependencies

#### Patterns
- Design patterns used
- Coding patterns used

### Data State
Describe the state of the data before the change.

#### Database Schema
- Tables and their structure
- Relationships between tables

#### Data Volume
- Amount of data
- Growth rate

#### Data Quality
- Data integrity
- Data consistency

## After State

### System State
Describe the state of the system after the change.

#### Components
- Component 1: State description
- Component 2: State description

#### Data
- Data 1: State description
- Data 2: State description

#### Configuration
- Config 1: State description
- Config 2: State description

### Code State
Describe the state of the code after the change.

#### Architecture
- How the system is now structured
- Key components and their relationships

#### Dependencies
- What the system now depends on
- Versions of dependencies

#### Patterns
- Design patterns now used
- Coding patterns now used

### Data State
Describe the state of the data after the change.

#### Database Schema
- Tables and their structure
- Relationships between tables

#### Data Volume
- Amount of data
- Growth rate

#### Data Quality
- Data integrity
- Data consistency

## Impact Analysis

### Direct Impacts

#### Module 1
- **Impact**: Description
- **Risk Level**: Low/Medium/High
- **Mitigation**: How to reduce risk
- **Testing**: How to verify

#### Module 2
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

#### System 2
- **Impact**: Description
- **Risk Level**: Low/Medium/High
- **Mitigation**: How to reduce risk
- **Monitoring**: How to monitor

### Performance Impact

#### Latency
- **Before**: Xms
- **After**: Yms
- **Change**: +/- Zms

#### Throughput
- **Before**: X requests/second
- **After**: Y requests/second
- **Change**: +/- Z requests/second

#### Resource Usage
- **CPU**: Before → After
- **Memory**: Before → After
- **Storage**: Before → After

### Security Impact

#### Positive Impacts
- Impact 1: Description
- Impact 2: Description

#### Negative Impacts
- Impact 1: Description
- Mitigation: How to address

#### New Attack Surfaces
- Surface 1: Description
- Protection: How it's protected

### User Impact

#### Positive Impacts
- Impact 1: Description
- Impact 2: Description

#### Negative Impacts
- Impact 1: Description
- Mitigation: How to address

#### Migration Required
- Yes/No
- Steps: What users need to do

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

3. **Alternative 3**
   - Pros: List
   - Cons: List
   - Why not: Reason

**Rationale:**
Why was this decision made?

**Consequences:**
What are the implications of this decision?

**Review Date:**
When should this decision be reviewed?

---

### Decision 2: [Decision Title]

**Context:**
What was the situation that required a decision?

**Decision:**
What was decided?

**Alternatives Considered:**

1. **Alternative 1**
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
- **Overall**: 95%
- **Module 1**: 98%
- **Module 2**: 92%

#### Test Results
```
Test Suites: X passed, Y total
Tests:       A passed, B total
Snapshots:   C total
Time:        D.EFGs
```

#### New Tests Added
- Test 1: Description
- Test 2: Description

#### Tests Modified
- Test 1: Description of changes
- Test 2: Description of changes

### Integration Tests

#### Test Scenarios
1. **Scenario 1**: Description
   - Setup: What was prepared
   - Actions: What was done
   - Result: What happened

2. **Scenario 2**: Description
   - Setup: What was prepared
   - Actions: What was done
   - Result: What happened

#### API Tests
- Endpoint 1: ✅ Passed
- Endpoint 2: ✅ Passed
- Endpoint 3: ✅ Passed

### Security Tests

#### Vulnerability Scanning
- Dependencies: ✅ No known vulnerabilities
- Code analysis: ✅ No issues found
- Container scanning: ✅ No issues found

#### Penetration Testing
- SQL injection: ✅ Protected
- XSS attacks: ✅ Protected
- CSRF attacks: ✅ Protected
- Authentication: ✅ Secure

### Performance Tests

#### Load Testing
- **Concurrent Users**: 100
- **Duration**: 30 minutes
- **Average Response Time**: 150ms
- **95th Percentile**: 250ms
- **99th Percentile**: 400ms

#### Stress Testing
- **Concurrent Users**: 500
- **Duration**: 15 minutes
- **Breaking Point**: 5000 users
- **Recovery Time**: 30 seconds

### Manual Testing

#### Test Cases Executed
1. **Test Case 1**: Description
   - Steps: What was done
   - Expected: What should happen
   - Actual: What happened
   - Result: ✅ Pass / ❌ Fail

2. **Test Case 2**: Description
   - Steps: What was done
   - Expected: What should happen
   - Actual: What happened
   - Result: ✅ Pass / ❌ Fail

#### Browser Testing
- Chrome: ✅ Passed
- Firefox: ✅ Passed
- Safari: ✅ Passed
- Edge: ✅ Passed

#### Mobile Testing
- iOS Safari: ✅ Passed
- Android Chrome: ✅ Passed

## Rollback Plan

### Immediate Rollback (Critical Issues)

#### Step 1: Disable Feature Flag
```bash
# Set feature flag to false
FEATURE_[NAME]_ENABLED=false
```

#### Step 2: Revert Database Migration
```bash
# Run rollback migration
npm run migrate:rollback -- --steps=1
```

#### Step 3: Deploy Previous Version
```bash
# Deploy last known good version
git checkout v1.2.3
npm run deploy
```

### Gradual Rollback (Non-Critical Issues)

#### Step 1: Reduce Feature Flag Percentage
```bash
# Reduce to 10% of users
FEATURE_[NAME]_ROLLOUT_PERCENTAGE=10
```

#### Step 2: Monitor for Issues
- Watch error rates
- Monitor performance
- Check user feedback

#### Step 3: Disable if Problems Persist
```bash
# Disable feature
FEATURE_[NAME]_ENABLED=false
```

### Data Recovery

#### Session Data
- **Impact**: Sessions will be invalidated
- **Recovery**: Users will need to re-login
- **Communication**: Notify users

#### User Data
- **Impact**: No data loss expected
- **Recovery**: N/A
- **Backup**: Available if needed

#### Configuration
- **Impact**: Configuration will revert
- **Recovery**: Re-apply configuration
- **Backup**: Configuration backups available

### Communication Plan

#### Internal Team
- **Channel**: Slack #engineering
- **Message**: Description of rollback
- **Timeline**: When it will happen

#### External Users
- **Channel**: Email notification
- **Message**: Description of impact
- **Timeline**: When it will happen

#### Stakeholders
- **Channel**: Status page update
- **Message**: Description of issue
- **Timeline**: When it will be resolved

## Lessons Learned

### What Went Well

1. **Success 1**: Description
   - Why it went well
   - How to replicate

2. **Success 2**: Description
   - Why it went well
   - How to replicate

### What Could Be Improved

1. **Improvement 1**: Description
   - What happened
   - What should have happened
   - How to improve

2. **Improvement 2**: Description
   - What happened
   - What should have happened
   - How to improve

### Action Items

1. **Action 1**: Description
   - Owner: Who is responsible
   - Due date: When it should be done
   - Priority: High/Medium/Low

2. **Action 2**: Description
   - Owner: Who is responsible
   - Due date: When it should be done
   - Priority: High/Medium/Low

### Knowledge Gained

1. **Knowledge 1**: Description
   - Context: When this applies
   - Application: How to use it

2. **Knowledge 2**: Description
   - Context: When this applies
   - Application: How to use it

## Related Changes

### Dependencies
- Change 1: Description and relationship
- Change 2: Description and relationship

### Follow-ups
- Change 1: Description and timeline
- Change 2: Description and timeline

### Related Issues
- Issue 1: Description and link
- Issue 2: Description and link

## References

### Documentation
- [Doc 1]: Link and description
- [Doc 2]: Link and description

### Code
- [PR 1]: Link and description
- [Commit 1]: Link and description

### External Resources
- [Resource 1]: Link and description
- [Resource 2]: Link and description

## Changelog

### Version 1.0.0 (YYYY-MM-DD)
- Initial change record

## Sign-off

### Developer
- **Name**: [Name]
- **Date**: YYYY-MM-DD
- **Confirmation**: I confirm this change is complete and tested

### Reviewer
- **Name**: [Name]
- **Date**: YYYY-MM-DD
- **Confirmation**: I confirm this change has been reviewed

### Approver
- **Name**: [Name]
- **Date**: YYYY-MM-DD
- **Confirmation**: I confirm this change is approved for deployment
