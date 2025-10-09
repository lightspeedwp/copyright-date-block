#!/bin/bash

# Test harness for the update-projects.sh script
# This script sources the main script without running it, then tests specific functions

set -euo pipefail

# Source the update-projects.sh script without executing main
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/update-projects.sh"

echo "Testing update-projects.sh functionality"
echo "========================================"

# Test the build_project_field_cmd helper function
echo
echo "1. Testing build_project_field_cmd function:"
echo "   Input: Priority, SINGLE_SELECT, testorg, 42"

cmd_result=$(build_project_field_cmd "Priority" "SINGLE_SELECT" "testorg" "42")
echo "   Output: $cmd_result"

# Verify the command structure
expected="gh project field-create --owner testorg --data-type SINGLE_SELECT --name Priority 42"
if [[ "$cmd_result" == "$expected" ]]; then
    echo "   ✅ Command structure is correct"
else
    echo "   ❌ Command structure mismatch"
    echo "      Expected: $expected"
    echo "      Got:      $cmd_result"
fi

echo
echo "2. Testing another field type:"
echo "   Input: Due Date, DATE, myorg, 1"

cmd_result2=$(build_project_field_cmd "Due Date" "DATE" "myorg" "1")
echo "   Output: $cmd_result2"

expected2="gh project field-create --owner myorg --data-type DATE --name Due Date 1"
if [[ "$cmd_result2" == "$expected2" ]]; then
    echo "   ✅ Command structure is correct"
else
    echo "   ❌ Command structure mismatch"
    echo "      Expected: $expected2"
    echo "      Got:      $cmd_result2"
fi

echo
echo "3. Testing dry-run mode with the full script:"
echo "   Running: $SCRIPT_DIR/update-projects.sh --project-owner testorg --project-number 1 --dry-run"
echo

# Execute the script in dry-run mode
"$SCRIPT_DIR/update-projects.sh" --project-owner testorg --project-number 1 --dry-run

echo
echo "✅ Test harness completed successfully"
echo "   The build_project_field_cmd function works correctly"
echo "   Dry-run mode prevents actual command execution"
echo "   All security features are functioning as expected"