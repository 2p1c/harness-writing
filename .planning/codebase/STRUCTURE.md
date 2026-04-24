# Codebase Structure

**Analysis Date:** 2026-04-24

## Directory Layout

```
harness-writing/
├── .agents/skills/          # Alternate/source skill tree with agents/references/scripts
├── .claude/
│   ├── commands/            # Slash-command route files (init, write, review, etc.)
│   └── skills/              # Claude Code local skill definitions
├── .github/prompts/         # Prompt assets for GitHub tooling
├── .planning/               # GSDAW planning outputs and phase tracking
│   ├── codebase/           # Codebase mapping documents (ARCHITECTURE, STRUCTURE, etc.)
│   ├── phases/            # Phase plan artifacts
│   ├── research-brief.json
│   ├── literature.md
│   ├── methodology.md
│   ├── ROADMAP.md
│   ├── STATE.md
│   └── wave-plan.md
├── corpus/                  # Reserved corpus storage (placeholder)
├── docs/                    # MkDocs documentation site
├── drafts/                  # Reserved draft storage (placeholder)
├── figures/                 # Reserved figures storage (placeholder)
├── manuscripts/             # Per-paper manuscript directories
│   └── physics-constrained-multi-domain-denoising/
│   └── laser-ultrasound-denoising/
├── projects/                # Reserved project area (currently empty)
├── scripts/                # Utility scripts (install, zotero context)
├── skills/                  # GSDAW skill definitions (aw-orchestrator, aw-execute, etc.)
├── templates/elsevier/       # Elsevier LaTeX template
├── Makefile                 # LaTeX compilation targets
├── CLAUDE.md                # GSDAW framework documentation
├── README.md                # Project overview
└── package.json             # npm package metadata
```

## Directory Purposes

**`.claude/commands/`:**
- Purpose: Command routing files that map slash commands to skills
- Contains: `init.md`, `write.md`, `review.md`, `cite.md`, `figure.md`, `preview.md`, `commit.md`, `plan.md`, `research.md`
- Key files: `.claude/commands/init.md`, `.claude/commands/write.md`

**`skills/`:**
- Purpose: Main runtime skill catalog shipped with the package
- GSDAW skills: `aw-orchestrator/`, `aw-execute/`, `aw-wave-planner/`, `aw-planner/`, `aw-questioner/`, `aw-research/`, `aw-methodology/`, `aw-review/`, `aw-cite/`, `aw-table/`, `aw-figure/`, `aw-abstract/`, `aw-finalize/`, `aw-resume/`, `aw-pause/`, `aw-translate/`
- Section writers: `aw-write-intro/`, `aw-write-related/`, `aw-write-methodology/`, `aw-write-experiment/`, `aw-write-results/`, `aw-write-discussion/`, `aw-write-conclusion/`
- Utilities: `latex-live-preview/`, `zotero-context-injector/`, `paper-branch-by-title/`, `find-skills/`, `git-commit/`
- Superpowers: `superpowers/using-superpowers/`, `superpowers/test-driven-development/`, `superpowers/systematic-debugging/`, etc.

**`.agents/skills/`:**
- Purpose: Expanded/parallel skill tree with agents/references/scripts subdirectories
- Contains: `skill-creator/`, `git-commit/`, `git-flow-branch-creator/`, `brainstorming/`, `dispatching-parallel-agents/`, `executing-plans/`, etc.

**`.planning/`:**
- Purpose: Long-lived operational memory and generated planning artifacts
- Planning docs: `PROJECT.md`, `ROADMAP.md`, `STATE.md`, `HANDOFF.json`
- Generated: `research-brief.json`, `literature.md`, `methodology.md`, `wave-plan.md`
- Phase tracking: `phases/`, `phase-*-design.md`

**`manuscripts/`:**
- Purpose: Per-paper execution workspaces
- Active papers: `physics-constrained-multi-domain-denoising/`, `laser-ultrasound-denoising/`
- Each contains: `main.tex`, `references.bib`, `project.yaml`, `sections/` directory

**`templates/elsevier/`:**
- Purpose: Canonical starter layout for new manuscript projects
- Contains: `main.tex`, `references.bib`, `sections/` (abstract.tex, introduction.tex, methodology.tex, results.tex, discussion.tex, conclusion.tex)

## Key File Locations

**Entry Points:**
- `.claude/commands/init.md` — `/aw-init` orchestration entry
- `skills/aw-orchestrator/SKILL.md` — Phase 1 initialization state machine
- `skills/aw-execute/SKILL.md` — Wave-based execution and gate loop

**Configuration:**
- `package.json` — npm package metadata, runtime constraints, postinstall script
- `opencode.json` — OpenCode plugin declaration
- `mkdocs.yml` — MkDocs documentation site config
- `CLAUDE.md` — Repository operating guidance

**Manuscript Files:**
```
manuscripts/{slug}/
├── main.tex                  # LaTeX entrypoint
├── references.bib            # BibTeX bibliography
├── project.yaml             # Paper metadata
├── main.aux, main.bbl, etc. # LaTeX build artifacts
├── main.pdf                  # Compiled output
└── sections/
    ├── abstract.tex          # Abstract (merged)
    ├── introduction.tex      # Introduction (merged)
    ├── intro/                # Paragraph files
    │   ├── 1-1-background.tex
    │   ├── 1-2-problem.tex
    │   ├── 1-3-contributions.tex
    │   └── 1-4-structure.tex
    ├── related_work/
    ├── methodology/
    ├── experiment/
    ├── results/
    ├── discussion/
    ├── conclusion/
    └── tables/
```

## Naming Conventions

**Files:**
- Skill contracts: `SKILL.md` (uppercase fixed name)
- Command routes: lowercase kebab (e.g., `init.md`, `newpaper.md`)
- Planning docs: uppercase semantic (e.g., `ROADMAP.md`, `STATE.md`)
- Paragraph files: `{N}-{M}-{topic}.tex` (e.g., `3-4-physics-loss.tex`)

**Directories:**
- Skill folders: kebab-case (e.g., `aw-write-methodology/`)
- Manuscript folders: kebab-case slugs (e.g., `physics-constrained-multi-domain-denoising/`)
- Template folders: descriptive lowercase (e.g., `elsevier/`)

## Where to Add New Code

**New Orchestration Skill:**
- Implementation: `skills/aw-{new-skill}/SKILL.md`
- Optional expanded tree: `.agents/skills/aw-{new-skill}/agents/`, `references/`, `scripts/`
- Command route (if needed): `.claude/commands/{command}.md` with `Invoke skill` mapping

**New Command Entry:**
- Command file: `.claude/commands/{name}.md`
- Must map to existing or new skill contract under `skills/`

**New Manuscript:**
- Create `manuscripts/{paper-slug}/`
- Start from template: `templates/elsevier/`
- Populate `project.yaml`, `main.tex`, `references.bib`, section files under `sections/`

**New Paragraph:**
- Location: `manuscripts/{slug}/sections/{chapter}/{wave}-{id}-{topic}.tex`
- Follow `\paragraph{}` block structure

**New Utility Script:**
- Location: `scripts/{utility}.js` or `scripts/{utility}.py`
- Wire via `package.json` scripts if needed

## Special Directories

**`.planning/codebase/`:**
- Purpose: Mapper-generated architecture/stack/convention/concern references
- Generated: Yes (by GSD codebase mapper)
- Committed: Yes

**`manuscripts/{slug}/sections/{chapter}-zh/`:**
- Purpose: Chinese translation versions of section paragraphs
- Contains: Parallel `-zh.tex` files for each paragraph
- Example: `sections/intro/`, `sections/intro-zh/`, `sections/methodology/`, `sections/methodology-zh/`

**`templates/elsevier/`:**
- Purpose: Reusable baseline for new manuscripts
- Generated: No (authored template)
- Committed: Yes

**`projects/`:**
- Purpose: Reserved future project workspace
- Currently empty

---

*Structure analysis: 2026-04-24*
