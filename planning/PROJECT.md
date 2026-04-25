# GSDAW: Get Shit Done — Academic Writing

**Type:** Framework Development (Meta-project)
**Analysis Date:** 2026-04-13
**Status:** Phase 0 — Design Complete, Moving to Phase 1

## What This Is

A multi-agent framework for AI-assisted academic paper writing, built on the principles of [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done). The framework uses sub-agents to avoid context window limits, structured context files to preserve project memory across sessions, and wave-based execution to parallelize independent writing tasks.

**Core problem solved:** Academic papers are large, context-heavy artifacts. A naive AI writing assistant degrades as context fills. GSDAW solves this through context engineering — externalized memory, hierarchical context layers, and small fresh plans executed in waves.

## Why This Exists

Current academic writing tools (Zotero, Overleaf, LaTeX) are file management and typesetting systems — they don't think. AI assistants can think but hit context limits on long papers. GSDAW bridges this gap by:

1. Breaking papers into independently-executable units (sections, subsections)
2. Maintaining externalized context files per section (not one giant context)
3. Using multi-agent orchestration (research, write, review, verify, figure) to parallelize work
4. Preserving project memory across sessions via structured files (PROJECT.md, LITERATURE.md, STATE.md)

## Who It's For

- Academic researchers writing papers in engineering and technical fields
- Graduate students drafting theses/dissertations
- Technical writers producing survey papers or review articles
- Anyone writing long-form academic documents with heavy citation requirements

## Key Design Principles

### 1. Context Engineering Over Memory

Context degrades. GSDAW solves this not by buying more context but by engineering what's loaded at each step:

```
Global Context (PROJECT.md + LITERATURE.md)     ← Always loaded, research direction + citation network
Section Context (CONTEXT/[section].ctx.md)       ← Loaded only when writing that section
Task Context (/aw-execute task-level)           ← Minimal, each plan fresh
```

### 2. Wave-Based Execution

Academic papers have natural dependencies. Literature review and methodology design run in parallel; results section waits for methodology; discussion waits for results.

```
Wave 1 (parallel):  literature ←→ methodology design
Wave 2 (sequential): writing (introduction, methodology) ← Wait for Wave 1
Wave 3 (sequential): analysis + results ← Wait for Wave 2
Wave 4 (sequential): discussion ← Wait for Wave 3
Wave 5 (sequential): conclusion + abstract ← Wait for Wave 4
```

### 3. Multi-Agent Orchestration

Each capability is a specialized sub-agent:
- **research-agent** — literature search, progress tracking
- **source-agent** — PDF/Word/image/data reading and extraction
- **writer-agent** — section writing with LaTeX formatting
- **reviewer-agent** — adversarial dual-agent critique (Critic → Improver)
- **figure-agent** — chart/diagram generation
- **verifier-agent** — completeness, citation, format validation
- **synthesizer-agent** — multi-source synthesis, literature review generation

### 4. Externalized Project Memory

All state written to files immediately. Context loss = state preserved.

| File | Purpose |
|------|---------|
| `PROJECT.md` | Research question, objectives, scope, constraints |
| `LITERATURE.md` | Citation network, literature summaries, source tracking |
| `REQUIREMENTS.md` | Journal format, word limits, citation style, deadlines |
| `ROADMAP.md` | Chapter breakdown, phase mapping, success criteria |
| `STATE.md` | Completion tracking, open issues, blockers |
| `CONTEXT/[section].ctx.md` | Per-section context (prevents cross-contamination) |

## Architecture (GSDAW vs GSD)

| GSD (Software Dev) | GSDAW (Academic Writing) |
|---------------------|--------------------------|
| `STACK.md` | `LITERATURE.md` — citation network instead of tech stack |
| Phase = feature | Phase = paper chapter or chapter group |
| `REQUIREMENTS.md` = functional specs | `REQUIREMENTS.md` = journal format, word count, citation style |
| `verifier` = unit/integration tests | `verifier` = citation completeness, format compliance, logical coherence |
| External inputs: code files | External inputs: PDF, Word, images, data files, reference PDFs |

## Skill System

### Skill Categories

**Orchestrator Skills** — Top-level coordination
- `aw-orchestrator` — Main writing coordinator, phase transitions
- `aw-literature` — Literature research and tracking

**Writer Skills** — Content generation
- `aw-section-writer` — Per-chapter writing with LaTeX/Elsevier format
- `aw-outline` — IMRAD outline generation
- `aw-abstract` — Abstract-specific writing

**Input Skills** — Reference material processing
- `aw-pdf-reader` — PDF parsing and content extraction
- `aw-word-reader` — Word document reading
- `aw-image-reader` — Chart OCR and digitization
- `aw-data-reader` — CSV/Excel data import

**Quality Skills** — Writing improvement
- `aw-review` — Adversarial dual-agent critique (Critic → Improver, max 3 rounds)
- `aw-language` — Academic tone, tense consistency, hedging optimization
- `aw-citation-check` — Citation consistency verification

**Output Skills** — Generation and export
- `aw-figure` — Data visualization, PlantUML, Graphviz
- `aw-compile` — LaTeX compilation and PDF generation
- `aw-word-export` — Pandoc-based Word export

**Tracking Skills** — Progress management
- `aw-progress` — State tracking and updates
- `aw-progress-review` — Commit-history-based progress inference

### Existing Skills (To Be Refactored)

| Existing Skill | GSDAW Equivalent |
|----------------|-----------------|
| `research-paper-writer` | → `aw-orchestrator` + `aw-section-writer` |
| `paper-outline-generator` | → `aw-outline` |
| `latex-paper-en` | → `aw-section-writer` (absorbed) |
| `academic-review` | → `aw-review` |
| `literature-manager` | → `aw-literature` |
| `figure-integrator` | → `aw-figure` |
| `zotero-context-injector` | → `aw-pdf-reader` + `aw-literature` |
| `latex-live-preview` | → `aw-compile` (integrated) |
| `paper-branch-by-title` | → Git workflow (kept as-is) |
| `paper-session-checkpoint-commit` | → Git workflow (kept as-is) |
| `paper-writing-progress-review` | → `aw-progress-review` |
| `find-skills` | → `find-skills` (kept as-is) |
| `git-commit` | → Git workflow (kept as-is) |
| `git-flow-branch-creator` | → Git workflow (kept as-is) |
| `skill-creator` | → Framework tool (kept as-is) |

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Adopt GSD's context engineering pattern | Context rot is the core problem in long-document writing | Externalized memory + hierarchical context |
| Wave-based execution over sequential | Academic papers have natural parallelism (literature + methodology) | Waves 1-5 with dependency tracking |
| Per-section context files | Each chapter shouldn't pollute other's context | `CONTEXT/` directory per section |
| Dual-agent review (Critic → Improver) | Adversarial critique catches more issues than solo review | Max 3 rounds, user-controlled |
| LITERATURE.md as citation network | Literature is the "tech stack" of academic writing | Tracks sources, connections, summaries |
| Elsevier/IMRAD as default format | Engineering/technical research standard | Can adapt to other formats via REQUIREMENTS.md |

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] **GSDAW-01**: Multi-agent orchestrator framework with wave-based execution
- [ ] **GSDAW-02**: Hierarchical context system (global + section + task)
- [ ] **GSDAW-03**: Literature tracking and citation network (LITERATURE.md)
- [ ] **GSDAW-04**: PDF/Word/image reading skills
- [ ] **GSDAW-05**: Adversarial review with dual-agent critique loop
- [ ] **GSDAW-06**: Figure generation (data viz, PlantUML, Graphviz)
- [ ] **GSDAW-07**: Citation consistency verification
- [ ] **GSDAW-08**: LaTeX compilation with live preview

### Out of Scope

- **Direct Zotero API integration** — Zotero MCP exists separately; source-agent reads PDFs not Zotero DB
- **Non-LaTeX formats** — Plain markdown/Word native not supported; pandoc export only
- **Real-time collaboration** — Single-user workflow; git handles versioning
- **Automated submission** — PDF generation only; no journal API integration

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/aw-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/aw-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-04-13 after initialization*
