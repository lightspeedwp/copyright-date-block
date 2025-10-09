#!/bin/bash

# Script to manage GitHub Projects integration
# This script provides utilities to create project fields and manage GitHub Projects
# with enhanced security and functionality.

set -euo pipefail

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly MAX_REFRESH_ATTEMPTS=3

# Default values
PROJECT_OWNER=""
PROJECT_NUMBER=""
DRY_RUN=false
AUTO_REFRESH=false
HELP=false

# Authentication scope tracking
REFRESH_ATTEMPTS=0

# Function to display usage information
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

GitHub Projects management script with enhanced security features.

OPTIONS:
    --project-owner OWNER    GitHub organization or user owning the project
    --project-number NUM     Project number (visible in project URL)
    --dry-run               Print commands without executing them
    --auto-refresh          Automatically refresh authentication if needed
    --help                  Show this help message

EXAMPLES:
    $0 --project-owner myorg --project-number 1 --dry-run
    $0 --project-owner myorg --project-number 1 --auto-refresh

REQUIRED SCOPES:
    This script requires GitHub CLI authentication with the following scopes:
    - read:project
    - write:project
    - read:org (if using organization projects)

    Run 'gh auth refresh --scopes "read:project,write:project,read:org"' to update scopes.

EOF
}

# Function to check authentication and scopes
check_auth_scopes() {
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY-RUN] Skipping authentication and scope checks"
        return 0
    fi

    echo "Checking GitHub CLI authentication and scopes..."
    
    # Check if gh is installed and authenticated
    if ! command -v gh >/dev/null 2>&1; then
        echo "Error: GitHub CLI (gh) is not installed or not in PATH" >&2
        return 1
    fi

    # Use gh api to check authentication and get token info
    if ! gh api -I / >/dev/null 2>&1; then
        echo "Error: GitHub CLI is not authenticated" >&2
        echo "Please run: gh auth login" >&2
        return 1
    fi

    # Check available scopes by examining headers from API call
    local scope_check
    if ! scope_check=$(gh api -I /user 2>&1); then
        echo "Error: Failed to check authentication scopes" >&2
        return 1
    fi

    # Extract scopes from X-OAuth-Scopes header
    local current_scopes
    current_scopes=$(echo "$scope_check" | grep -i "x-oauth-scopes:" | cut -d: -f2- | tr ',' '\n' | sed 's/^ *//' | tr '\n' ' ')
    
    if [[ -z "$current_scopes" ]]; then
        echo "Warning: Could not determine current OAuth scopes"
        if [[ "$AUTO_REFRESH" == true ]]; then
            attempt_scope_refresh
            return $?
        else
            echo "Consider running with --auto-refresh or manually refresh scopes"
            return 1
        fi
    fi

    echo "Current scopes: $current_scopes"
    
    # Check for required scopes (basic check)
    local required_scopes=("repo" "read:project" "write:project")
    local missing_scopes=()
    
    for scope in "${required_scopes[@]}"; do
        if [[ "$current_scopes" != *"$scope"* ]]; then
            missing_scopes+=("$scope")
        fi
    done
    
    if [[ ${#missing_scopes[@]} -gt 0 ]]; then
        echo "Missing required scopes: ${missing_scopes[*]}"
        if [[ "$AUTO_REFRESH" == true ]]; then
            attempt_scope_refresh
            return $?
        else
            echo "Please run: gh auth refresh --scopes \"read:project,write:project,read:org\""
            return 1
        fi
    fi
    
    echo "✓ Authentication and scopes verified"
    return 0
}

# Function to attempt scope refresh with retry limit
attempt_scope_refresh() {
    ((REFRESH_ATTEMPTS++))
    
    if [[ $REFRESH_ATTEMPTS -gt $MAX_REFRESH_ATTEMPTS ]]; then
        echo "Error: Maximum refresh attempts ($MAX_REFRESH_ATTEMPTS) exceeded" >&2
        echo "Please manually refresh authentication scopes" >&2
        return 1
    fi
    
    echo "Attempting to refresh authentication scopes (attempt $REFRESH_ATTEMPTS/$MAX_REFRESH_ATTEMPTS)..."
    
    if gh auth refresh --scopes "read:project,write:project,read:org"; then
        echo "✓ Scopes refreshed successfully"
        # Recursively check scopes after refresh
        check_auth_scopes
        return $?
    else
        echo "Failed to refresh scopes" >&2
        return 1
    fi
}

# Function to safely execute commands
execute_command() {
    local cmd_array=("$@")
    
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY-RUN] Would execute: ${cmd_array[*]}"
        return 0
    fi
    
    echo "Executing: ${cmd_array[*]}"
    "${cmd_array[@]}"
}

# Helper function to build project field creation command
build_project_field_cmd() {
    local field_name="$1"
    local field_type="$2"
    local project_owner="$3"
    local project_number="$4"
    
    local cmd_array=(
        "gh" "project" "field-create"
        "--owner" "$project_owner"
        "--data-type" "$field_type"
        "--name" "$field_name"
        "$project_number"
    )
    
    echo "${cmd_array[@]}"
}

# Function to create a project field using secure command execution
create_project_field() {
    local field_name="$1"
    local field_type="$2"
    
    if [[ -z "$PROJECT_OWNER" || -z "$PROJECT_NUMBER" ]]; then
        echo "Error: PROJECT_OWNER and PROJECT_NUMBER must be set" >&2
        return 1
    fi
    
    echo "Creating project field: $field_name (type: $field_type)"
    
    # Build command array using helper
    local cmd_string
    cmd_string=$(build_project_field_cmd "$field_name" "$field_type" "$PROJECT_OWNER" "$PROJECT_NUMBER")
    
    # Convert string back to array for execution
    local cmd_array
    read -ra cmd_array <<< "$cmd_string"
    
    execute_command "${cmd_array[@]}"
}

# Parse command line arguments
parse_args() {
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
                HELP=true
                shift
                ;;
            *)
                echo "Unknown option: $1" >&2
                show_help
                exit 1
                ;;
        esac
    done
}

# Main execution function
main() {
    parse_args "$@"
    
    if [[ "$HELP" == true ]]; then
        show_help
        exit 0
    fi
    
    echo "GitHub Projects Management Script"
    echo "================================="
    
    if [[ "$DRY_RUN" == true ]]; then
        echo "🔍 DRY-RUN MODE: Commands will be printed but not executed"
    fi
    
    # Check authentication and scopes
    if ! check_auth_scopes; then
        echo "❌ Authentication or scope check failed" >&2
        exit 1
    fi
    
    # Example usage - create a sample field (this would be customized based on needs)
    if [[ -n "$PROJECT_OWNER" && -n "$PROJECT_NUMBER" ]]; then
        echo "Project: $PROJECT_OWNER/$PROJECT_NUMBER"
        
        # Example field creation (commented out to avoid unintended execution)
        # create_project_field "Priority" "SINGLE_SELECT"
        # create_project_field "Status" "SINGLE_SELECT"
        
        echo "✅ Script completed successfully"
    else
        echo "ℹ️  No project specified. Use --project-owner and --project-number to specify a project."
        echo "   Run with --help for more information."
    fi
}

# Guard against sourcing - only run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi