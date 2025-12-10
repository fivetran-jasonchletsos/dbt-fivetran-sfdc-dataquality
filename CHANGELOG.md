# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2023-10-20

### Added
- Initial project structure with multi-layer architecture (src, stg, int, mart)
- Multi-database configuration (SANDBOX → STG → FCT)
- Source definitions for Salesforce tables with freshness checks
- Staging models with column renaming and type casting
- Intermediate models for enhanced opportunity data and pipeline snapshots
- Mart models for sales performance analytics
- Comprehensive data quality testing with dbt_expectations
- GitHub Actions CI/CD workflow
- Documentation and setup guides
- Makefile for build automation

### Changed
- N/A (initial release)

### Removed
- N/A (initial release)