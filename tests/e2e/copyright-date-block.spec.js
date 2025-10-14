const { test, expect } = require( '@playwright/test' );

test.describe( 'Copyright Date Block', () => {
	test.beforeEach( async ( { page } ) => {
		// Navigate to WordPress admin and login if needed
		await page.goto( '/wp-admin' );

		// You may need to add login logic here if authentication is required
		// await page.fill('#user_login', 'admin');
		// await page.fill('#user_pass', 'password');
		// await page.click('#wp-submit');
	} );

	test( 'should display copyright date block in editor', async ( {
		page,
	} ) => {
		// Navigate to create new post
		await page.goto( '/wp-admin/post-new.php' );

		// Wait for the editor to load
		await page.waitForSelector( '.block-editor-writing-flow' );

		// Add the copyright date block
		await page.click( '.block-editor-default-block-appender__content' );
		await page.keyboard.type( '/copyright' );

		// Wait for block to appear in search results
		await page.waitForSelector( '[data-type="copyright-date-block/copyright-date"]', {
			timeout: 5000,
		} );
		await page.click( '[data-type="copyright-date-block/copyright-date"]' );

		// Verify the block is added
		await expect(
			page.locator( '[data-type="copyright-date-block/copyright-date"]' )
		).toBeVisible();
	} );

	test( 'should render copyright date on frontend', async ( { page } ) => {
		// This test would need a published post with the copyright date block
		// You can create a test post programmatically or use an existing one

		// Navigate to a page/post that contains the copyright date block
		await page.goto( '/' );

		// Check if copyright text appears (adjust selector based on your block's output)
		const currentYear = new Date().getFullYear().toString();
		await expect(
			page.locator( '.wp-block-copyright-date-block-copyright-date' )
		).toContainText( currentYear );
	} );
} );
