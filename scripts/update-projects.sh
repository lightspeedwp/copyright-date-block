#!/bin/bash

# update-projects.sh - Hardened script to update GitHub projects
# Implements security improvements and CLI flags for safer operation

set -euo pipefail

# Configuration
MAX_REFRESH_ATTEMPTS=3
DEFAULT_PROJECT_OWNER=""
DEFAULT_PROJECT_NUMBER=""

# Global variables
DRY_RUN=false
AUTO_REFRESH=false
PROJECT_OWNER=""
PROJECT_NUMBER=""
REFRESH_ATTEMPTS=0

# Usage message
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

A hardened script to update GitHub projects with authentication scope checking.

OPTIONS:
  --project-owner OWNER    GitHub project owner (username or organization)
  --project-number NUM     GitHub project number
  --dry-run               Print gh commands without executing them
  --auto-refresh          Automatically attempt to refresh scopes
  --help                  Show this help message

EXAMPLES:
  $0 --project-owner myorg --project-number 5
  $0 --project-owner myuser --project-number 1 --dry-run
  $0 --project-owner myorg --project-number 3 --auto-refresh

REQUIRED SCOPES:
  - project:read
  - project:write
  - repo (if working with repository-linked projects)

Run with --dry-run first to preview commands before execution.
EOF
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --project-owner)
                PROJECT_OWNER="$2"
                shift 2
                ;;
            --project-number)
                PROJECT_NUMBER="$2"
                shift 2
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --auto-refresh)
                AUTO_REFRESH=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                show_help >&2
                exit 1
                ;;
        esac
    done
}

# Check authentication and scopes
check_auth_scopes() {
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Skipping authentication checks"
        return 0
    fi

    echo "Checking GitHub authentication and scopes..."
    
    # Use gh api -I / to check authentication and scopes
    local auth_response
    if ! auth_response=$(gh api -I / 2>&1); then
        echo "Error: GitHub CLI authentication failed" >&2
        echo "Please run 'gh auth login' to authenticate" >&2
        return 1
    fi

    # Extract scopes from response headers
    local scopes
    scopes=$(echo "$auth_response" | grep -i "x-oauth-scopes:" | cut -d' ' -f2- | tr -d '\r\n' || echo "")
    
    if [[ -z "$scopes" ]]; then
        echo "Warning: Unable to determine OAuth scopes" >&2
        if [[ "$AUTO_REFRESH" == true && $REFRESH_ATTEMPTS -lt $MAX_REFRESH_ATTEMPTS ]]; then
            echo "Attempting to refresh authentication..."
            refresh_auth
            return $?
        else
            echo "Run with --auto-refresh to attempt scope refresh" >&2
            return 1
        fi
    fi

    echo "Current scopes: $scopes"
    
    # Check for required scopes (basic check - may need adjustment based on actual requirements)
    local required_scopes=("project" "repo")
    local missing_scopes=()
    
    for scope in "${required_scopes[@]}"; do
        if [[ ! "$scopes" =~ $scope ]]; then
            missing_scopes+=("$scope")
        fi
    done
    
    if [[ ${#missing_scopes[@]} -gt 0 ]]; then
        echo "Missing required scopes: ${missing_scopes[*]}" >&2
        if [[ "$AUTO_REFRESH" == true && $REFRESH_ATTEMPTS -lt $MAX_REFRESH_ATTEMPTS ]]; then
            echo "Attempting to refresh authentication..."
            refresh_auth
            return $?
        else
            echo "Please re-authenticate with required scopes: gh auth refresh -s project -s repo" >&2
            return 1
        fi
    fi
    
    echo "✓ Authentication and scopes verified"
    return 0
}

# Refresh authentication with required scopes
refresh_auth() {
    ((REFRESH_ATTEMPTS++))
    
    if [[ $REFRESH_ATTEMPTS -ge $MAX_REFRESH_ATTEMPTS ]]; then
        echo "Error: Maximum refresh attempts ($MAX_REFRESH_ATTEMPTS) reached" >&2
        return 1
    fi
    
    echo "Refreshing GitHub authentication (attempt $REFRESH_ATTEMPTS/$MAX_REFRESH_ATTEMPTS)..."
    
    if gh auth refresh -s project -s repo; then
        echo "✓ Authentication refreshed successfully"
        # Recursively check scopes again
        check_auth_scopes
        return $?
    else
        echo "Error: Failed to refresh authentication" >&2
        return 1
    fi
}

# Safe command execution function
execute_command() {
    local cmd=("$@")
    
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would execute: ${cmd[*]}"
        return 0
    fi
    
    echo "Executing: ${cmd[*]}"
    "${cmd[@]}"
}

# Build project field creation command array
build_project_field_cmd() {
    local field_name="$1"
    local field_type="$2"
    local project_owner="$3"
    local project_number="$4"
    
    # Validate inputs
    if [[ -z "$field_name" || -z "$field_type" || -z "$project_owner" || -z "$project_number" ]]; then
        echo "Error: Missing required parameters for project field creation" >&2
        return 1
    fi
    
    # Build command array safely (no eval needed)
    local cmd=(
        "gh"
        "project"
        "field-create"
        "$project_owner/$project_number"
        "--name"
        "$field_name"
        "--data-type"  # Fixed: replaced invalid --type with --data-type
        "$field_type"
    )
    
    # Return command array (caller handles execution)
    printf '%s\n' "${cmd[@]}"
}

# Create a project field with safe command construction
create_project_field() {
    local field_name="$1"
    local field_type="$2"
    local project_owner="$3"
    local project_number="$4"
    
    echo "Creating project field: $field_name ($field_type)"
    
    # Build command array using helper
    local cmd_array
    if ! cmd_array=$(build_project_field_cmd "$field_name" "$field_type" "$project_owner" "$project_number"); then
        return 1
    fi
    
    # Convert to array and execute
    local cmd=()
    while IFS= read -r line; do
        cmd+=("$line")
    done <<< "$cmd_array"
    
    execute_command "${cmd[@]}"
}

# Validate required parameters
validate_parameters() {
    local errors=()
    
    if [[ -z "$PROJECT_OWNER" ]]; then
        errors+=("--project-owner is required")
    fi
    
    if [[ -z "$PROJECT_NUMBER" ]]; then
        errors+=("--project-number is required")
    fi
    
    if [[ ${#errors[@]} -gt 0 ]]; then
        echo "Error: Missing required parameters:" >&2
        printf "  %s\n" "${errors[@]}" >&2
        echo >&2
        show_help >&2
        return 1
    fi
    
    return 0
}

# Main function (only runs if script is executed, not sourced)
main() {
    echo "GitHub Projects Update Script (Hardened Version)"
    echo "================================================"
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Validate parameters
    if ! validate_parameters; then
        exit 1
    fi
    
    # Check authentication and scopes
    if ! check_auth_scopes; then
        echo "Error: Authentication/scope check failed" >&2
        exit 1
    fi
    
    # Example project field creation
    echo "Creating example project fields..."
    
    # Create some example fields (customize as needed)
    create_project_field "Priority" "text" "$PROJECT_OWNER" "$PROJECT_NUMBER"
    create_project_field "Status" "text" "$PROJECT_OWNER" "$PROJECT_NUMBER"
    create_project_field "Assignee" "text" "$PROJECT_OWNER" "$PROJECT_NUMBER"
    
    echo "✓ Project update completed successfully"
}

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi