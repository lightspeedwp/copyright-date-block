<?php
/**
 * Advanced usage example for Copyright Date Block
 *
 * This example shows how a theme might expose a setting (via the Customizer)
 * to set a site starting year, then render the block in a template using that
 * site-wide value. It also demonstrates a helper function wrapper for easier
 * reuse in templates.
 *
 * Drop this file into your theme (e.g. `wp-content/themes/yourtheme/inc/`) and
 * include it from your theme's `functions.php` (or adapt the code to your
 * theme structure).
 */

// 1) Register a Customizer setting so the site admin can set the "Starting year".
function theme_copyright_customizer( $wp_customize ) {
    $wp_customize->add_section( 'copyright_settings', array(
        'title'    => __( 'Copyright', 'text-domain' ),
        'priority' => 120,
    ) );

    $wp_customize->add_setting( 'theme_starting_year', array(
        'default'           => '',
        'sanitize_callback' => 'absint',
    ) );

    $wp_customize->add_control( 'theme_starting_year', array(
        'label'   => __( 'Copyright starting year', 'text-domain' ),
        'section' => 'copyright_settings',
        'type'    => 'number',
        'input_attrs' => array(
            'min' => 1900,
            'max' => date( 'Y' ),
        ),
    ) );
}
add_action( 'customize_register', 'theme_copyright_customizer' );


// 2) Template helper: render the block using the theme setting if present.
/**
 * Render the copyright block, preferring the theme setting if available.
 *
 * @param array $args Optional args: 'use_theme_setting' => true|false
 */
function render_copyright_block( $args = array() ) {
    $args = wp_parse_args( $args, array(
        'use_theme_setting' => true,
    ) );

    $starting_year = '';
    if ( $args['use_theme_setting'] ) {
        $starting_year = get_theme_mod( 'theme_starting_year', '' );
    }

    // Build attributes JSON for the block. The block is self-contained and will
    // use server-side rendering (src/render.php) when processed via do_blocks/apply_filters.
    $attributes = array();

    if ( ! empty( $starting_year ) ) {
        $attributes['showStartingYear'] = true;
        $attributes['startingYear']    = (int) $starting_year;
    } else {
        $attributes['showStartingYear'] = false;
    }

    // Convert attributes to JSON and build the static block comment markup.
    $attr_json = wp_json_encode( $attributes );

    $block_markup = sprintf( '<!-- wp:copyright-date-block/copyright-date %s /-->', $attr_json );

    // Render via the_content filter so any server-side render callback runs.
    echo apply_filters( 'the_content', $block_markup );
}

// Optionally provide a shorter helper for templates.
function the_site_copyright() {
    render_copyright_block();
}

// Example usage in a theme template (e.g. footer.php):
// <?php the_site_copyright(); ?>

?>
