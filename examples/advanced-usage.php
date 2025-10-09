<?php
/**
 * Advanced Usage Examples for Copyright Date Block
 *
 * This file demonstrates advanced integration patterns for the
 * Copyright Date Block plugin, including theme customization,
 * programmatic block insertion, and template helpers.
 *
 * @package copyright-date-block
 */

// Prevent direct access
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Example 1: Theme Customizer Integration
 *
 * Add a customizer control to set the starting year site-wide.
 */
function copyright_date_block_customizer( $wp_customize ) {
	// Add a new section
	$wp_customize->add_section(
		'copyright_date_settings',
		array(
			'title'    => __( 'Copyright Date Settings', 'copyright-date-block' ),
			'priority' => 120,
		)
	);

	// Add setting for starting year
	$wp_customize->add_setting(
		'copyright_starting_year',
		array(
			'default'           => '',
			'sanitize_callback' => 'copyright_date_sanitize_year',
			'transport'         => 'refresh',
		)
	);

	// Add control
	$wp_customize->add_control(
		'copyright_starting_year',
		array(
			'label'       => __( 'Copyright Starting Year', 'copyright-date-block' ),
			'description' => __( 'Enter the year your site was first published. Leave empty to show current year only.', 'copyright-date-block' ),
			'section'     => 'copyright_date_settings',
			'type'        => 'number',
			'input_attrs' => array(
				'min'  => 1900,
				'max'  => date( 'Y' ) + 10,
				'step' => 1,
			),
		)
	);
}
add_action( 'customize_register', 'copyright_date_block_customizer' );

/**
 * Sanitize year input for customizer
 *
 * @param string $input The year input to sanitize.
 * @return string Sanitized year or empty string.
 */
function copyright_date_sanitize_year( $input ) {
	$year = intval( $input );
	if ( $year >= 1900 && $year <= ( date( 'Y' ) + 10 ) ) {
		return (string) $year;
	}
	return '';
}

/**
 * Example 2: Template Helper Functions
 *
 * Utility functions for use in theme templates.
 */

/**
 * Get formatted copyright text with optional starting year.
 *
 * @param string $starting_year Optional starting year.
 * @param bool   $show_symbol   Whether to include © symbol.
 * @return string Formatted copyright text.
 */
function get_copyright_date_text( $starting_year = '', $show_symbol = true ) {
	$current_year = date( 'Y' );
	$symbol       = $show_symbol ? '© ' : '';

	// Use customizer setting if no starting year provided
	if ( empty( $starting_year ) ) {
		$starting_year = get_theme_mod( 'copyright_starting_year', '' );
	}

	if ( empty( $starting_year ) || $starting_year === $current_year ) {
		return $symbol . $current_year;
	}

	return $symbol . $starting_year . '–' . $current_year;
}

/**
 * Echo formatted copyright text.
 *
 * @param string $starting_year Optional starting year.
 * @param bool   $show_symbol   Whether to include © symbol.
 */
function copyright_date_text( $starting_year = '', $show_symbol = true ) {
	echo esc_html( get_copyright_date_text( $starting_year, $show_symbol ) );
}

/**
 * Example 3: Programmatic Block Insertion
 *
 * Add copyright block to content programmatically.
 */

/**
 * Automatically append copyright block to pages.
 *
 * @param string $content The post content.
 * @return string Modified content with copyright block.
 */
function auto_append_copyright_block( $content ) {
	// Only on pages, not posts or other post types
	if ( ! is_page() ) {
		return $content;
	}

	// Don't add to admin or feed
	if ( is_admin() || is_feed() ) {
		return $content;
	}

	// Get starting year from customizer
	$starting_year = get_theme_mod( 'copyright_starting_year', '' );

	// Build block attributes
	$attributes = array(
		'fallbackCurrentYear' => date( 'Y' ),
	);

	if ( ! empty( $starting_year ) ) {
		$attributes['showStartingYear'] = true;
		$attributes['startingYear']     = $starting_year;
	}

	// Create block
	$block_content = '<!-- wp:copyright-date/copyright-date-block ' . wp_json_encode( $attributes ) . ' /-->';

	return $content . $block_content;
}
// Uncomment the line below to enable auto-append functionality
// add_filter( 'the_content', 'auto_append_copyright_block' );

/**
 * Example 4: Custom Block Variation
 *
 * Register a custom variation of the copyright block.
 */
function register_copyright_block_variations() {
	wp_add_inline_script(
		'wp-blocks',
		"
		wp.blocks.registerBlockVariation( 'copyright-date/copyright-date-block', {
			name: 'copyright-with-company',
			title: 'Copyright with Company Name',
			description: 'Copyright block with your company name included.',
			attributes: {
				showStartingYear: true,
				startingYear: '" . get_theme_mod( 'copyright_starting_year', '2020' ) . "'
			},
			scope: [ 'inserter' ]
		} );
		"
	);
}
add_action( 'enqueue_block_editor_assets', 'register_copyright_block_variations' );

/**
 * Example 5: Footer Widget Integration
 *
 * Create a widget that uses the copyright date functionality.
 */
class Copyright_Date_Widget extends WP_Widget {

	/**
	 * Constructor
	 */
	public function __construct() {
		parent::__construct(
			'copyright_date_widget',
			__( 'Copyright Date', 'copyright-date-block' ),
			array(
				'description' => __( 'Display a copyright date in your footer.', 'copyright-date-block' ),
			)
		);
	}

	/**
	 * Widget output
	 *
	 * @param array $args     Widget arguments.
	 * @param array $instance Widget instance data.
	 */
	public function widget( $args, $instance ) {
		echo $args['before_widget'];

		$company_name  = ! empty( $instance['company_name'] ) ? $instance['company_name'] : '';
		$starting_year = ! empty( $instance['starting_year'] ) ? $instance['starting_year'] : '';

		$copyright_text = get_copyright_date_text( $starting_year, true );

		if ( ! empty( $company_name ) ) {
			$copyright_text .= ' ' . esc_html( $company_name );
		}

		echo '<p class="copyright-widget">' . esc_html( $copyright_text ) . '</p>';

		echo $args['after_widget'];
	}

	/**
	 * Widget form
	 *
	 * @param array $instance Widget instance data.
	 */
	public function form( $instance ) {
		$company_name  = ! empty( $instance['company_name'] ) ? $instance['company_name'] : '';
		$starting_year = ! empty( $instance['starting_year'] ) ? $instance['starting_year'] : '';
		?>
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'company_name' ) ); ?>">
				<?php esc_html_e( 'Company Name:', 'copyright-date-block' ); ?>
			</label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'company_name' ) ); ?>" 
				   name="<?php echo esc_attr( $this->get_field_name( 'company_name' ) ); ?>" 
				   type="text" value="<?php echo esc_attr( $company_name ); ?>">
		</p>
		<p>
			<label for="<?php echo esc_attr( $this->get_field_id( 'starting_year' ) ); ?>">
				<?php esc_html_e( 'Starting Year:', 'copyright-date-block' ); ?>
			</label>
			<input class="widefat" id="<?php echo esc_attr( $this->get_field_id( 'starting_year' ) ); ?>" 
				   name="<?php echo esc_attr( $this->get_field_name( 'starting_year' ) ); ?>" 
				   type="number" value="<?php echo esc_attr( $starting_year ); ?>"
				   min="1900" max="<?php echo esc_attr( date( 'Y' ) + 10 ); ?>">
		</p>
		<?php
	}

	/**
	 * Update widget
	 *
	 * @param array $new_instance New widget instance data.
	 * @param array $old_instance Old widget instance data.
	 * @return array Updated instance data.
	 */
	public function update( $new_instance, $old_instance ) {
		$instance                   = array();
		$instance['company_name']   = ! empty( $new_instance['company_name'] ) ? sanitize_text_field( $new_instance['company_name'] ) : '';
		$instance['starting_year']  = ! empty( $new_instance['starting_year'] ) ? copyright_date_sanitize_year( $new_instance['starting_year'] ) : '';

		return $instance;
	}
}

/**
 * Register the widget
 */
function register_copyright_date_widget() {
	register_widget( 'Copyright_Date_Widget' );
}
add_action( 'widgets_init', 'register_copyright_date_widget' );

/**
 * Example 6: REST API Endpoint
 *
 * Create a REST API endpoint for getting copyright information.
 */
function register_copyright_date_rest_route() {
	register_rest_route(
		'copyright-date/v1',
		'/copyright',
		array(
			'methods'             => 'GET',
			'callback'            => 'get_copyright_date_rest_response',
			'permission_callback' => '__return_true',
		)
	);
}
add_action( 'rest_api_init', 'register_copyright_date_rest_route' );

/**
 * REST API callback for copyright date.
 *
 * @param WP_REST_Request $request The REST request.
 * @return WP_REST_Response The REST response.
 */
function get_copyright_date_rest_response( $request ) {
	$starting_year = $request->get_param( 'starting_year' );
	if ( empty( $starting_year ) ) {
		$starting_year = get_theme_mod( 'copyright_starting_year', '' );
	}

	$data = array(
		'current_year'    => date( 'Y' ),
		'starting_year'   => $starting_year,
		'formatted_text'  => get_copyright_date_text( $starting_year, true ),
		'formatted_plain' => get_copyright_date_text( $starting_year, false ),
	);

	return new WP_REST_Response( $data, 200 );
}