/**
 * Date utility functions for the Copyright Date Block.
 */

/**
 * Get the current year as a string.
 *
 * @return {string} The current year.
 */
export function getCurrentYear() {
	return new Date().getFullYear().toString();
}

/**
 * Format a copyright date range.
 *
 * @param {string} startYear The starting year.
 * @param {string} endYear   The ending year (defaults to current year).
 *
 * @return {string} The formatted copyright date range.
 */
export function formatCopyrightRange( startYear, endYear = null ) {
	const currentYear =
		endYear !== null && endYear !== undefined ? endYear : getCurrentYear();

	if ( ! startYear || startYear === currentYear ) {
		return currentYear;
	}

	return `${ startYear }–${ currentYear }`;
}

/**
 * Validate that a year is within reasonable bounds.
 *
 * @param {string|number} year The year to validate.
 *
 * @return {boolean} Whether the year is valid.
 */
export function isValidYear( year ) {
	const numericYear = parseInt( year, 10 );
	const currentYear = new Date().getFullYear();

	return (
		! isNaN( numericYear ) &&
		numericYear >= 1900 &&
		numericYear <= currentYear + 10
	);
}
