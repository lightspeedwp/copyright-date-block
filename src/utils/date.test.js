import { getCurrentYear, formatYearRange } from './date';

describe('date utils', () => {
	it('getCurrentYear matches system year', () => {
		const y = new Date().getFullYear();
		expect(getCurrentYear()).toBe(y);
	});

	it('formatYearRange single year when same', () => {
		expect(formatYearRange(2024, 2024)).toBe('2024');
	});

	it('formatYearRange range when different', () => {
		expect(formatYearRange(2020, 2025)).toBe('2020–2025');
	});

	it('formatYearRange uses current year default', () => {
		const y = new Date().getFullYear();
		expect(formatYearRange(y)).toBe(String(y));
	});

	it('formatYearRange handles reversed years gracefully', () => {
		expect(formatYearRange(2025, 2020)).toBe('2025');
	});
});
