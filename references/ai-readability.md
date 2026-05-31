# AI Readability Standards

This guide defines standards for creating documentation that is easily readable and parseable by AI systems.

## Core Principles

### 1. Explicit Over Implicit

AI cannot infer context that humans take for granted. Always be explicit.

**Bad:**
```markdown
The module handles user stuff.
```

**Good:**
```markdown
The user module handles user registration, authentication, profile management, and account deletion.
```

### 2. Structured Over Free-Form

AI works better with predictable structure than creative prose.

**Bad:**
```markdown
This feature is pretty cool. It lets users do things with their accounts. You know, like login and stuff.
```

**Good:**
```markdown
## User Authentication Feature

### Purpose
Allow users to securely access their accounts.

### Capabilities
- User login with email/password
- Password reset via email
- Session management
- Account lockout after failed attempts
```

### 3. Complete Over Concise

AI needs all information; it cannot ask clarifying questions.

**Bad:**
```markdown
Uses JWT.
```

**Good:**
```markdown
## Authentication Method

Uses JSON Web Tokens (JWT) for session management.

### Token Structure
- Header: Algorithm and token type
- Payload: User ID, expiration, roles
- Signature: HMAC-SHA256 signature

### Token Lifetime
- Access token: 15 minutes
- Refresh token: 7 days

### Storage
- Access token: Memory (not persisted)
- Refresh token: HttpOnly cookie
```

## Document Structure Standards

### YAML Frontmatter

Every document must have YAML frontmatter with standard fields:

```yaml
---
title: "Document Title"
type: module|feature|api|guide|changelog|decision
version: "1.0"
status: draft|active|deprecated
created: 2024-01-15
updated: 2024-01-20
author: "Author Name"
modules: [module1, module2]
tags: [tag1, tag2]
---
```

### Heading Hierarchy

Use consistent heading levels:

```markdown
# H1: Document Title (one per document)

## H2: Major Sections

### H3: Subsections

#### H4: Detailed Points (use sparingly)
```

**Rules:**
- Never skip heading levels
- Use H1 only once per document
- Keep heading hierarchy logical
- Use parallel structure across documents

### Section Order

Follow predictable section order:

```markdown
## Overview
## Purpose
## Requirements
## Design
## Implementation
## Usage
## Examples
## Troubleshooting
## References
```

## Content Standards

### Descriptions

**Always answer:**
- What is it?
- Why does it exist?
- How does it work?
- When should it be used?
- What are the limitations?

**Example:**
```markdown
## Rate Limiting

### What
A mechanism to limit the number of API requests per client.

### Why
Prevents abuse and ensures fair usage of resources.

### How
Uses token bucket algorithm with Redis backend.

### When
Apply to all public API endpoints.

### Limitations
- Does not prevent distributed attacks
- Requires Redis for distributed systems
```

### Code References

Always provide complete context:

**Bad:**
```markdown
See the function.
```

**Good:**
```markdown
The `validateUser()` function in `src/auth/validator.ts` checks:
1. Email format validity
2. Password strength requirements
3. Account existence in database
4. Account status (active/suspended)

### Function Signature
```typescript
async function validateUser(email: string, password: string): Promise<User | null>
```

### Return Value
- Returns `User` object if validation succeeds
- Returns `null` if validation fails
- Throws `ValidationError` for invalid input
```

### Dependencies

Document all dependencies explicitly:

```markdown
## Dependencies

### Direct Dependencies
- **express**: Web framework (v4.18+)
- **jsonwebtoken**: JWT handling (v9.0+)
- **bcrypt**: Password hashing (v5.1+)

### Development Dependencies
- **jest**: Testing framework (v29+)
- **typescript**: Type checking (v5.0+)

### System Dependencies
- **Node.js**: Runtime (v18+)
- **Redis**: Session storage (v7+)

### Internal Dependencies
- **database module**: User storage
- **email module**: Password reset emails
- **logger module**: Request logging
```

### Interfaces

Document all public interfaces completely:

```markdown
## Public Interface: UserService

### Methods

#### createUser(data: CreateUserDto): Promise<User>

Creates a new user account.

**Parameters:**
- `data.email` (string): User email address
- `data.password` (string): User password (min 8 chars)
- `data.name` (string): User display name

**Returns:**
- `Promise<User>`: Created user object

**Throws:**
- `ValidationError`: Invalid input data
- `ConflictError`: Email already exists

**Example:**
```typescript
const user = await userService.createUser({
  email: 'user@example.com',
  password: 'securePassword123',
  name: 'John Doe'
});
```

**Side Effects:**
- Sends welcome email
- Creates user in database
- Logs creation event
```

## Formatting Standards

### Lists

Use consistent list formatting:

```markdown
## Features

- Feature 1: Description
- Feature 2: Description
- Feature 3: Description

## Steps

1. First step
2. Second step
3. Third step

## Requirements

- [ ] Requirement 1
- [ ] Requirement 2
- [x] Completed requirement
```

### Tables

Use tables for structured data:

```markdown
## API Endpoints

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | /users | List users | Yes |
| POST | /users | Create user | No |
| GET | /users/:id | Get user | Yes |
| PUT | /users/:id | Update user | Yes |
| DELETE | /users/:id | Delete user | Yes |
```

### Code Blocks

Always specify language:

````markdown
```typescript
// TypeScript code
interface User {
  id: string;
  email: string;
  name: string;
}
```

```bash
# Shell commands
npm install package-name
```

```json
{
  "key": "value"
}
```
````

### Links

Use descriptive link text:

**Bad:**
```markdown
Click [here](link) for more info.
```

**Good:**
```markdown
See the [Authentication Guide](docs/auth.md) for detailed instructions.
```

## AI-Specific Patterns

### 1. Explicit Relationships

Always document how things connect:

```markdown
## Module Relationships

### User Module
- **Depends on**: Database, Email, Logger
- **Depended by**: Auth, Profile, Admin
- **Communicates with**: Auth (login), Profile (updates)
```

### 2. Decision Documentation

Record all decisions with context:

```markdown
## Decision: Use PostgreSQL

### Context
We need a relational database for user data.

### Decision
Use PostgreSQL as primary database.

### Consequences
- Positive: ACID compliance, rich features
- Negative: Higher resource usage

### Alternatives Considered
1. MySQL: Less feature-rich
2. SQLite: Too limited for production
```

### 3. Impact Analysis

Document all impacts explicitly:

```markdown
## Impact Analysis: User Login Feature

### Direct Impacts
- Auth module: New login endpoint
- User module: Password validation
- Database: User table queries

### Indirect Impacts
- All protected endpoints: Now require auth
- Logging: New login events
- Monitoring: New metrics

### Risk Assessment
- **Level**: Medium
- **Mitigation**: Gradual rollout, monitoring
```

### 4. Change Tracking

Record all changes with context:

```markdown
## Change: Add Password Reset

### What Changed
- New password reset endpoint
- Email template for reset link
- Token generation logic

### Why Changed
Users requested ability to reset forgotten passwords.

### How Changed
- Implemented token-based reset flow
- Added email integration
- Created secure token generation

### Impact
- User experience: Improved
- Security: New attack surface (mitigated)
- Support: Reduced password-related tickets
```

## Validation Checklist

### For Each Document

- [ ] YAML frontmatter present
- [ ] Clear title and purpose
- [ ] Consistent heading hierarchy
- [ ] All sections complete
- [ ] Code examples provided
- [ ] Dependencies documented
- [ ] Interfaces fully specified
- [ ] Error handling documented
- [ ] Examples included

### For AI Readability

- [ ] Explicit over implicit
- [ ] Structured format
- [ ] Complete information
- [ ] Consistent naming
- [ ] Clear relationships
- [ ] Decision context
- [ ] Impact analysis
- [ ] Change tracking

## Common Mistakes

### 1. Assuming Context

**Bad:**
```markdown
The module handles authentication.
```

**Good:**
```markdown
The authentication module handles user login, logout, session management, and password reset functionality.
```

### 2. Incomplete Documentation

**Bad:**
```markdown
Function: validateUser
```

**Good:**
```markdown
## validateUser Function

### Purpose
Validates user credentials for login.

### Signature
```typescript
async function validateUser(email: string, password: string): Promise<User | null>
```

### Parameters
- `email`: User's email address
- `password`: User's password

### Returns
- `User` if valid
- `null` if invalid

### Throws
- `ValidationError` for malformed input
```

### 3. Missing Relationships

**Bad:**
```markdown
Uses database.
```

**Good:**
```markdown
## Database Dependencies

### Direct Dependencies
- **PostgreSQL**: Primary data storage
- **Redis**: Session cache

### Internal Dependencies
- **database/connection.ts**: Connection management
- **database/migrations/**: Schema migrations

### External Dependencies
- **pg**: PostgreSQL client library
- **ioredis**: Redis client library
```

## Tools and Automation

### Validation Scripts

Use automated validation to ensure standards:

```bash
# Check for required frontmatter
python scripts/validate-frontmatter.py docs/

# Check heading hierarchy
python scripts/validate-headings.py docs/

# Check for broken links
python scripts/validate-links.py docs/
```

### Documentation Generation

Automate where possible:

```bash
# Generate API docs from code
npm run docs:api

# Generate module docs
npm run docs:modules

# Validate all docs
npm run docs:validate
```

## Continuous Improvement

### Feedback Loop

1. **Collect**: Gather feedback on documentation quality
2. **Analyze**: Identify common issues
3. **Improve**: Update standards and templates
4. **Validate**: Ensure improvements work

### Metrics to Track

- Documentation coverage
- Freshness (days since update)
- Completeness (required sections)
- Accuracy (verified against code)
- AI parse success rate

### Regular Reviews

- **Weekly**: Check for stale docs
- **Monthly**: Review coverage and quality
- **Quarterly**: Update standards if needed
