# Copyright Date Block Plugin Development Guide

**Last Updated:** 2025-10-16 · **Version:** v0.1.0

This guide provides step-by-step instructions for setting up, developing, testing, and releasing the `copyright-date-block` WordPress plugin.

---

## Prerequisites

- [Node.js](https://nodejs.org/) (v20 or later)
- [npm](https://www.npmjs.com/) (v10 or later)
- [WordPress](https://wordpress.org/) (6.7+ recommended)
- [PHP](https://www.php.net/) (7.4 or later)
- [Composer](https://getcomposer.org/) (for PHP dependencies)
- [Docker](https://www.docker.com/) (for @wordpress/env)

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/lightspeedwp/copyright-date-block.git
cd copyright-date-block
```

### 2. Install dependencies

```bash
npm install
composer install
```

### 3. Setup Husky git hooks

```bash
npm run prepare
```

---

## Development Workflow

### Building Assets

- Start development mode with hot reloading:

```bash
npm start
```

- Build for production:

```bash
npm run build
```

### Code Quality

- Lint JavaScript:

```bash
npm run lint:js
```

- Lint CSS:

```bash
npm run lint:css
```

- Lint PHP:

```bash
npm run lint:php
```

- Run all linters:

```bash
npm run lint
```

- Fix auto-fixable issues:

```bash
npm run lint:fix
```

### Testing

- Run JavaScript tests:

```bash
npm test
```

- Run PHP tests:

```bash
composer test
```

---

## WordPress Integration

### Using @wordpress/env (Recommended)

1. Make sure Docker is installed and running
2. Start the local WordPress environment:

```bash
npm run env:start
```

1. Access your local WordPress site at `http://localhost:8888`
2. The plugin will be automatically activated

### Using Local WP or MAMP

1. Create a symbolic link from your plugin directory to the WordPress plugins folder:

```bash
# macOS/Linux
ln -s $(pwd) /path/to/wordpress/wp-content/plugins/copyright-date-block

# Windows (Command Prompt as Administrator)
mklink /D "C:\path\to\wordpress\wp-content\plugins\copyright-date-block" "C:\path\to\your\plugin\directory"
```

1. Activate the plugin in the WordPress admin

---

## Using the Block

After installation and activation:

1. Create a new post or page in WordPress
2. Click the "+" icon to add a new block
3. Search for "Copyright Date"
4. Add the block to your content
5. Configure block options in the sidebar

---

## Debugging

### JavaScript Debugging

- Check the browser console for errors
- Use `console.log()` statements in your code during development
- For React components, use the React Developer Tools browser extension

### PHP Debugging

- Enable WordPress debugging by adding to your wp-config.php:

```php
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );
```

- Check the debug.log file in the wp-content directory

---

## Git Workflow

1. Create a feature branch for your work:

    ```bash
    git checkout -b feature/your-feature-name
    ```

2. Make your changes and commit them:

    ```bash
    git add .
    git commit -m "Your descriptive commit message"
    ```

3. Push your changes and create a pull request:

    ```bash
    git push origin feature/your-feature-name
    ```

4. Reference any related issues in your pull request description

---

## Building for Release

To create a distributable plugin zip file:

```bash
npm run plugin-zip
```

This will create a production-ready ZIP file in the project root that can be installed in any WordPress site.

---

## Need Help?

- Check the repository documentation and README files
- Review the [GitHub Copilot custom instructions](./.github/custom-instructions.md)
- Use the prompt files in `.github/prompts/` for guidance

---

## Contributing and Code of Conduct

We welcome contributions! Please review our [Contributing Guidelines](https://github.com/lightspeedwp/.github/blob/master/.github/CONTRIBUTING.md) and [Code of Conduct](https://github.com/lightspeedwp/.github/blob/master/.github/CODE_OF_CONDUCT.md) before submitting pull requests or engaging with the project.

---

## License

This project is licensed under the GNU General Public License v2.0 or later - see the [LICENSE](LICENSE) file for details.

[![License: GPL v2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
