# Playwright End-to-End Testing Setup

This configuration sets up Playwright for browser-based testing in your WordPress plugin project.

## Installation

Run the following command to install Playwright:

```
npm install --save-dev playwright
```

## Usage

- Add your tests in the `tests/playwright/` directory.
- Run tests with:

```
npx playwright test
```

## Example Test

Create a file `tests/playwright/example.spec.js`:

```js
const { test, expect } = require('@playwright/test');

test('homepage has correct title', async ({ page }) => {
  await page.goto('http://localhost:8000');
  await expect(page).toHaveTitle(/WordPress/);
});
```

## More Info

See https://playwright.dev/docs/intro for full documentation.
