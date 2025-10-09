#!/usr/bin/env bats

# Bats tests for update-projects.sh script
# Run with: bats scripts/__tests__/update-projects.bats

setup() {
    # Setup test environment
    export SCRIPT_DIR="$(dirname "$BATS_TEST_DIRNAME")"
    export SCRIPT_PATH="$SCRIPT_DIR/update-projects.sh"
    
    # Ensure script exists and is executable
    [ -f "$SCRIPT_PATH" ]
    [ -x "$SCRIPT_PATH" ]
}

@test "script shows help when --help flag is used" {
    run "$SCRIPT_PATH" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "GitHub Projects management script" ]]
}

@test "script shows help when -h flag is used" {
    run "$SCRIPT_PATH" -h  
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "script rejects invalid options" {
    run "$SCRIPT_PATH" --invalid-option
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown option" ]]
}

@test "script runs successfully in dry-run mode" {
    run "$SCRIPT_PATH" --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" =~ "DRY-RUN MODE" ]]
    [[ "$output" =~ "Skipping authentication and scope checks" ]]
}

@test "script accepts project parameters in dry-run mode" {
    run "$SCRIPT_PATH" --project-owner testorg --project-number 42 --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" =~ "DRY-RUN MODE" ]]
    [[ "$output" =~ "Project: testorg/42" ]]
}

@test "script can be sourced without executing main" {
    # Test that the script can be sourced for testing individual functions
    run bash -c "source '$SCRIPT_PATH' && echo 'Sourced successfully'"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Sourced successfully" ]]
}

@test "build_project_field_cmd function works correctly" {
    # Test the helper function by sourcing the script
    run bash -c "source '$SCRIPT_PATH' && build_project_field_cmd 'Test Field' 'TEXT' 'testorg' '1'"
    [ "$status" -eq 0 ]
    [[ "$output" == "gh project field-create --owner testorg --data-type TEXT --name Test Field 1" ]]
}