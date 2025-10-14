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
export function formatYearRange( startYear, endYear = getCurrentYear() ) {
	if ( typeof startYear !== 'number' || Number.isNaN( startYear ) ) {
		throw new Error( 'startYear must be a number' );
	}
	if (
		endYear &&
		( typeof endYear !== 'number' || Number.isNaN( endYear ) )
	) {
		throw new Error( 'endYear must be a number when provided' );
	}
	if ( endYear < startYear ) {
		return String( startYear ); // Avoid odd reversed ranges; alternative would be to throw.
	}
	return startYear === endYear
		? String( startYear )
		: `${ startYear }\u2013${ endYear }`;
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
