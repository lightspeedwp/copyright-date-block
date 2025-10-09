# Scripts Directory

This directory contains utility scripts for managing GitHub Projects integration and testing.

## Scripts

### update-projects.sh

A hardened utility script for managing GitHub Projects with enhanced security and functionality.

#### Required Scopes

This script requires GitHub CLI authentication with the following OAuth scopes:
- `read:project` - Read access to GitHub Projects
- `write:project` - Write access to GitHub Projects  
- `read:org` - Read access to organization information (for organization projects)

To refresh your authentication with the required scopes:
```bash
gh auth refresh --scopes "read:project,write:project,read:org"
```

#### Usage

```bash
# Basic usage with dry-run to see what commands would be executed
./scripts/update-projects.sh --project-owner myorg --project-number 1 --dry-run

# Execute with automatic scope refresh if needed
./scripts/update-projects.sh --project-owner myorg --project-number 1 --auto-refresh

# Show help information
./scripts/update-projects.sh --help
```

#### Command Line Options

| Flag | Description | Example |
|------|-------------|---------|
| `--project-owner` | GitHub organization or user owning the project | `--project-owner lightspeedwp` |
| `--project-number` | Project number (visible in project URL) | `--project-number 1` |
| `--dry-run` | Print commands without executing them | `--dry-run` |
| `--auto-refresh` | Automatically refresh authentication if needed | `--auto-refresh` |
| `--help` | Show help message and exit | `--help` |

#### Security Features

- **No eval usage**: Commands are built as arrays and executed directly to prevent command injection
- **Scope validation**: Checks OAuth scopes before execution
- **Dry-run mode**: Safe testing without making actual changes
- **Retry limits**: Prevents infinite recursion when refreshing authentication
- **Input validation**: Validates required parameters before execution

#### Examples

Create project fields (customize the main function as needed):
```bash
# Test what commands would be executed
./scripts/update-projects.sh --project-owner lightspeedwp --project-number 1 --dry-run

# Execute with automatic authentication refresh
./scripts/update-projects.sh --project-owner lightspeedwp --project-number 1 --auto-refresh
```

## Test Harnesses

### test-create-project-field.sh

A test harness that sources the main script without executing it, allowing inspection of the built commands and dry-run testing.

```bash
./scripts/test-create-project-field.sh
```

This test:
1. Sources `update-projects.sh` without running the main function
2. Tests the `build_project_field_cmd` helper function
3. Runs the script in dry-run mode to display commands

### test-dry-run.sh

A simple test harness for validating dry-run functionality.

```bash
./scripts/test-dry-run.sh
```

### __tests__/update-projects.bats

Bats (Bash Automated Testing System) tests for comprehensive script testing.

```bash
# Install bats if not available
npm install -g bats

# Run bats tests
bats scripts/__tests__/update-projects.bats
```

## Development

When modifying these scripts:

1. **Test with dry-run first**: Always use `--dry-run` to verify commands before execution
2. **Update tests**: Ensure test harnesses cover new functionality
3. **Security review**: Avoid `eval` and validate all inputs
4. **Documentation**: Update this README when adding new features

## Troubleshooting

### Authentication Issues

```bash
# Check current authentication status
gh auth status

# Login if not authenticated
gh auth login

# Refresh scopes if missing permissions
gh auth refresh --scopes "read:project,write:project,read:org"
```

### Common Errors

- **"GitHub CLI is not authenticated"**: Run `gh auth login`
- **"Missing required scopes"**: Run the refresh command above or use `--auto-refresh`
- **"Unknown option"**: Check the `--help` output for valid flags

### Debug Mode

For additional debugging, run with bash debug mode:
```bash
bash -x ./scripts/update-projects.sh --help
```