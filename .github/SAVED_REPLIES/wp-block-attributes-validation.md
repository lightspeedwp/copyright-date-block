---
title: Block attributes & validation
category: wordpress
updated: 2025-10-13
---
> For Gutenberg blocks, ensure:
> - `block.json` includes `attributes` with sane defaults
> - Save and edit functions are in sync to avoid invalidation
> - Editor assets are registered/enqueued via `@wordpress/scripts`
>
> If you see “This block contains unexpected or invalid content”, it’s usually a mismatch between `save` output and saved markup.
