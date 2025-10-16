---
title: Fix WPCS/PHPCS findings
category: prs
updated: 2025-10-13
---
> CI flagged coding‑standard issues:
> - Run: `composer install && vendor/bin/phpcs` (auto‑fix with `phpcbf` where possible)
> - Ensure escaping/sanitisation for all output (`esc_html`, `wp_kses`, nonces for actions)
> - Add/adjust **PHPDoc** per our inline docs
>
> Update and push – happy to re‑check.
