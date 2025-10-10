# Usage — Copyright Date Block

Table of contents

- Introduction
- Installation
- Adding the block
- Block settings
- Examples
- Using the block in PHP templates
- Development commands

## Introduction

The Copyright Date Block displays an always-up-to-date copyright year on your site. It supports an optional start year to show ranges such as `2020–2025`, and uses server-side rendering so the front end always reflects the current year.

## Installation

1. Place the `copyright-date-block` folder in your site's `wp-content/plugins` directory.
2. From the plugin directory run:

    npm install
    npm run build

3. Activate the plugin from the WordPress Plugins screen.

## Adding the block

- Edit a post, page, or open the Site Editor (Appearance → Editor).
- Insert the **Copyright Date** block where you want the copyright line to appear.

## Block settings

- Show starting year (toggle): enables a starting year so the block displays a range.
- Starting year (input): 4-digit year (for example `2020`).
- Text color / font size: use the block controls to match your theme.

## Examples

Single year (site launched this year):

    © 2025

Range when starting year is provided and older than current year:

    © 2020–2025

## Using the block in PHP templates

If you prefer to inject the block markup via PHP (for example in a theme template), the following minimal example will render the block and allow the plugin's server-side render function (`src/render.php`) to output the correct markup:

    <?php
    echo apply_filters( 'the_content', '<!-- wp:copyright-date-block/copyright-date {"showStartingYear":true,"startingYear":2020} /-->' );
    ?>

This approach is useful when you want a static insertion point in a theme file rather than managing the block inside the editor.

## Development commands

- `npm start` — development watcher with hot reload
- `npm run build` — production build
- `npm test` — run unit tests
- `npm run lint:js` / `npm run lint:css` — linting
- `npm run plugin-zip` — generate a zip for distribution

---

If you'd like, I can also:

```php
register_block_pattern(
    'my-theme/footer-with-copyright',
    array(
        'title'       => __( 'Footer with Copyright', 'my-theme' ),
        'description' => _x( 'Footer section with copyright date', 'Block pattern description', 'my-theme' ),
        'content'     => '<!-- wp:copyright-date/copyright-date-block /-->',
        'categories'  => array( 'footer' ),
    )
);
```

- Add screenshots to `USAGE.md` showing the inspector controls.
- Provide a more advanced PHP example that loads the starting year from a theme option or site setting.

I added an advanced example file at `examples/advanced-usage.php`. To use it in a theme, copy the file into your theme (for example `wp-content/themes/yourtheme/inc/advanced-usage.php`) and include it from your theme's `functions.php`:

    require get_template_directory() . '/inc/advanced-usage.php';

This file demonstrates registering a Customizer setting for a site-wide starting year and provides `the_site_copyright()` helper function for templates.

```css
.wp-block-copyright-date-copyright-date-block {
    text-align: center;
    font-size: 0.875rem;
    color: #666;
    margin: 1rem 0;
}

/* For footer usage */
.site-footer .wp-block-copyright-date-copyright-date-block {
    margin: 0;
    color: white;
}
```

### Custom Formats

While the block uses a standard format (© Year or © Start–End), you can modify the output using CSS pseudo-elements or JavaScript for more complex formatting needs.

## Troubleshooting

### Common Issues

#### Block Not Showing Current Year
- **Problem**: Block shows an old year
- **Solution**: The block uses server-side rendering for accuracy. Clear any caching plugins and refresh the page.

#### Starting Year Not Saving
- **Problem**: Starting year input doesn't save
- **Solution**: Ensure the year is between 1900 and current year + 10. Invalid years are rejected.

#### Block Not Available
- **Problem**: Can't find the Copyright Date Block
- **Solution**: Ensure the plugin is activated. Check WordPress admin → Plugins.

### Support

For additional support:

1. Check the [GitHub Issues](https://github.com/lightspeedwp/copyright-date-block/issues)
2. Review the plugin documentation
3. Verify WordPress and plugin versions are up to date

### Development

For developers working with this plugin:

- Source code is available on [GitHub](https://github.com/lightspeedwp/copyright-date-block)
- Follow coding standards defined in `.eslintrc.json`
- Run tests with `npm test` before contributing
- See README.md for development setup instructions

## Advanced Usage

An advanced example is provided at `examples/advanced-usage.php`. It demonstrates registering a Customizer setting for a site-wide starting year and exposing a `the_site_copyright()` helper for use in theme templates.

Usage:

1. Copy `examples/advanced-usage.php` into your theme, for example:

    // wp-content/themes/yourtheme/inc/advanced-usage.php

1. Include it from your theme's `functions.php`:

    require get_template_directory() . '/inc/advanced-usage.php';