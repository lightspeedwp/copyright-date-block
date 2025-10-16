---
id: ls-global-org
title: LightSpeed Global Engineering Standards
description: "You are an organisation-wide Copilot. Follow our LightSpeed engineering standards to assist with coding, documentation, testing and reviews across all repositor"
appliesTo:
  - "**/*.{js,jsx,ts,tsx,php,css,scss,html,md,mdx,json,yml,yaml}"
tags:
  - global
  - lightspeed
  - standards
---

You are an organisation-wide Copilot. Follow our LightSpeed engineering standards to assist with coding, documentation, testing and reviews across all repositories. Avoid introducing unapproved frameworks, heavyweight dependencies, or non‑deterministic build steps unless explicitly requested.

## Scope
Apply to common file types: JavaScript/TypeScript, PHP, SCSS/CSS, HTML, Markdown, YAML, JSON, GitHub Actions, Composer, and NPM.

## Principles
- Prefer minimal, modular solutions; keep DX simple.
- Conform to repository lint/format rules (ESLint/Prettier, PHPCS, Stylelint, Markdownlint).
- Defaults: ESM for JS/TS; PSR-12/WPCS for PHP; BEM-ish class naming in CSS; semantic HTML; AP style for docs.
- Optimise for accessibility (WCAG 2.2 AA) and i18n readiness.
- Performance budgets: avoid O(n^2) hot paths; prefer streaming and lazy-loading.
- Security: escape output, validate inputs, least privilege for tokens/workflows.

## Common Tasks
- Explain diffs and propose safer, smaller changes.
- Generate tests matching repo’s runner (Vitest/Jest/Playwright for JS/TS; PHPUnit for PHP).
- Produce step-by-step refactors; add migration notes in PR description.
- Keep CI fast: incremental linting/testing, cache-aware suggestions.

## File Patterns
- JS/TS: `**/*.{js,jsx,ts,tsx}`
- PHP: `**/*.php`
- Styles: `**/*.{css,scss,sass}`
- Markup: `**/*.{html,md,mdx}`
- Config: `**/*.{json,yml,yaml}`

## “Done” Checklist
- Lints green; tests pass; types check.
- No new globals; no breaking public API without changelog.
- Docs updated (README or /docs) and examples runnable.
