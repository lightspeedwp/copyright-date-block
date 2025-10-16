#!/usr/bin/env node
/**
 * Update version numbers across the plugin.
 */

const fs = require('fs');
const path = require('path');

// Get new version from command line argument
const newVersion = process.argv[2];

if (!newVersion) {
    console.error('Error: No version provided');
    console.log('Usage: node update-version.js x.y.z');
    process.exit(1);
}

// Validate version format (x.y.z)
if (!/^\d+\.\d+\.\d+(?:-\w+)?$/.test(newVersion)) {
    console.error('Error: Invalid version format. Expected format is x.y.z or x.y.z-beta');
    process.exit(1);
}

// Files to update
const filesToUpdate = [
    {
        path: path.join(__dirname, '..', 'package.json'),
        regex: /("version":\s*")([^"]+)(")/,
        replacement: `$1${newVersion}$3`
    },
    {
        path: path.join(__dirname, '..', 'copyright-date-block.php'),
        regex: /(Version:\s*)([^\r\n]+)/,
        replacement: `$1${newVersion}`
    },
    {
        path: path.join(__dirname, '..', 'readme.txt'),
        regex: /(Stable tag:\s*)([^\r\n]+)/,
        replacement: `$1${newVersion}`
    },
    {
        path: path.join(__dirname, '..', 'src', 'copyright-block', 'block.json'),
        regex: /("version":\s*")([^"]+)(")/,
        replacement: `$1${newVersion}$3`
    }
];

// Update version in each file
filesToUpdate.forEach(file => {
    try {
        if (!fs.existsSync(file.path)) {
            console.warn(`Warning: File not found ${file.path}`);
            return;
        }

        const content = fs.readFileSync(file.path, 'utf8');
        const updatedContent = content.replace(file.regex, file.replacement);
        
        if (content !== updatedContent) {
            fs.writeFileSync(file.path, updatedContent);
            console.log(`✅ Updated version in ${path.relative(path.join(__dirname, '..'), file.path)}`);
        } else {
            console.log(`⚠️ No changes in ${path.relative(path.join(__dirname, '..'), file.path)}`);
        }
    } catch (error) {
        console.error(`❌ Error updating ${file.path}: ${error.message}`);
    }
});

// Also update VERSION file
try {
    fs.writeFileSync(path.join(__dirname, '..', 'VERSION'), newVersion);
    console.log('✅ Updated VERSION file');
} catch (error) {
    console.error(`❌ Error updating VERSION file: ${error.message}`);
}

console.log(`\n🚀 Version updated to ${newVersion}`);