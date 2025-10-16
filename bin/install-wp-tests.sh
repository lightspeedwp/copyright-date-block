#!/bin/bash
#
# Install WP test framework for PHPUnit tests
#

set -euo pipefail

if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <db-name> <db-user> <db-pass> [db-host] [wp-version] [skip-database-creation]"
    exit 1
fi

DB_NAME=$1
DB_USER=$2
DB_PASS=$3
DB_HOST=${4:-localhost}
WP_VERSION=${5:-latest}
SKIP_DB_CREATE=${6:-false}

# Define WordPress test library path
WP_TESTS_DIR=${WP_TESTS_DIR:-/tmp/wordpress-tests-lib}
WP_CORE_DIR=${WP_CORE_DIR:-/tmp/wordpress}

# Download WordPress test library
download() {
    if command -v curl &> /dev/null; then
        curl -s "$1" > "$2"
    elif command -v wget &> /dev/null; then
        wget -nv -O "$2" "$1"
    else
        echo "Error: curl or wget is required" >&2
        exit 1
    fi
}

# Install WordPress test framework
install_wp_tests() {
    mkdir -p "$WP_TESTS_DIR"

    # Get WordPress test suite
    if [[ ! -f "$WP_TESTS_DIR"/wp-tests-config.php ]]; then
        download "https://develop.svn.wordpress.org/tags/$WP_VERSION/tests/phpunit/wp-tests-config-sample.php" "$WP_TESTS_DIR"/wp-tests-config.php

        # Set up config
        sed -i "s/youremptytestdbnamehere/$DB_NAME/" "$WP_TESTS_DIR"/wp-tests-config.php
        sed -i "s/yourusernamehere/$DB_USER/" "$WP_TESTS_DIR"/wp-tests-config.php
        sed -i "s/yourpasswordhere/$DB_PASS/" "$WP_TESTS_DIR"/wp-tests-config.php
        sed -i "s|localhost|${DB_HOST}|" "$WP_TESTS_DIR"/wp-tests-config.php
    fi

    # Install test suite
    if [[ ! -d "$WP_TESTS_DIR"/includes ]]; then
        mkdir -p "$WP_TESTS_DIR"/includes
        download "https://develop.svn.wordpress.org/tags/$WP_VERSION/tests/phpunit/includes/" "$WP_TESTS_DIR"/includes/
    fi

    # Install WordPress
    if [[ ! -d "$WP_CORE_DIR" ]]; then
        mkdir -p "$WP_CORE_DIR"
        download "https://wordpress.org/$WP_VERSION.tar.gz" /tmp/wordpress.tar.gz
        tar -xzf /tmp/wordpress.tar.gz -C /tmp
        rm /tmp/wordpress.tar.gz
    fi

    # Create test database if needed
    if [[ "$SKIP_DB_CREATE" != "true" ]]; then
        mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -e "DROP DATABASE IF EXISTS $DB_NAME;"
        mysql -u "$DB_USER" -p"$DB_PASS" -h "$DB_HOST" -e "CREATE DATABASE $DB_NAME;"
    fi
}

# Execute main function
install_wp_tests "$DB_NAME" "$DB_USER" "$DB_PASS" "$DB_HOST" "$WP_VERSION" "$SKIP_DB_CREATE"

echo "WordPress test installation complete!"
