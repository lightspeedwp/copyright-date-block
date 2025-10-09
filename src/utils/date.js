/**
 * Utility functions related to dates used by the copyright block.
 */

/**
 * Get current year as number.
 * @return {number} The current full year (e.g., 2025)
 */
export function getCurrentYear() {
	return new Date().getFullYear();
}

/**
 * Build a year range string (e.g., "2020–2025") given a start year and optional end year.
 * If start and end are identical or end is missing, returns single year.
 * @param {number} startYear
 * @param {number} [endYear]
 * @return {string} A single year or a year range string (en dash separated)
 */
export function formatYearRange(startYear, endYear = getCurrentYear()) {
	if (!startYear || typeof startYear !== 'number') {
		throw new Error('startYear must be a number');
	}
	if (endYear && typeof endYear !== 'number') {
		throw new Error('endYear must be a number when provided');
	}
	if (endYear < startYear) {
		return String(startYear); // Avoid weird ranges; could also throw.
	}
	return startYear === endYear
		? String(startYear)
		: `${startYear}\u2013${endYear}`;
}
