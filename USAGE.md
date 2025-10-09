# Copyright Date Block Usage Guide

## Table of Contents

1. [Overview](#overview)
2. [Basic Usage](#basic-usage)
3. [Block Configuration](#block-configuration)
4. [Advanced Usage](#advanced-usage)
5. [Template Integration](#template-integration)
6. [Customization](#customization)
7. [Troubleshooting](#troubleshooting)

## Overview

The Copyright Date Block provides a dynamic way to display copyright dates in your WordPress content. The block automatically updates to show the current year and can be configured to display date ranges.

## Basic Usage

### Adding the Block

1. Open a post or page in the WordPress block editor
2. Click the "+" button to add a new block
3. Search for "Copyright Date" or find it in the "Widgets" category
4. Click to insert the block

### Default Behavior

By default, the block displays:
```
© 2024
```

The year automatically updates based on the current date, ensuring your copyright information stays current without manual updates.

## Block Configuration

### Settings Panel

When the Copyright Date Block is selected, you'll see configuration options in the Settings sidebar:

#### Show Starting Year
- **Toggle**: Enable to display a date range
- **Starting Year Field**: Enter the year your content or site was first published
- **Result**: Displays as "© 2020–2024" (example)

### Validation
- Starting years must be between 1900 and the current year + 10
- Invalid years will not be saved
- Empty or invalid starting years default to current year only

## Advanced Usage

For advanced implementation examples, see [`examples/advanced-usage.php`](examples/advanced-usage.php) which includes:

- Theme Customizer integration
- Template helper functions
- Programmatic block insertion
- Custom styling options

## Template Integration

### PHP Template Files

You can manually render copyright dates in PHP templates using the utility functions:

```php
<?php
// Include the plugin functions
if ( function_exists( 'create_block_copyright_date_block_init' ) ) {
    // The block is available
    echo '© ' . date( 'Y' );
}
?>
```

### Block Patterns

Create reusable patterns that include the Copyright Date Block:

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

## Customization

### Styling

The block outputs minimal HTML that can be styled with CSS:

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