#!/bin/bash

# test-create-project-field.sh - Test harness for project field creation
# Sources the script (without running main), inspects built gh command, and runs in dry-run mode

set -euo pipefail

echo "Testing create_project_field functionality"
echo "=========================================="

# Source the update-projects.sh script without running main
# The script is designed to only run main() when executed directly, not when sourced
source ./scripts/update-projects.sh

echo
echo "Test 1: build_project_field_cmd function"
echo "----------------------------------------"

# Test the build_project_field_cmd helper function
echo "Testing build_project_field_cmd with valid parameters:"
cmd_output=$(build_project_field_cmd "Test Field" "text" "testorg" "123")
echo "Command array output:"
echo "$cmd_output"

# Verify expected command structure
expected_parts=("gh" "project" "field-create" "testorg/123" "--name" "Test Field" "--data-type" "text")
IFS=$'\n' read -d '' -r -a cmd_array <<< "$cmd_output" || true

echo
echo "Verifying command structure:"
for i in "${!expected_parts[@]}"; do
    if [[ "${cmd_array[$i]}" == "${expected_parts[$i]}" ]]; then
        echo "✓ Part $i: '${cmd_array[$i]}' matches expected '${expected_parts[$i]}'"
    else
        echo "✗ Part $i: '${cmd_array[$i]}' does not match expected '${expected_parts[$i]}'"
        exit 1
    fi
done

echo
echo "Test 2: build_project_field_cmd with missing parameters"
echo "-------------------------------------------------------"
if build_project_field_cmd "" "text" "testorg" "123" 2>/dev/null; then
    echo "ERROR: Should have failed due to empty field name"
    exit 1
else
    echo "✓ Correctly failed due to empty field name"
fi

echo
echo "Test 3: Full script dry-run test"
echo "--------------------------------"
echo "Running full script in dry-run mode to display commands:"
./scripts/update-projects.sh --project-owner testorg --project-number 456 --dry-run

echo
echo "Test 4: Verify --data-type flag (not --type)"
echo "--------------------------------------------"
cmd_output=$(build_project_field_cmd "Priority" "single_select" "myorg" "789")
if echo "$cmd_output" | grep -q -- "--data-type"; then
    echo "✓ Uses correct --data-type flag"
else
    echo "✗ Missing --data-type flag"
    exit 1
fi

if echo "$cmd_output" | grep -q -- "--type"; then
    echo "✗ Still using invalid --type flag"
    exit 1
else
    echo "✓ Correctly avoids invalid --type flag"
fi

echo
echo "All project field tests passed! ✓"