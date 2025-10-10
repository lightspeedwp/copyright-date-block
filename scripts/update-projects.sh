#!/bin/bash

# GitHub Projects Field Update Script
# 
# This script helps manage GitHub project fields using the GitHub CLI.
# It can create, update, and manage project fields with proper authentication.
#
# Requirements:
# - GitHub CLI (gh) installed and authenticated
# - Appropriate scopes: repo, project, read:org, read:user
#
# Usage:
#   ./update-projects.sh [OPTIONS]
#
# Options:
#   --project-owner <org>     Override project owner (default: auto-detect)
#   --project-number <num>    Override project number (default: auto-detect)
#   --auto-refresh           Interactively refresh GitHub CLI scopes if needed
#   --dry-run               Print commands instead of executing them
#   --help                  Show this help message

set -euo pipefail

# Default values
PROJECT_OWNER=""
PROJECT_NUMBER=""
AUTO_REFRESH=false
DRY_RUN=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

<<<<<<< Updated upstream
# Required GitHub CLI scopes
REQUIRED_SCOPES=("repo" "project" "read:org" "read:user")

=======
<<<<<<< Updated upstream
# Usage message
=======
# Required GitHub CLI scopes
REQUIRED_SCOPES=("repo" "project" "read:org" "read:user")

# Max attempts when trying to refresh scopes interactively to avoid infinite loops
MAX_REFRESH_ATTEMPTS=2

>>>>>>> Stashed changes
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Show help message
<<<<<<< Updated upstream
=======
>>>>>>> Stashed changes
>>>>>>> Stashed changes
show_help() {
    cat << EOF
GitHub Projects Field Update Script

This script helps manage GitHub project fields using the GitHub CLI.

Usage:
  $0 [OPTIONS]

Options:
  --project-owner <org>     Override project owner (default: auto-detect)
  --project-number <num>    Override project number (default: auto-detect)
  --auto-refresh           Interactively refresh GitHub CLI scopes if needed
  --dry-run               Print commands instead of executing them
  --help                  Show this help message

Examples:
  $0 --dry-run                                    # Preview commands
  $0 --project-owner myorg --project-number 1    # Use specific project
  $0 --auto-refresh                              # Refresh scopes if needed

Requirements:
  - GitHub CLI (gh) installed and authenticated
  - Appropriate scopes: repo, project, read:org, read:user

EOF
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
            --auto-refresh)
                AUTO_REFRESH=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Check if GitHub CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) is not installed. Please install it first."
        log_info "Visit: https://cli.github.com/manual/installation"
        exit 1
    fi
    
    log_success "GitHub CLI found: $(gh --version | head -n1)"
}

# Check GitHub CLI authentication status
check_gh_auth() {
    log_info "Checking GitHub CLI authentication..."
    
    if ! gh auth status &> /dev/null; then
        log_error "GitHub CLI is not authenticated."
        log_info "Please run: gh auth login"
        exit 1
    fi
    
    log_success "GitHub CLI is authenticated"
}

# Get current GitHub CLI scopes using gh api
get_current_scopes() {
    log_info "Checking current GitHub CLI scopes..."
    
    # Use gh api to get current token info
    local scopes_response
    if ! scopes_response=$(gh api -I / 2>/dev/null); then
        log_error "Failed to get current scopes"
        return 1
    fi
<<<<<<< Updated upstream
=======

<<<<<<< Updated upstream
    # Extract scopes from response headers
    local scopes
    scopes=$(echo "$auth_response" | grep -i "x-oauth-scopes:" | cut -d' ' -f2- | tr -d '\r\n' || echo "")
=======
# Check if required scopes are present
check_required_scopes() {
    # Optional attempt counter to avoid infinite refresh loops
    local attempt="${1:-0}"
    local current_scopes
    current_scopes=$(get_current_scopes)
>>>>>>> Stashed changes
>>>>>>> Stashed changes
    
    # Extract scopes from X-OAuth-Scopes header
    local current_scopes
    current_scopes=$(echo "$scopes_response" | grep -i "x-oauth-scopes:" | cut -d: -f2 | sed 's/^ *//' | tr ',' '\n' | sed 's/^ *//;s/ *$//')
    
    echo "$current_scopes"
}

# Check if required scopes are present
check_required_scopes() {
    local current_scopes
    current_scopes=$(get_current_scopes)
    
    if [[ -z "$current_scopes" ]]; then
        log_error "Could not determine current scopes"
        return 1
    fi
    
    log_info "Current scopes: $(echo "$current_scopes" | tr '\n' ' ')"
    
    local missing_scopes=()
    for scope in "${REQUIRED_SCOPES[@]}"; do
        if ! echo "$current_scopes" | grep -q "^${scope}$"; then
            missing_scopes+=("$scope")
        fi
    done
    
    if [[ ${#missing_scopes[@]} -gt 0 ]]; then
<<<<<<< Updated upstream
        log_warning "Missing required scopes: ${missing_scopes[*]}"
        
        if [[ "$AUTO_REFRESH" == true ]]; then
            refresh_gh_scopes "${missing_scopes[@]}"
=======
<<<<<<< Updated upstream
        echo "Missing required scopes: ${missing_scopes[*]}" >&2
        if [[ "$AUTO_REFRESH" == true && $REFRESH_ATTEMPTS -lt $MAX_REFRESH_ATTEMPTS ]]; then
            echo "Attempting to refresh authentication..."
            refresh_auth
            return $?
=======
        log_warning "Missing required scopes: ${missing_scopes[*]}"

        if [[ "$AUTO_REFRESH" == true ]]; then
            # Pass the current attempt count to refresh_gh_scopes so it can guard retries
            refresh_gh_scopes "$attempt" "${missing_scopes[@]}"
>>>>>>> Stashed changes
>>>>>>> Stashed changes
        else
            log_error "Required scopes are missing. Use --auto-refresh to fix this automatically."
            log_info "Or run manually: gh auth refresh -s $(IFS=,; echo "${REQUIRED_SCOPES[*]}")"
            return 1
        fi
    else
        log_success "All required scopes are present"
    fi
}

# Refresh GitHub CLI scopes interactively
refresh_gh_scopes() {
    local missing_scopes=("$@")
    
    log_info "Refreshing GitHub CLI scopes..."
    log_info "Missing scopes: ${missing_scopes[*]}"
    
    read -p "Do you want to refresh scopes now? [y/N]: " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Refreshing scopes: ${REQUIRED_SCOPES[*]}"
        
        if gh auth refresh -s "$(IFS=,; echo "${REQUIRED_SCOPES[*]}")"; then
            log_success "Scopes refreshed successfully"
            
            # Re-check scopes
            if check_required_scopes; then
                log_success "All required scopes are now available"
            else
                log_error "Scope refresh failed"
                return 1
            fi
        else
            log_error "Failed to refresh scopes"
            return 1
        fi
    else
        log_error "Scope refresh declined. Cannot continue without required scopes."
        return 1
    fi
}

# Auto-detect project owner from current repository
detect_project_owner() {
    if [[ -n "$PROJECT_OWNER" ]]; then
        log_info "Using provided project owner: $PROJECT_OWNER"
        return
    fi
    
    log_info "Auto-detecting project owner..."
    
    # Try to get owner from git remote
    if git rev-parse --git-dir &> /dev/null; then
        local remote_url
        remote_url=$(git remote get-url origin 2>/dev/null || echo "")
        
        if [[ -n "$remote_url" ]]; then
            # Extract owner from GitHub URL
            if [[ "$remote_url" =~ github\.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
                PROJECT_OWNER="${BASH_REMATCH[1]}"
                log_success "Detected project owner from git remote: $PROJECT_OWNER"
            else
                log_warning "Could not parse GitHub URL from git remote: $remote_url"
            fi
        fi
    fi
    
<<<<<<< Updated upstream
    # If still no owner, try to get from gh CLI
    if [[ -z "$PROJECT_OWNER" ]]; then
        if command -v gh &> /dev/null && gh auth status &> /dev/null; then
            PROJECT_OWNER=$(gh api user --jq .login 2>/dev/null || echo "")
            if [[ -n "$PROJECT_OWNER" ]]; then
                log_info "Using authenticated user as project owner: $PROJECT_OWNER"
            fi
        fi
    fi
    
=======
    echo "✓ Authentication and scopes verified"
    return 0
}

<<<<<<< Updated upstream
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
=======
# Refresh GitHub CLI scopes interactively
refresh_gh_scopes() {
    # First arg is the current attempt counter
    local attempt="${1:-0}"
    shift || true
    local missing_scopes=("$@")

    log_info "Refreshing GitHub CLI scopes..."
    log_info "Missing scopes: ${missing_scopes[*]}"

    # Determine next attempt count and enforce max attempts
    local next_attempt=$((attempt + 1))
    if [[ $next_attempt -gt $MAX_REFRESH_ATTEMPTS ]]; then
        log_error "Maximum scope refresh attempts ($MAX_REFRESH_ATTEMPTS) reached. Aborting."
        return 1
    fi

    read -p "Do you want to refresh scopes now? [y/N]: " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Refreshing scopes: ${REQUIRED_SCOPES[*]} (attempt $next_attempt of $MAX_REFRESH_ATTEMPTS)"

        if gh auth refresh -s "$(IFS=,; echo "${REQUIRED_SCOPES[*]}")"; then
            log_success "Scopes refreshed successfully"

            # Re-check scopes, passing the incremented attempt counter to avoid infinite recursion
            if check_required_scopes "$next_attempt"; then
                log_success "All required scopes are now available"
            else
                log_error "Scope refresh failed after attempt $next_attempt"
                return 1
            fi
        else
            log_error "Failed to refresh scopes"
            return 1
        fi
>>>>>>> Stashed changes
    else
        echo "Error: Failed to refresh authentication" >&2
        return 1
    fi
}

# Safe command execution function
execute_command() {
<<<<<<< Updated upstream
    local cmd=("$@")
    
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would execute: ${cmd[*]}"
        return 0
=======
    # Usage: execute_command "Description" cmd arg1 arg2 ...
    local description="$1"
    shift || true

    if [[ -n "$description" ]]; then
        log_info "$description"
    fi

    if [[ "$DRY_RUN" == true ]]; then
        # Print the command safely
        local cmd_str
        printf -v cmd_str '%q ' "$@"
        echo -e "${YELLOW}[DRY-RUN]${NC} $cmd_str"
    else
        log_info "Executing: $*"
        # Execute command without eval to avoid injection; use "${@}" expansion
        "$@"
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
    local field_type="${2:-text}"
    shift 2 || true
    # Remaining args are additional gh flags/values (e.g. --options "A,B,C")
    local field_args=("$@")

    # Build command array using helper so tests can inspect it
    mapfile -t cmd < <(build_project_field_cmd "$field_name" "$field_type" "${field_args[@]}")

    if [[ -n "$PROJECT_NUMBER" ]]; then
        cmd+=(--number "$PROJECT_NUMBER")
    fi

    cmd+=(--name "$field_name" --data-type "$field_type")

    if [[ ${#field_args[@]} -gt 0 ]]; then
        cmd+=("${field_args[@]}")
    fi

    execute_command "Creating project field: $field_name ($field_type)" "${cmd[@]}"
}

# Build the gh project field-create command as newline-separated tokens (for easy capture)
build_project_field_cmd() {
    local field_name="$1"
    local field_type="$2"
    shift 2 || true
    local field_args=("$@")

    local parts=(gh project field-create --owner "$PROJECT_OWNER")
    if [[ -n "$PROJECT_NUMBER" ]]; then
        parts+=(--number "$PROJECT_NUMBER")
    fi
    parts+=(--name "$field_name" --data-type "$field_type")
    if [[ ${#field_args[@]} -gt 0 ]]; then
        parts+=("${field_args[@]}")
    fi

    # Print each part on its own line so callers can read into an array
    for p in "${parts[@]}"; do
        printf '%s\n' "$p"
    done
>>>>>>> Stashed changes
}

# Validate required parameters
validate_parameters() {
    local errors=()
    
>>>>>>> Stashed changes
    if [[ -z "$PROJECT_OWNER" ]]; then
        log_error "Could not auto-detect project owner. Please use --project-owner option."
        exit 1
    fi
}

# Execute or preview command based on dry-run mode
execute_command() {
    local cmd="$1"
    local description="${2:-}"
    
    if [[ -n "$description" ]]; then
        log_info "$description"
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $cmd"
    else
        log_info "Executing: $cmd"
        eval "$cmd"
    fi
}

# Create a project field
create_project_field() {
    local field_name="$1"
    local field_type="${2:-text}"
    local field_options="${3:-}"
    
    local cmd="gh project field-create --owner \"$PROJECT_OWNER\""
    
    if [[ -n "$PROJECT_NUMBER" ]]; then
        cmd="$cmd --number \"$PROJECT_NUMBER\""
    fi
    
    cmd="$cmd --name \"$field_name\" --type \"$field_type\""
    
    if [[ -n "$field_options" ]]; then
        cmd="$cmd $field_options"
    fi
    
    execute_command "$cmd" "Creating project field: $field_name ($field_type)"
}

# Main function
main() {
    log_info "GitHub Projects Field Update Script"
    log_info "=================================="
    
    parse_args "$@"
    
<<<<<<< Updated upstream
    # Preliminary checks
    check_gh_cli
    check_gh_auth
    check_required_scopes
    
    # Project setup
    detect_project_owner
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Running in DRY-RUN mode - no actual changes will be made"
    fi
    
    # Example field creation (customize as needed)
    log_info "Creating example project fields..."
    
    create_project_field "Priority" "single_select" "--options \"High,Medium,Low\""
    create_project_field "Status" "single_select" "--options \"Todo,In Progress,Done\""
=======
<<<<<<< Updated upstream
    # Validate parameters
    if ! validate_parameters; then
        exit 1
    fi
    
    # Check authentication and scopes
    if ! check_auth_scopes; then
        echo "Error: Authentication/scope check failed" >&2
        exit 1
=======
    # Preliminary checks (skip when doing a dry-run)
    if [[ "$DRY_RUN" != true ]]; then
        check_gh_cli
        check_gh_auth
        check_required_scopes
    else
        log_info "Dry-run: skipping GitHub CLI checks (no network calls)"
    fi
    
    # Project setup
    detect_project_owner
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Running in DRY-RUN mode - no actual changes will be made"
    fi
    
    # Example field creation (customize as needed)
    log_info "Creating example project fields..."
    
    create_project_field "Priority" "single_select" --options "High,Medium,Low"
    create_project_field "Status" "single_select" --options "Todo,In Progress,Done"
>>>>>>> Stashed changes
    create_project_field "Assignee" "text"
    create_project_field "Due Date" "date"
    
    log_success "Script completed successfully!"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "This was a dry run. Use without --dry-run to execute commands."
<<<<<<< Updated upstream
=======
>>>>>>> Stashed changes
>>>>>>> Stashed changes
    fi
}

<<<<<<< Updated upstream
# Run main function with all arguments
main "$@"
=======
<<<<<<< Updated upstream
# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
=======
# If the script is executed (not sourced), run main
if [[ "${SKIP_MAIN:-0}" != "1" && "${BASH_SOURCE[0]}" == "${0}" ]]; then
>>>>>>> Stashed changes
    main "$@"
fi
>>>>>>> Stashed changes
