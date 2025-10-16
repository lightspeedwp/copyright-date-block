# Single Block WP Plugin — Primary Agent

- **Agent:** `wp-block-build-agent.js`
- **Workflow:** `.github/workflows/block-build-and-e2e.yml`
- **Purpose:** Automate a common, repeatable quality task for this repository type.
- **Usage:**
  - GitHub Actions: see the workflow file for triggers and env.
  - Local: `node .github/agents/wp-block-build-agent.js`
- **Environment variables:**
  - `DRY_RUN` (default: `false`), `VERBOSE` (default: `false`)
  - Additional secrets per workflow (e.g. `GITHUB_TOKEN` for label ops).
- **Maintenance:** Keep the agent aligned with repo tooling (linters, build, tests).
