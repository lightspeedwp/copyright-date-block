# Scripts

This directory contains utility scripts for managing the Copyright Date Block project.

## update-projects.sh

A hardened script for updating GitHub projects with authentication scope checking and security improvements.

### Required Scopes

The script requires the following GitHub CLI authentication scopes:

- `project:read` - Read access to GitHub projects
- `project:write` - Write access to GitHub projects  
- `repo` - Repository access (if working with repository-linked projects)

### Usage

```bash
# Basic usage
./scripts/update-projects.sh --project-owner myorg --project-number 5

# Dry-run mode (preview commands without executing)
./scripts/update-projects.sh --project-owner myorg --project-number 5 --dry-run

# Auto-refresh authentication if scopes are missing
./scripts/update-projects.sh --project-owner myorg --project-number 5 --auto-refresh
```

### CLI Flags

| Flag | Description |
|------|-------------|
| `--project-owner OWNER` | GitHub project owner (username or organization) |
| `--project-number NUM` | GitHub project number |
| `--dry-run` | Print gh commands without executing them |
| `--auto-refresh` | Automatically attempt to refresh scopes |
| `--help` | Show help message |

### Security Features

- **No `eval` usage** - Commands are built as arrays and executed safely
- **Authentication scope checks** - Verifies required GitHub CLI scopes before execution
- **Dry-run mode** - Preview commands before execution
- **Command injection protection** - Safe parameter handling and command construction
- **Max refresh attempts** - Prevents infinite recursion when scopes cannot be obtained
- **Input validation** - Validates all required parameters

### Authentication Setup

1. Install GitHub CLI: `gh auth login`
2. Authenticate with required scopes:
   ```bash
   gh auth refresh -s project -s repo
   ```
3. Verify authentication: `gh auth status`

### Examples

```bash
# Preview what the script will do
./scripts/update-projects.sh --project-owner lightspeedwp --project-number 1 --dry-run

# Execute with automatic scope refresh if needed
./scripts/update-projects.sh --project-owner lightspeedwp --project-number 1 --auto-refresh

# Manual execution (will prompt for scope refresh if needed)
./scripts/update-projects.sh --project-owner lightspeedwp --project-number 1
```

## Test Harnesses

### test-dry-run.sh

Tests the dry-run functionality of `update-projects.sh`.

```bash
./scripts/test-dry-run.sh
```

### test-create-project-field.sh

A test harness that sources the script (without running main), inspects the built gh command, and runs the script in dry-run to display commands.

```bash
./scripts/test-create-project-field.sh
```

### __tests__/update-projects.bats

Minimal bats test for the update-projects script.

```bash
# Install bats if not available
npm install -g bats

# Run tests
bats scripts/__tests__/update-projects.bats
```

## Development

### Testing Changes

Always test script changes in dry-run mode first:

```bash
./scripts/update-projects.sh --project-owner test --project-number 1 --dry-run
```

### Security Considerations

- Never use `eval` for command construction
- Always validate input parameters
- Use array-based command construction to prevent injection
- Implement dry-run mode for testing
- Add authentication checks before making API calls

### Adding New Features

1. Follow the existing pattern of using command arrays
2. Add appropriate CLI flags with validation
3. Include dry-run support for new commands
4. Add tests for new functionality
5. Update this documentation
