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
- PHP 7.4+

### Setup

```bash
# Install dependencies
npm install

# Start development
npm run start

# Run tests
npm test

# Lint code
npm run lint

# Fix linting issues
npm run lint:fix

# Build for production
npm run build

# Create plugin ZIP
npm run plugin-zip
```

### Available Scripts

| Script | Description |
|--------|-------------|
| `npm run start` | Start development server with hot reload |
| `npm run build` | Build production assets |
| `npm run test` | Run Jest unit tests |
| `npm run lint` | Run ESLint on JavaScript files and PHPCS on PHP files |
| `npm run lint:js` | Run ESLint on JavaScript files only |
| `npm run lint:php` | Run PHPCS on PHP files only |
| `npm run lint:fix` | Fix ESLint and PHPCS issues automatically |
| `npm run format` | Format code with Prettier |
| `npm run plugin-zip` | Create distributable plugin ZIP |

### Testing

This plugin includes comprehensive Jest unit tests for utility functions:

```bash
npm test
```

Tests cover:

- Date utility functions
- Year validation
- Copyright range formatting
- Edge cases and error handling

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
├── .github/workflows/     # CI/CD workflows
├── .husky/               # Git hooks
├── build/                # Compiled assets (generated)
├── examples/             # Advanced usage examples
├── src/                  # Source files
│   ├── utils/           # Utility functions and tests
│   ├── block.json       # Block configuration
│   ├── edit.js          # Block editor component
│   ├── save.js          # Block save function
│   ├── index.js         # Block registration
│   └── render.php       # Server-side rendering
├── USAGE.md             # Detailed usage guide
├── package.json         # Dependencies and scripts
└── copyright-date-block.php  # Main plugin file
```

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
