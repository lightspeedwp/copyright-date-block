#!/bin/bash
#
# Test script for copyright-date-block
#
# This script runs all tests for the plugin.
#

set -euo pipefail

echo "Starting test process..."

# Run JS/TS tests
echo "Running JavaScript tests..."
npm run test-unit

# Run PHP tests if phpunit is available
if command -v phpunit &> /dev/null; then
  echo "Running PHP tests..."
  phpunit
fi

# Run E2E tests if Playwright is installed
if [ -d "node_modules/@playwright" ]; then
  echo "Running E2E tests..."
  npx playwright test
fi

echo "All tests completed!"
