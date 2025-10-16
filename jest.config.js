/**
 * Jest configuration for Copyright Date Block plugin
 */

const defaultConfig = require('@wordpress/scripts/config/jest-unit.config.js');

module.exports = {
	...defaultConfig,
	
	// Test directories and patterns
	testMatch: [
		'<rootDir>/tests/unit/**/*.test.{js,jsx,ts,tsx}',
		'<rootDir>/src/**/__tests__/**/*.{js,jsx,ts,tsx}',
		'<rootDir>/src/**/*.test.{js,jsx,ts,tsx}',
	],
	
	// Coverage settings
	collectCoverage: true,
	collectCoverageFrom: [
		'src/**/*.{js,jsx,ts,tsx}',
		'!src/**/*.d.ts',
		'!src/**/index.{js,jsx,ts,tsx}',
		'!src/**/__tests__/**',
		'!build/**',
		'!node_modules/**',
	],
	
	coverageDirectory: 'coverage',
	coverageReporters: [
		'text',
		'text-summary', 
		'html',
		'lcov',
		'json',
	],
	
	// Coverage thresholds - relaxed for initial setup
	coverageThreshold: {
		global: {
			branches: 50,
			functions: 50,
			lines: 50,
			statements: 50,
		},
	},
	
	// Test environment
	testEnvironment: 'jsdom',
	
	// Setup files
	setupFilesAfterEnv: [
		'<rootDir>/tests/setup-tests.js',
	],
	
	// Module name mapping
	moduleNameMapper: {
		'^@/(.*)$': '<rootDir>/src/$1',
	},
	
	// Ignore patterns
	testPathIgnorePatterns: [
		'/node_modules/',
		'/build/',
		'/vendor/',
		'/coverage/',
		'/playwright-reports/',
	],
	
	// Transform configuration
	transformIgnorePatterns: [
		'node_modules/(?!(.*\\.mjs$|@wordpress))',
	],
};