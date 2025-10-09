/**
 * Tests for date utility functions.
 */

import { getCurrentYear, formatCopyrightRange, isValidYear } from './date';

// Mock Date to ensure consistent test results
const mockDate = new Date( '2024-01-01' );
const realDate = Date;

// Capture current year once for stable testing (used implicitly in mocked tests)
// eslint-disable-next-line no-unused-vars
const CURRENT_YEAR = '2024';

beforeAll( () => {
	global.Date = class extends Date {
		constructor( ...args ) {
			if ( args.length === 0 ) {
				return mockDate;
			}
			return new realDate( ...args );
		}

		static now() {
			return mockDate.getTime();
		}
	};
} );

afterAll( () => {
	global.Date = realDate;
} );

describe( 'getCurrentYear', () => {
	it( 'should return the current year as a string', () => {
		expect( getCurrentYear() ).toBe( '2024' );
	} );
} );

describe( 'formatCopyrightRange', () => {
	it( 'should return only the current year when no start year is provided', () => {
		expect( formatCopyrightRange( null ) ).toBe( '2024' );
		expect( formatCopyrightRange( '' ) ).toBe( '2024' );
	} );

	it( 'should return only the current year when start year equals current year', () => {
		expect( formatCopyrightRange( '2024' ) ).toBe( '2024' );
	} );

	it( 'should return a range when start year is different from current year', () => {
		expect( formatCopyrightRange( '2020' ) ).toBe( '2020–2024' );
		expect( formatCopyrightRange( '2010' ) ).toBe( '2010–2024' );
	} );

	it( 'should accept a custom end year', () => {
		expect( formatCopyrightRange( '2020', '2023' ) ).toBe( '2020–2023' );
	} );

	it( 'should return only end year when start year equals end year', () => {
		expect( formatCopyrightRange( '2023', '2023' ) ).toBe( '2023' );
	} );

	it( 'should handle startYear of 0 correctly', () => {
		expect( formatCopyrightRange( '0' ) ).toBe( '0–2024' );
	} );

	it( 'should handle endYear of 0 correctly', () => {
		expect( formatCopyrightRange( '2020', '0' ) ).toBe( '2020–0' );
	} );

	it( 'should handle both startYear and endYear of 0', () => {
		expect( formatCopyrightRange( '0', '0' ) ).toBe( '0' );
	} );

	it( 'should handle omitted endYear parameter', () => {
		expect( formatCopyrightRange( '2020' ) ).toBe( '2020–2024' );
		expect( formatCopyrightRange( '2020', undefined ) ).toBe( '2020–2024' );
	} );
} );

describe( 'isValidYear', () => {
	it( 'should return true for valid years', () => {
		expect( isValidYear( '2024' ) ).toBe( true );
		expect( isValidYear( 2024 ) ).toBe( true );
		expect( isValidYear( '2000' ) ).toBe( true );
		expect( isValidYear( '1900' ) ).toBe( true );
	} );

	it( 'should return false for years before 1900', () => {
		expect( isValidYear( '1899' ) ).toBe( false );
		expect( isValidYear( 1800 ) ).toBe( false );
	} );

	it( 'should return false for years too far in the future', () => {
		expect( isValidYear( '2040' ) ).toBe( false );
		expect( isValidYear( 3000 ) ).toBe( false );
	} );

	it( 'should return false for non-numeric values', () => {
		expect( isValidYear( 'abc' ) ).toBe( false );
		expect( isValidYear( null ) ).toBe( false );
		expect( isValidYear( undefined ) ).toBe( false );
	} );

	it( 'should handle edge case of year 0', () => {
		expect( isValidYear( 0 ) ).toBe( false );
		expect( isValidYear( '0' ) ).toBe( false );
	} );

	it( 'should handle boundary values correctly', () => {
		expect( isValidYear( 1900 ) ).toBe( true );
		expect( isValidYear( 1899 ) ).toBe( false );
		expect( isValidYear( 2034 ) ).toBe( true ); // current year + 10
		expect( isValidYear( 2035 ) ).toBe( false ); // current year + 11
	} );

	it( 'should handle various non-number types', () => {
		expect( isValidYear( {} ) ).toBe( false );
		expect( isValidYear( [] ) ).toBe( false );
		expect( isValidYear( true ) ).toBe( false );
		expect( isValidYear( false ) ).toBe( false );
	} );
} );
