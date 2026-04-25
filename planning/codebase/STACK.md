# Technology Stack

**Analysis Date:** 2026-04-24

## Languages

**Primary:**
- JavaScript (CommonJS) - npm package automation and install/link scripts in `package.json` and `scripts/install-skill-links.js`
- Markdown - skill definitions and slash command routing in `skills/**/SKILL.md` and `.claude/commands/*.md`

**Secondary:**
- Python 3 - Zotero context extraction and PDF parsing tooling in `scripts/build_zotero_context.py` and `skills/zotero-context-injector/scripts/build_zotero_context.py`
- LaTeX - paper template and manuscript build target in `templates/elsevier/main.tex` and `Makefile`
- YAML - CI and docs site configuration in `.github/workflows/ci.yml` and `mkdocs.yml`
- Bash - preview/compile helper scripts in `skills/latex-live-preview/scripts/start-preview.sh`, `skills/latex-live-preview/scripts/stop-preview.sh`, and `skills/latex-paper-en/scripts/compile-check.sh`

## Runtime

**Environment:**
- Node.js >=18.0.0 (declared in `package.json` under `engines.node`)
- Python 3.x in CI (`actions/setup-python@v5` with `python-version: 3.x` in `.github/workflows/ci.yml`)

**Package Manager:**
- npm (package scripts and publish/install flow in `package.json`)
- Lockfile: missing (`pnpm-lock.yaml`, `package-lock.json`, and `yarn.lock` not detected in repository root)

## Frameworks

**Core:**
- GSDAW skill-based orchestration framework (skill catalog and command routes) - implemented in `skills/` and `.claude/commands/`
- Claude/OpenCode command surface - command entrypoints under `.claude/commands/*.md` and plugin config in `opencode.json`

**Testing:**
- No project test framework configured; `npm test` is a placeholder (`"No tests configured"`) in `package.json`

**Build/Dev:**
- GNU Make - build orchestration for LaTeX (`make paper`, `make quick`, `make word`) in `Makefile`
- LaTeX toolchain (`pdflatex`, `bibtex`) - document compilation in `Makefile` and `skills/latex-paper-en/scripts/compile-check.sh`
- MkDocs Material - docs site generation/deploy in `mkdocs.yml` and `.github/workflows/ci.yml`
- GitHub Actions - CI/CD execution in `.github/workflows/ci.yml`
- pdf-live-server (or Python HTTP fallback) - live PDF preview in `skills/latex-live-preview/scripts/start-preview.sh`

## Key Dependencies

**Critical:**
- `@2p1c/harness-writing` package definition - distributable artifact and skill bundle contract in `package.json`
- Node postinstall linker (`node scripts/install-skill-links.js`) - installs symlinks into user runtime directories (`~/.agents/skills`, `~/.claude/commands`) from `scripts/install-skill-links.js`
- TeX toolchain (`latexmk`, `pdflatex`, `bibtex`) - required for preview and final manuscript compilation in `skills/latex-live-preview/SKILL.md`, `skills/latex-paper-en/scripts/compile-check.sh`, and `Makefile`

**Infrastructure:**
- GitHub Actions runners (`ubuntu-latest`) - documentation deployment job in `.github/workflows/ci.yml`
- MkDocs Material Python package (`pip install mkdocs-material`) - static site build/deploy in `.github/workflows/ci.yml`
- Superpowers plugin (`superpowers@git+https://github.com/obra/superpowers.git`) - OpenCode plugin dependency in `opencode.json`
- Optional PDF extraction backends (`pdftotext` or `pypdf`) - Zotero ingestion pipeline in `scripts/build_zotero_context.py`

## Configuration

**Environment:**
- Node engine constraint set in `package.json` (`>=18.0.0`)
- Local tool permissions and MCP allowlist configured in `.claude/settings.local.json`
- No committed `.env` files detected in repository root; runtime secrets are expected via user environment variables when needed by skills

**Build:**
- `package.json` (npm scripts + package distribution manifest)
- `Makefile` (LaTeX build commands, figure processing, clean targets)
- `mkdocs.yml` (docs site settings)
- `.github/workflows/ci.yml` (CI deploy workflow)
- `opencode.json` (OpenCode plugin registration)

## Platform Requirements

**Development:**
- Node.js >=18 and npm (`package.json`)
- LaTeX distribution with `latexmk`/`pdflatex`/`bibtex` (`README.md`, `skills/latex-live-preview/SKILL.md`)
- Optional but supported: `pandoc`, `PlantUML`, `Graphviz`, `pdftotext` (`Makefile`, skill references)
- For Zotero workflows: local Zotero DB/storage paths and Python3 environment (`scripts/build_zotero_context.py`, `skills/zotero-context-injector/references/zotero-setup.md`)

**Production:**
- Package publication target: npm ecosystem (`package.json`)
- Documentation deployment target: GitHub Pages via `mkdocs gh-deploy --force` in `.github/workflows/ci.yml`

---

*Stack analysis: 2026-04-24*