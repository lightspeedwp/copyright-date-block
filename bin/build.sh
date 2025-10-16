#!/bin/bash
#
# Build script for copyright-date-block
#
# This script builds the plugin assets for production.
#

set -euo pipefail

echo "Starting build process..."

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm ci
fi

# Run the build script
echo "Building assets..."
npm run build

echo "Build completed successfully!"
