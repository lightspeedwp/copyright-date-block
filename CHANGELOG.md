# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Placeholder for future changes.

## [0.1.0] - 2025-10-09

### Added

- Implemented WordPress Copyright Date Block using create-block scaffolding. [#1](https://github.com/lightspeedwp/copyright-date-block/pull/1)
- Added GitHub CLI projects management script with comprehensive authentication flow. [#3](https://github.com/lightspeedwp/copyright-date-block/pull/3)
- Added Playwright for end-to-end testing with multi-browser support (Chromium, Firefox, WebKit)
- Added comprehensive E2E test suite covering block editor integration and frontend rendering
- Added Playwright configuration with automatic WordPress environment setup
- Enhanced date utility functions with improved validation and error handling
- Expanded unit test coverage for date utilities (10 test cases)

### Updated

- Replaced Husky pre-commit hooks with Playwright-based testing workflow
- Migrated from lint-staged to direct Playwright test execution
- Updated development scripts to include E2E testing commands (`test:e2e`, `test:e2e:ui`, `test:e2e:headed`)
- Improved code formatting and linting compliance across all JavaScript files
- Enhanced `.gitignore` to exclude Playwright test artifacts and reports

### Removed

- Removed Husky dependency and pre-commit hook configuration
- Removed lint-staged dependency and configuration
- Cleaned up legacy `.husky/` directory and related files

[Unreleased]: https://github.com/lightspeedwp/copyright-date-block/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/lightspeedwp/copyright-date-block/releases/tag/v0.1.0
