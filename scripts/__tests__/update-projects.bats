#!/usr/bin/env bats

# update-projects.bats - Minimal bats test for update-projects script

# Setup function run before each test
setup() {
    SCRIPT_PATH="./scripts/update-projects.sh"
}

@test "script exists and is executable" {
    [ -x "$SCRIPT_PATH" ]
}

@test "script shows help with --help flag" {
    run "$SCRIPT_PATH" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
    [[ "$output" == *"OPTIONS:"* ]]
    [[ "$output" == *"EXAMPLES:"* ]]
}

@test "script fails with missing parameters" {
    run "$SCRIPT_PATH" --dry-run
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing required parameters"* ]]
}

@test "script fails with invalid flag" {
    run "$SCRIPT_PATH" --invalid-flag
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown option"* ]]
}

@test "dry-run mode works with valid parameters" {
    run "$SCRIPT_PATH" --project-owner testorg --project-number 123 --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"[DRY RUN]"* ]]
    [[ "$output" == *"Skipping authentication checks"* ]]
    [[ "$output" == *"Would execute:"* ]]
}

@test "script shows correct usage in help" {
    run "$SCRIPT_PATH" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"--project-owner"* ]]
    [[ "$output" == *"--project-number"* ]]
    [[ "$output" == *"--dry-run"* ]]
    [[ "$output" == *"--auto-refresh"* ]]
}

@test "script can be sourced without running main" {
    # Source the script in a subshell to test it doesn't auto-execute
    run bash -c "source $SCRIPT_PATH; echo 'sourced successfully'"
    [ "$status" -eq 0 ]
    [[ "$output" == *"sourced successfully"* ]]
    # Should not contain main execution output
    [[ "$output" != *"GitHub Projects Update Script"* ]]
}