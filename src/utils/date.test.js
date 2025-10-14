import { getCurrentYear, formatYearRange, isValidYear } from './date';

describe( 'date utils', () => {
	const CURRENT_YEAR = new Date().getFullYear();

	it( 'getCurrentYear matches system year', () => {
		expect( getCurrentYear() ).toBe( CURRENT_YEAR );
	} );

	it( 'formatYearRange accepts startYear 0 and endYear 0', () => {
		expect( formatYearRange( 0, 0 ) ).toBe( '0' );
	} );

	it( 'formatYearRange accepts endYear 0 with non-zero startYear', () => {
		// endYear < startYear should return startYear per implementation
		expect( formatYearRange( 2021, 0 ) ).toBe( '2021' );
	} );

	it( 'formatYearRange throws for non-number startYear', () => {
		expect( () => formatYearRange( '2020' ) ).toThrow();
	} );

	it( 'formatYearRange throws for non-number endYear when provided', () => {
		expect( () => formatYearRange( 2020, '2025' ) ).toThrow();
	} );

	it( 'formatYearRange single year when same', () => {
		expect( formatYearRange( 2024, 2024 ) ).toBe( '2024' );
	} );

	it( 'formatYearRange range when different', () => {
		expect( formatYearRange( 2020, 2025 ) ).toBe( '2020–2025' );
	} );

	it( 'formatYearRange uses current year default', () => {
		const y = new Date().getFullYear();
		expect( formatYearRange( y ) ).toBe( String( y ) );
	} );

	it( 'formatYearRange handles reversed years gracefully', () => {
		expect( formatYearRange( 2025, 2020 ) ).toBe( '2025' );
	} );

	it( 'isValidYear validates years correctly', () => {
		expect( isValidYear( 2020 ) ).toBe( true );
		expect( isValidYear( '2020' ) ).toBe( true );
		expect( isValidYear( 1900 ) ).toBe( true );
		expect( isValidYear( 1899 ) ).toBe( false );
		expect( isValidYear( CURRENT_YEAR + 10 ) ).toBe( true );
		expect( isValidYear( CURRENT_YEAR + 11 ) ).toBe( false );
		expect( isValidYear( 'invalid' ) ).toBe( false );
	} );
} );
