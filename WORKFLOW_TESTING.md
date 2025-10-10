# Workflow Testing Instructions

This document provides steps to manually test and validate the GitHub Actions workflows in this repository.

## 1. Release on Tag Workflow

### Trigger: Release on Tag

- Push a tag matching the pattern `v*.*.*` (e.g., `v0.1.0`).

### Steps: Release on Tag

1. Create a new tag locally:

   ```bash
   git tag v0.1.1
   git push origin v0.1.1
   ```

2. Verify the workflow runs successfully in the Actions tab.
3. Check that the release is created with the correct assets (e.g., `copyright-date-block.zip`).

## 2. Release Drafter Workflow

### Trigger: Release Drafter

- Push to the `main` branch.
- Manually trigger via "Workflow Dispatch" in the Actions tab.

### Steps: Release Drafter

1. Push a commit to `main`:

   ```bash
   git checkout main
   git commit --allow-empty -m "Test release drafter"
   git push origin main
   ```

2. Verify the draft release is updated with categorized PRs.
3. Manually trigger the workflow:
   - Go to the Actions tab.
   - Select "Generate changelog and draft release (Product)".
   - Click "Run workflow".

## 3. CI Workflow

### Trigger: CI

- Push to `main` or `master`.
- Open a pull request targeting `main` or `master`.

### Steps: CI

1. Push a commit to `main` or `master`:

   ```bash
   git checkout main
   git commit --allow-empty -m "Test CI workflow"
   git push origin main
   ```

2. Open a pull request:
   - Create a new branch:

     ```bash
     git checkout -b test-ci
     git commit --allow-empty -m "Test CI workflow on PR"
     git push origin test-ci
     ```

   - Open a pull request targeting `main`.
3. Verify the workflow runs successfully and all steps pass.

## 4. Labeler Workflow

### Trigger: Labeler

- Open or synchronize a pull request.
- Open or edit an issue.

### Steps: Labeler

1. Open a new pull request:

   ```bash
   git checkout -b test-labeler
   git commit --allow-empty -m "Test labeler workflow"
   git push origin test-labeler
   ```

   - Open a pull request targeting `main`.
2. Verify that labels are applied based on file paths and branch names.
3. Open a new issue and verify default labels are applied.

## Notes

- Ensure you have appropriate permissions to trigger workflows.
- Use the Actions tab to monitor workflow runs and debug failures.
- For dry-run tests, use empty commits to avoid affecting the repository state.