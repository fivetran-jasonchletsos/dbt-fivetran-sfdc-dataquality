# Contributing to dbt-fivetran-sfdc-dataquality

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## Development Workflow

### Branch Naming Convention

- `feature/[feature-name]` - For new features or enhancements
- `fix/[issue-description]` - For bug fixes
- `docs/[description]` - For documentation changes
- `test/[description]` - For adding or modifying tests
- `refactor/[description]` - For code refactoring without changing functionality

### Pull Request Process

1. Create a new branch following the naming convention
2. Make your changes, following the coding standards
3. Add appropriate tests for your changes
4. Update documentation as necessary
5. Submit a pull request with a clear description of the changes
6. Ensure all CI checks pass

### Pull Request Requirements

- Clear and descriptive title
- Detailed description of changes
- Reference to any related issues
- All tests passing
- Documentation updated
- Code follows project standards

## Coding Standards

### SQL Style Guide

- Use lowercase for SQL keywords
- Use snake_case for column and model names
- Include column comments in YAML files
- Align SQL statements for readability
- Use CTEs for complex queries
- Limit line length to 80 characters when possible

### YAML Style Guide

- Use 2 spaces for indentation
- Include descriptions for all models and columns
- Add tests for all primary and foreign keys
- Document sources with freshness checks

### Testing Requirements

- Add dbt tests for all new models
- Include at minimum:
  - Primary key tests (unique + not null)
  - Foreign key relationship tests
  - Business logic tests
- Consider using dbt_expectations for statistical tests

## Release Process

1. Merge approved PRs into main branch
2. Tag releases using semantic versioning (vX.Y.Z)
3. Update CHANGELOG.md with release notes
4. Create a GitHub release with documentation

## Getting Help

If you have questions or need assistance:
1. Check existing issues and documentation
2. Create a new issue with the "question" label
3. Be specific about your question and include relevant details

Thank you for contributing!