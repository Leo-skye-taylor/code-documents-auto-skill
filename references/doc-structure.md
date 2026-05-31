# Document Structure Guide

This guide defines the hierarchical organization of documentation for AI consumption.

## Top-Level Structure

```
docs/
├── README.md                    # Project overview and navigation hub
├── architecture.md              # System architecture and design
├── modules/                     # Module-level documentation
├── features/                    # Feature-level documentation
├── api/                         # API documentation
├── changelog/                   # Change records
├── decisions/                   # Decision log
└── guides/                      # Usage and troubleshooting guides
```

## README.md - Project Overview

The main entry point for AI to understand the project.

### Required Sections

```markdown
# Project Name

## Overview
Brief, clear description of what this project does and why it exists.

## Architecture
High-level architecture diagram or description.

## Key Modules
List of main modules with one-line descriptions.

## Quick Start
How to get started with the project.

## Navigation
- [Architecture](architecture.md)
- [Modules](modules/)
- [Features](features/)
- [API](api/)
- [Changelog](changelog/)
- [Decisions](decisions/)
```

### AI Optimization Tips

1. **Start with "What" and "Why"**
   - AI needs context before details
   - Clear purpose statement

2. **Provide Navigation**
   - Links to detailed docs
   - Clear hierarchy

3. **Use Consistent Formatting**
   - Same heading levels
   - Predictable structure

## Architecture Documentation

### architecture.md

```markdown
# System Architecture

## Overview
High-level description of the system architecture.

## Components
List and describe major components.

## Data Flow
How data moves through the system.

## Control Flow
How control and decisions flow through the system.

## Dependencies
External dependencies and their roles.

## Design Decisions
Key architectural decisions and rationale.
```

### Component Documentation

Each major component should have:

1. **Purpose**: What it does
2. **Interfaces**: What it exposes
3. **Dependencies**: What it needs
4. **Implementation**: How it works
5. **Examples**: How to use it

## Module Documentation

### Module Directory Structure

```
modules/
├── [module-name]/
│   ├── README.md              # Module overview
│   ├── interfaces.md          # Public interfaces
│   ├── implementation.md      # Implementation details
│   ├── dependencies.md        # Dependencies
│   ├── tests.md               # Testing information
│   └── examples.md            # Usage examples
```

### README.md - Module Overview

```markdown
# [Module Name]

## Purpose
Why this module exists and what it does.

## Responsibilities
Clear list of what this module is responsible for.

## Key Concepts
Important concepts for understanding this module.

## Quick Start
Basic usage example.

## Documentation
- [Interfaces](interfaces.md)
- [Implementation](implementation.md)
- [Dependencies](dependencies.md)
- [Tests](tests.md)
- [Examples](examples.md)
```

### interfaces.md - Public Interfaces

```markdown
# [Module] Interfaces

## Public API
List of all public interfaces.

### [Interface Name]
- **Purpose**: What it does
- **Parameters**: Input parameters
- **Returns**: Return value
- **Exceptions**: Possible exceptions
- **Example**: Usage example

## Data Structures
Key data structures exposed by this module.

## Constants
Important constants and their meanings.
```

### implementation.md - Implementation Details

```markdown
# [Module] Implementation

## Architecture
Internal architecture of the module.

## Key Algorithms
Important algorithms and their rationale.

## Data Structures
Internal data structures and their purposes.

## Design Patterns
Patterns used and why.

## Performance Considerations
Performance characteristics and optimizations.

## Known Limitations
Current limitations and workarounds.
```

## Feature Documentation

### Feature Directory Structure

```
features/
├── [feature-name]/
│   ├── README.md              # Feature overview
│   ├── requirements.md        # Requirements and specifications
│   ├── design.md              # Design decisions
│   ├── implementation.md      # Implementation details
│   ├── testing.md             # Testing strategy
│   └── user-guide.md          # User documentation
```

### README.md - Feature Overview

```markdown
# [Feature Name]

## Overview
What this feature does and why it exists.

## User Stories
Who uses this feature and how.

## Key Functionality
Main capabilities of this feature.

## Quick Start
How to use this feature.

## Documentation
- [Requirements](requirements.md)
- [Design](design.md)
- [Implementation](implementation.md)
- [Testing](testing.md)
- [User Guide](user-guide.md)
```

### requirements.md - Requirements

```markdown
# [Feature] Requirements

## Business Requirements
Why this feature is needed.

## Functional Requirements
What the feature must do.

## Non-Functional Requirements
Performance, security, scalability requirements.

## Constraints
Technical or business constraints.

## Acceptance Criteria
How to verify the feature works correctly.

## Dependencies
Other features or systems this depends on.
```

## API Documentation

### API Directory Structure

```
api/
├── [api-name]/
│   ├── README.md              # API overview
│   ├── endpoints.md           # Endpoint documentation
│   ├── schemas.md             # Data schemas
│   ├── authentication.md      # Authentication
│   ├── error-handling.md      # Error handling
│   └── examples.md            # Usage examples
```

### endpoints.md - Endpoint Documentation

```markdown
# [API] Endpoints

## [Endpoint Name]

### Description
What this endpoint does.

### Request
- **Method**: GET/POST/PUT/DELETE
- **URL**: /api/endpoint
- **Headers**: Required headers
- **Body**: Request body schema

### Response
- **Status Codes**: Possible status codes
- **Body**: Response body schema
- **Headers**: Response headers

### Example
```bash
curl -X POST /api/endpoint \
  -H "Content-Type: application/json" \
  -d '{"key": "value"}'
```

### Errors
Possible errors and how to handle them.
```

## Change Documentation

### changelog/ - Change Records

Each change gets its own file:

```
changelog/
├── 2024-01-15-feature-login.md
├── 2024-01-16-bugfix-auth.md
└── 2024-01-17-refactor-db.md
```

### Change Record Format

```markdown
---
date: 2024-01-15
type: feature
modules: [auth, user]
impact: medium
---

# User Login Feature

## Summary
Implemented user login functionality with email/password.

## Motivation
Users need to authenticate to access protected resources.

## Changes
- [x] Login API endpoint
- [x] Authentication middleware
- [x] Session management
- [x] Documentation updates

## Impact Analysis
- Direct impacts: auth module, user module
- Indirect impacts: all protected endpoints
- Risk assessment: Medium (new authentication flow)

## Decision Log
- Decision: Use JWT for session management
- Alternatives: Server-side sessions, OAuth
- Rationale: Stateless, scalable, works with microservices

## Testing
- Unit tests: 95% coverage
- Integration tests: All endpoints tested
- Security tests: Penetration testing passed

## Rollback Plan
1. Remove login endpoint
2. Revert authentication middleware
3. Clear all sessions
```

### decisions/ - Decision Log

```
decisions/
├── 2024-01-10-database-choice.md
├── 2024-01-12-auth-strategy.md
└── 2024-01-15-api-design.md
```

### Decision Record Format

```markdown
---
date: 2024-01-10
status: accepted
modules: [database, infrastructure]
---

# Database Choice: PostgreSQL

## Status
Accepted

## Context
We need a relational database for the application.

## Decision
Use PostgreSQL as the primary database.

## Consequences
### Positive
- Strong ACID compliance
- Rich feature set
- Good performance

### Negative
- Requires more resources than SQLite
- Learning curve for team

## Alternatives Considered
1. **MySQL**: Good but less feature-rich
2. **SQLite**: Too limited for production
3. **MongoDB**: Not suitable for relational data

## Rationale
PostgreSQL best fits our requirements for data integrity, performance, and scalability.
```

## AI-Specific Optimizations

### 1. Consistent Naming

- Use lowercase with hyphens for files
- Use consistent heading levels
- Use predictable section names

### 2. Clear Relationships

- Explicit dependency documentation
- Cross-references between docs
- Impact chains documented

### 3. Structured Metadata

- YAML frontmatter for all docs
- Consistent field names
- Machine-parseable format

### 4. Actionable Content

- Clear instructions
- Examples and usage
- Troubleshooting guides

### 5. Navigation Aids

- Table of contents
- Related documents links
- Index files for directories

## Validation Checklist

### For Each Document

- [ ] Clear purpose statement
- [ ] Consistent formatting
- [ ] Proper heading hierarchy
- [ ] YAML frontmatter
- [ ] Cross-references
- [ ] Examples where needed
- [ ] AI-readable structure

### For Document Sets

- [ ] Complete coverage
- [ ] No orphaned documents
- [ ] Consistent naming
- [ ] Proper linking
- [ ] Regular updates

## Maintenance

### Regular Reviews

1. **Weekly**: Check for stale docs
2. **Monthly**: Review documentation coverage
3. **Quarterly**: Update structure if needed

### Update Triggers

- Code changes
- Feature additions
- Bug fixes
- Architecture changes
- Dependency updates

### Quality Metrics

- Documentation coverage
- Freshness (days since update)
- Completeness (required sections)
- Accuracy (verified against code)
