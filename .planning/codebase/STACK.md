# Technology Stack

## Languages & Runtime

- **Node.js** (>=18.0.0) — skill automation, helper scripts
- **JavaScript (CommonJS)** — all scripts in `scripts/`
- **LaTeX** — paper writing and compilation
- **Markdown** — documentation, skill files

## Package Manager

- **npm** — dependency management, script runner
- `postinstall` hook auto-links skills via `scripts/install-skill-links.js`

## Key Dependencies

| Package | Purpose | Location |
|---------|---------|----------|
| `install-skill-links.js` | Symlinks skill folders into `.claude/skills/` | `scripts/` |

## Build & Task Tools

- **Make** — LaTeX compilation pipeline (`make paper`, `make quick`, `make clean`)
- **pdflatex + bibtex** — PDF generation with bibliography
- **pandoc** — LaTeX to Word conversion (`make word`)
- **PlantUML** — diagram generation (optional, `make update-figs`)
- **Graphviz** — DOT diagram processing (optional, `make update-figs`)

## Skill Framework

- **Claude Code Skills** — markdown-based prompts in `skills/[name]/SKILL.md`
- Skills auto-trigger via slash commands (/) or phrase matching
- Sub-agents in `.agents/skills/[name]/agents/`

## Editors & Tools

- **pdf-live-server** — Node.js-based live PDF preview server
- **Node polling** — file watching for live preview refresh

## File References

- `package.json` — npm package config
- `Makefile` — LaTeX build targets
- `scripts/install-skill-links.js` — skill symlink installer
