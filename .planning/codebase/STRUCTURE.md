# Codebase Structure

**Analysis Date:** 2026-04-12

## Directory Layout

```
harness-writing/
├── .agents/                    # Local skill source (symlink target for npm)
├── .claude/                    # Claude Code configuration
│   └── commands/              # Slash command definitions
├── .github/                   # GitHub workflows and prompts
├── .planning/                 # Planning documents (this directory)
│   └── codebase/              # Codebase analysis docs
├── docs/                      # Documentation assets
├── manuscripts/               # Active paper projects
├── scripts/                   # Build and utility scripts
├── skills/                    # Published skills (npm install target)
├── templates/                 # LaTeX templates
│   └── elsevier/              # Elsevier journal template
├── corpus/                    # Academic phrase collection (gitkeep)
├── drafts/                    # Working drafts (gitkeep)
├── figures/                   # Paper figures (gitkeep)
├── .gitignore
├── CLAUDE.md                  # AI assistant guidance
├── Makefile                   # LaTeX compilation rules
├── README.md                  # Project documentation
├── mkdocs.yml                # Documentation site config
├── opencode.json             # OpenCode plugin config
└── package.json              # npm package manifest
```

## Directory Purposes

**.agents/ (Local Skills Source):**
- Purpose: Original location for skills before npm packaging
- Contains: Full skill directories with SKILL.md, agents/, references/, scripts/
- Note: `skills/` is populated from this via npm install; `.agents` is the dev source

**.claude/commands/ (Command Definitions):**
- Purpose: Map slash commands to skill invocations
- Contains: `newpaper.md`, `outline.md`, `write.md`, `review.md`, `cite.md`, `figure.md`, `preview.md`, `branch.md`, `commit.md`, `skill-create.md`
- Pattern: Each command file invokes a specific skill by name

**manuscripts/ (Paper Projects):**
- Purpose: Working directory for active paper writing
- Contains: Per-paper subdirectories with `project.yaml`, LaTeX files, references
- Structure per paper:
  ```
  manuscripts/[paper-name]/
  ├── project.yaml       # Metadata (title, authors, journal, section status)
  ├── outline.md        # Generated IMRAD outline
  ├── main.tex          # Main document (includes sections/)
  ├── references.bib    # Bibliography
  └── sections/
      ├── abstract.tex
      ├── introduction.tex
      ├── methodology.tex
      ├── results.tex
      ├── discussion.tex
      └── conclusion.tex
  ```

**scripts/ (Utility Scripts):**
- Purpose: Build and installation scripts
- Contains: `install-skill-links.js` (postinstall hook for symlinking)

**skills/ (Published Skills):**
- Purpose: Packaged skills for npm distribution
- Contains: 29 skills including:
  - `academic-review/` - Dual-agent critique system
  - `figure-integrator/` - PlantUML/Graphviz figure generation
  - `latex-paper-en/` - Elsevier LaTeX section writing
  - `latex-live-preview/` - Real-time PDF preview
  - `literature-manager/` - Citation management
  - `paper-outline-generator/` - IMRAD structure generation
  - `research-paper-writer/` - End-to-end orchestration
  - `zotero-context-injector/` - Zotero PDF import
  - Plus git workflow skills, superpowers, and tool creation skills
- Structure per skill:
  ```
  skills/[skill-name]/
  ├── SKILL.md           # Main skill file (required)
  ├── agents/            # Sub-agent prompts (optional)
  ├── references/        # Reference documentation (optional)
  └── scripts/           # Helper scripts (optional)
  ```

**templates/elsevier/ (LaTeX Template):**
- Purpose: Elsevier journal article template
- Contains:
  - `main.tex` - Document class and structure
  - `references.bib` - Sample bibliography
  - `sections/` - Section templates (abstract, introduction, methodology, results, discussion, conclusion)
- Usage: Copy to `manuscripts/[paper-name]/` to start new project

**.github/ (GitHub Integration):**
- Purpose: CI/CD workflows and custom prompts
- Contains:
  - `workflows/ci.yml` - GitHub Actions configuration
  - `prompts/` - Custom prompt templates

## Key File Locations

**Entry Points:**
- `.claude/commands/newpaper.md` - `/newpaper` command
- `.claude/commands/outline.md` - `/outline` command
- `.claude/commands/write.md` - `/write` command
- `.claude/commands/review.md` - `/review` command
- `.claude/commands/preview.md` - `/preview` command

**Configuration:**
- `package.json` - npm package manifest, scripts, dependencies
- `Makefile` - LaTeX compilation targets
- `mkdocs.yml` - Documentation site configuration
- `opencode.json` - OpenCode plugin configuration
- `.claude/settings.local.json` - Local Claude settings

**Core Orchestration:**
- `skills/research-paper-writer/SKILL.md` - Main workflow orchestrator
- `skills/paper-outline-generator/SKILL.md` - IMRAD structure generator
- `skills/latex-paper-en/SKILL.md` - Section writer with Elsevier format
- `skills/academic-review/SKILL.md` - Dual-agent critique system

**LaTeX Template:**
- `templates/elsevier/main.tex` - Elsevier document template
- `templates/elsevier/references.bib` - Sample BibTeX entries
- `templates/elsevier/sections/*.tex` - Section templates

**Project Metadata:**
- `manuscripts/[paper-name]/project.yaml` - Paper metadata and section status

## Naming Conventions

**Files:**
- Skills: `SKILL.md` (uppercase)
- Commands: `lower-case.md` (kebab-case)
- LaTeX sections: `section-name.tex` (kebab-case)
- Scripts: `kebab-case.ext` or `camelCase.ext`
- YAML configs: `kebab-case.yaml` or `camelCase.json`

**Directories:**
- Skills: `kebab-case` (e.g., `latex-paper-en`, `academic-review`)
- Papers: `kebab-case` derived from paper title
- Commands: `lower-case` (e.g., `.claude/commands/`)

**Git Branches (via git-flow-branch-creator):**
- Pattern: `feature/paper-[slug]` or `feature/paper-[paper-title-kebab]`

## Where to Add New Code

**New Skill:**
1. Create in `.agents/skills/[skill-name]/` (local dev source)
2. Include `SKILL.md` with frontmatter (name, description, triggers)
3. Add `agents/`, `references/`, `scripts/` as needed
4. Package and publish to npm for distribution

**New Paper Project:**
1. Create branch: `git flow feature start paper-[slug]`
2. Copy template: `cp -r templates/elsevier manuscripts/[paper-name]`
3. Create `project.yaml` with metadata
4. Initialize `references.bib`

**New Command:**
1. Create `.claude/commands/[name].md`
2. Include frontmatter with description
3. Add skill invocation directive
4. Document trigger phrases

**New LaTeX Section Template:**
1. Add to `templates/elsevier/sections/[section].tex`
2. Include section structure and placeholder content
3. Document in `skills/latex-paper-en/references/elsevier-format.md`

## Special Directories

**manuscripts/ (Git-ignored working state):**
- Purpose: Active paper projects
- Generated: Yes (by `/newpaper` command)
- Committed: Yes (via git, typically on paper-specific branch)

**skills/ (npm package content):**
- Purpose: Published skill packages
- Generated: Yes (via npm install from .agents)
- Committed: No (derived from .agents, listed in .gitignore)

**.agents/skills/ (Local skill source):**
- Purpose: Development source for skills
- Generated: No
- Committed: Yes (source of truth for skills)

**.planning/codebase/ (Analysis Output):**
- Purpose: Architecture and structure documentation
- Generated: Yes (by gsd-codebase-mapper)
- Committed: Yes (for planner/executor consumption)

---

*Structure analysis: 2026-04-12*
