# Ecosystem: Unified Developer Foundation

A unified hub for provisioning, configuring, and powering my personal development environment. This repository serves as the single source of truth for my infrastructure, workflows, and experimental projects.

## Project Structure

```text
.
├── infra/              # Infrastructure-as-Code & Provisioning
│   ├── brew/           # Homebrew formulas and tap sources
│   └── docker/          # Container images and environment configs
├── workflow/           # Productivity tools and snippets
│   └── pet/            # CLI Command Manager (Pet) Configuration
├── index.html          # Simple intro page (NES.css)
└── package.json        # Project metadata
```

## Branding & Purpose

This repository is designated as a **Personal Developer Runtime (PDR)**. The goal is to reach a state where cloning this repository onto a fresh OS provides a complete, ready-to-use development environment.

## Rules & Guidelines

- :fire: **Do not nest folders excessively.** Keep the category-based structure flat.
- :fire: **Avoid spaces in filenames.** Use hyphens or underscores.
- :fire: **Avoid dots in snippet names** to prevent escaping issues in tools like `nap`.
- :fire: **Do not sync within Codespaces** if it conflicts with local file synchronization patterns.

---

_Powered by [NES.css](https://nostalgic-css.github.io/NES.css/)_
