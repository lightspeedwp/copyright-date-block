# Copyright Date Block

[![CI Status](https://github.com/lightspeedwp/copyright-date-block/workflows/CI/badge.svg)](https://github.com/lightspeedwp/copyright-date-block/actions)
[![License: GPL v2+](https://img.shields.io/badge/License-GPL%20v2%2B-blue.svg)](https://www.gnu.org/licenses/gpl-2.0)

A WordPress Gutenberg block that displays your site's copyright date with automatic year updates.

## Features

- 📅 **Automatic Updates**: Current year updates automatically without manual intervention
- 🎯 **Date Ranges**: Optionally display starting year with current year (e.g., "2020–2024")
- 🎨 **Customizable**: Integrate with themes and customize appearance
- 🔧 **Developer Friendly**: Includes utility functions and REST API endpoints
- ✅ **Tested**: Comprehensive test coverage with Jest
- 🚀 **CI/CD Ready**: Automated testing, building, and releases

## Installation

### From WordPress Admin

1. Download the latest release from [GitHub Releases](https://github.com/lightspeedwp/copyright-date-block/releases)
2. Go to WordPress Admin → Plugins → Add New → Upload Plugin
3. Choose the downloaded ZIP file and click "Install Now"
4. Activate the plugin

### Development Installation

```bash
git clone https://github.com/lightspeedwp/copyright-date-block.git
cd copyright-date-block
npm install
npm run build
```

## Usage

### Basic Usage

1. Open any post or page in the WordPress block editor
2. Add a new block by clicking the "+" button
3. Search for "Copyright Date" or find it in the "Widgets" category
4. Insert the block to display the current year: `© 2024`

### Advanced Usage

Configure the block to show date ranges:

1. Select the Copyright Date block
2. In the Settings panel, toggle "Show Starting Year"
3. Enter your starting year (e.g., 2020)
4. The block will display: `© 2020–2024`

For advanced integration patterns, see [`examples/advanced-usage.php`](examples/advanced-usage.php) and [`USAGE.md`](USAGE.md).

## Development

### Requirements

- Node.js 20+
- npm 10+
- WordPress 6.7+  
- PHP 8.0+
- Composer 2.0+

### Quick Setup

```bash
# 1. Clone and install dependencies
git clone https://github.com/lightspeedwp/copyright-date-block.git
cd copyright-date-block
npm install
composer install

# 2. Start WordPress development environment
npm run env:start

# 3. Build assets
npm run build

# 4. Start development with hot reload
npm run start
```

### Full Development Workflow

```bash
# Start WordPress environment (first time)
npm run env:start

# Install Playwright browsers for E2E tests (optional)
npx playwright install

# Development commands
npm run start         # Hot reload development
npm run build         # Production build
npm test             # All tests
npm run lint         # All linting
npm run lint:fix     # Auto-fix issues

# WordPress environment management  
npm run env:start    # Start WordPress
npm run env:stop     # Stop WordPress
npm run env:clean    # Clean data
npm run env:destroy  # Destroy environment

# Create distribution
npm run plugin-zip   # Create installable ZIP
```

### Available Scripts

| Script | Description |
|--------|-------------|
| `npm run start` | Start development server with hot reload |
| `npm run build` | Build production assets |
| `npm test` | Run all tests (unit, E2E, PHP) |
| `npm run test:unit` | Run JavaScript unit tests (Jest) |
| `npm run test:e2e` | Run end-to-end tests (Playwright) |
| `npm run test:php` | Run PHP unit tests (PHPUnit) |
| `npm run test:coverage` | Generate code coverage reports |
| `npm run lint` | Run all linting (JS, CSS, PHP, Markdown) |
| `npm run lint:js` | Run ESLint on JavaScript files |
| `npm run lint:css` | Run Stylelint on CSS/SCSS files |
| `npm run lint:php` | Run PHPCS on PHP files |
| `npm run lint:md` | Run markdownlint on Markdown files |
| `npm run lint:fix` | Fix linting issues automatically |
| `npm run format` | Format code with Prettier |
| `npm run plugin-zip` | Create distributable plugin ZIP |
| `npm run env:start` | Start WordPress development environment |
| `npm run env:stop` | Stop WordPress development environment |
| `npm run env:test` | Run tests in WordPress environment |

### Testing

This plugin includes a comprehensive test suite with multiple testing frameworks:

```bash
# Run all tests
npm test

# Run specific test types
npm run test:unit      # JavaScript unit tests (Jest)
npm run test:e2e       # End-to-end tests (Playwright)  
npm run test:php       # PHP unit tests (PHPUnit)
npm run test:coverage  # Generate coverage reports
```

#### Test Coverage

- **JavaScript Unit Tests (Jest)**: Utility functions, components, date logic
- **End-to-End Tests (Playwright)**: Full browser workflows, block functionality
- **PHP Unit Tests (PHPUnit)**: Server-side logic, WordPress integration
- **Integration Tests**: Component interactions and API endpoints

#### WordPress Test Environment

Tests run in a real WordPress environment using `@wordpress/env`:

```bash
# Start WordPress test environment
npm run env:start

# Run tests against WordPress instance
npm run env:test

# Stop environment
npm run env:stop
```

### Code Quality

The project uses several tools to maintain code quality:

- **ESLint**: JavaScript linting with WordPress coding standards
- **Prettier**: Code formatting
- **Husky**: Pre-commit hooks
- **lint-staged**: Lint only staged files

Pre-commit hooks automatically run linting and formatting to ensure consistent code quality.

## CI/CD Workflows

### Continuous Integration

The `ci.yml` workflow runs on every push and pull request:

1. **Lint**: Checks code style and standards
2. **Test**: Runs unit test suite
3. **Build**: Compiles production assets
4. **Package**: Creates plugin ZIP file

### Release Automation

The `release-on-tag.yml` workflow creates GitHub releases:

1. Triggered when tags matching `v*` are pushed
2. Runs full CI pipeline (lint, test, build)
3. Creates plugin ZIP
4. Publishes GitHub release with download assets

To create a release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

## File Structure

```txt
copyright-date-block/
├── .github/              # GitHub configuration
│   ├── workflows/       # CI/CD workflows (WPCS, tests, build, release)
│   └── instructions/    # Development guidelines and standards
├── .husky/              # Git hooks for pre-commit quality checks
├── bin/                 # Build and development scripts
├── build/               # Compiled assets (webpack output - auto-generated)
├── coverage/            # Code coverage reports (auto-generated)
├── examples/            # Advanced usage examples and integrations
├── playwright-reports/  # E2E test reports and screenshots (auto-generated)
├── src/                 # Source code
│   ├── copyright-block/ # Block implementation
│   └── scss/           # Stylesheet sources
├── test-results/        # Test output files (auto-generated)
├── tests/              # Test suites
│   ├── bootstrap.php   # Test bootstrap and WordPress mocks
│   ├── e2e/           # End-to-end tests (Playwright)
│   ├── integration/    # Integration tests
│   ├── php/           # PHP unit tests (PHPUnit)
│   └── unit/          # JavaScript unit tests (Jest)
├── vendor/             # Composer dependencies (auto-generated)
├── composer.json       # PHP dependencies and scripts (PHPCS, PHPStan)
├── package.json        # Node.js dependencies and build scripts
├── phpcs.xml           # PHP Code Sniffer configuration
├── phpstan.neon        # PHPStan static analysis configuration
├── playwright.config.js # Playwright E2E test configuration
├── webpack.config.js   # Build configuration
└── copyright-date-block.php # Main plugin file
```

### Key Directories

- **`src/`**: Source code for blocks, styles, and JavaScript
- **`tests/`**: Comprehensive test suite (unit, integration, E2E, PHP)
- **`build/`**: Production-ready compiled assets
- **`bin/`**: Development and build scripts
- **Coverage & Reports**: Auto-generated test outputs and coverage data

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make your changes
4. Run tests: `npm test`
5. Run linting: `npm run lint:fix`
6. Commit changes: `git commit -m 'Add new feature'`
7. Push branch: `git push origin feature/new-feature`
8. Create a pull request

### Coding Standards

- **JavaScript**: Follow WordPress JavaScript coding standards (ESLint)
- **PHP**: Follow WordPress PHP coding standards (PHPCS)
- **CSS**: Follow WordPress CSS coding standards 
- Write tests for new utility functions
- Update documentation for new features
- Ensure all CI checks pass

#### PHP Coding Standards

This project uses PHP_CodeSniffer with WordPress coding standards:

```bash
# Run PHP linting
npm run lint:php

# Fix PHP coding standards issues automatically
npm run lint:php:fix
```

The following standards are enforced:

- WordPress Core coding standards
- WordPress Extra coding standards  
- WordPress Documentation standards
- PHP Compatibility checks (PHP 7.4+)

## License

This project is licensed under the GPL v2.0 or later - see the [LICENSE](LICENSE) file for details.

## Support

- **Documentation**: [USAGE.md](USAGE.md)
- **Issues**: [GitHub Issues](https://github.com/lightspeedwp/copyright-date-block/issues)
- **Discussions**: [GitHub Discussions](https://github.com/lightspeedwp/copyright-date-block/discussions)

## Changelog

See [GitHub Releases](https://github.com/lightspeedwp/copyright-date-block/releases) for version history and changelog.
