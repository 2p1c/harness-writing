# Architecture

**Analysis Date:** 2026-04-24

## Pattern Overview

**Overall:** Multi-agent orchestration with wave-based parallel task execution

**Key Characteristics:**
- Orchestrator coordinates specialized subagents (research, methodology, writing)
- Wave planner groups independent tasks for parallel execution via git worktrees
- Quality gate after each wave before proceeding
- Paragraph files merged into section files via `\input{}`
- File-first state management: planning in `.planning/`, manuscript in `manuscripts/{slug}/`

## Layers

**Command Routing Layer:**
- Purpose: Translate user slash commands into skill execution contracts
- Location: `.claude/commands/`
- Contains: Thin command adapters with `Invoke skill` directives
- Evidence: `.claude/commands/init.md`, `.claude/commands/write.md`, `.claude/commands/review.md`

**Orchestration Layer:**
- Purpose: Coordinate Phase 1 initialization flow
- Location: `skills/aw-orchestrator/SKILL.md`
- Contains: Stepwise workflow chaining questioner + discuss + research + methodology + planner + discuss
- Evidence: `skills/aw-orchestrator/SKILL.md`

**Wave Execution Layer:**
- Purpose: Execute writing tasks wave-by-wave with parallel subagent spawning
- Location: `skills/aw-execute/SKILL.md`, `skills/aw-wave-planner/SKILL.md`
- Contains: Dependency graph building, topological sort, wave grouping, worktree isolation, result merging
- Evidence: `skills/aw-execute/SKILL.md`, `skills/aw-wave-planner/SKILL.md`

**Section Writer Layer:**
- Purpose: Generate individual paragraph files as merge units
- Location: `skills/aw-write-intro/`, `skills/aw-write-methodology/`, `skills/aw-write-results/`, `skills/aw-write-discussion/`, `skills/aw-write-conclusion/`, `skills/aw-write-related/`, `skills/aw-write-experiment/`
- Contains: Section-specific writing contracts and output path conventions
- Evidence: `skills/aw-write-intro/SKILL.md`

**Phase Specialist Layer:**
- Purpose: Produce phase artifacts (brief, literature, methodology, cite, table, figure, abstract, finalize)
- Location: `skills/aw-questioner/`, `skills/aw-research/`, `skills/aw-methodology/`, `skills/aw-planner/`, `skills/aw-cite/`, `skills/aw-table/`, `skills/aw-figure/`, `skills/aw-abstract/`, `skills/aw-finalize/`, `skills/aw-translate/`
- Evidence: `skills/aw-review/SKILL.md`, `skills/aw-cite/SKILL.md`

**Review Layer:**
- Purpose: Quality gate validation after each wave
- Location: `skills/aw-review/SKILL.md`
- Contains: Automated checks (compile, word count, citations, placeholders), adversarial critique, user decision
- Evidence: `skills/aw-review/SKILL.md`

**Template & Build Layer:**
- Purpose: Elsevier LaTeX template and compilation
- Location: `templates/elsevier/`, `Makefile`
- Contains: LaTeX skeleton, `\input{}` section structure, `paper`/`quick`/`check-refs` targets
- Evidence: `templates/elsevier/main.tex`, `Makefile`

## Data Flow

**Phase 1 - Initialization (`/aw-init`):**
```
/aw-init
  ├── aw-questioner → .planning/research-brief.json
  ├── aw-discuss-1 (confirm brief)
  ├── [aw-research + aw-methodology] (parallel)
  ├── aw-discuss-2 (consistency check)
  ├── aw-planner → .planning/ROADMAP.md + STATE.md
  ├── aw-discuss-3 (final approval)
  └── DONE → /aw-execute ready
```

**Phase 2 - Wave Execution (`/aw-execute`):**
```
/aw-execute
  ├── Read ROADMAP + STATE
  ├── Wave Planner (dependency sort, wave grouping)
  └── FOR EACH WAVE:
        ├── Spawn aw-write-* subagents (parallel if independent, sequential on conflict)
        ├── Wait for completion
        ├── Merge paragraph files via \input{} → section file
        └── Quality Gate (aw-review) → "继续/修改/暂停"
```

**Phase 3 - Finalization:**
```
/aw-cite    → Scan \cite{} → verify against references.bib
/aw-table   → CSV → LaTeX booktabs
/aw-figure  → PlantUML/matplotlib → figures
/aw-abstract → IMRAD abstract from sections
/aw-finalize → make paper, verify, update STATE
```

## Key Abstractions

**Paragraph File:**
- Purpose: Independent writing unit written by one subagent
- Location: `manuscripts/{slug}/sections/{chapter}/{wave}-{id}-{topic}.tex`
- Pattern: Single `\paragraph{}` block per file, merged via `\input{}`
- Example: `manuscripts/physics-constrained-multi-domain-denoising/sections/intro/1-1-background.tex`

**Wave:**
- Purpose: Group of parallelizable independent tasks
- Pattern: Tasks with no file overlap within same wave run in parallel via git worktrees
- Output: `.planning/wave-plan.md`

**Section File:**
- Purpose: Merged collection of paragraph files for one IMRAD section
- Pattern: `\input{paragraph-1.tex}` + `\input{paragraph-2.tex}` ...
- Example: `manuscripts/{slug}/sections/introduction.tex` (merged from `intro/*.tex`)

**Worktree:**
- Purpose: Isolated git branch for parallel task execution
- Pattern: `git worktree add ../worktrees/phase{N}-wave{M}-task{N.M} {branch}`
- Cleaned up after wave completion

**Research Brief:**
- Purpose: Canonical project intent and constraints
- Location: `.planning/research-brief.json`
- Pattern: Structured JSON with research question, approach, methodology, constraints, materials

**Quality Gate:**
- Purpose: Checkpoint validating wave output before proceeding
- Automated checks: LaTeX compile, word count vs target, citation resolution, placeholder scan
- User decisions: 继续 (continue), 修改 (modify), 暂停 (pause)

## Entry Points

**Slash Commands (`.claude/commands/`):**
- `/aw-init` — via `init.md` → `aw-orchestrator`
- `/aw-execute` — via `.claude/commands/` → `aw-execute`
- `/aw-review` — manual quality review
- `/aw-cite`, `/aw-table`, `/aw-figure`, `/aw-abstract`, `/aw-finalize` — Phase 3 tools

**Build Targets (`Makefile`):**
- `make paper` — Full compilation with bibliography
- `make quick` — Quick compilation without bibliography
- `make check-refs` — Citation reference check

**Package Installation:**
- `package.json` postinstall runs `scripts/install-skill-links.js`
- Links skills to `~/.agents/skills` and commands to `~/.claude/commands`

## Cross-Cutting Concerns

**LaTeX Format:** Elsevier document class (`\documentclass[review]{elsarticle}`), numbered citations (`\cite{key}`), booktabs tables

**Citation Management:** All `\cite{}` keys must resolve against `references.bib` (verified by `aw-cite` and quality gate)

**Git Worktrees:** Enable parallel writing without conflicts; cleaned up after wave completion

**Bilingual Support:** Papers may include `-zh` parallel directories for Chinese translation (e.g., `sections/intro-zh/`, `sections/methodology-zh/`)

**State Boundaries:**
- Planning state: `.planning/*`
- Manuscript content: `manuscripts/{slug}/*`
- Skill definitions: `skills/*`

---

*Architecture analysis: 2026-04-24*
