# Agent Template

Use this template to document and implement agents in `.github/agents/`.

## Agent Name
- **Purpose:** What it automates for this repo type.
- **Location:** `.github/agents/agent-name.js`
- **Integration:** GitHub Actions workflow(s)
- **Usage:**
  - `node .github/agents/agent-name.js`
  - Required env vars (e.g. `GITHUB_TOKEN`, `DRY_RUN`, `VERBOSE`)
- **Maintenance:**
  - How to test locally and in CI
  - Known limitations and troubleshooting

## Checklist
- [ ] Documented in `AGENTS.md`
- [ ] Added example workflow
- [ ] Supports `DRY_RUN` and clear logs
