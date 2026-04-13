# CLAUDE.md

GSDAW (Get Shit Done Academic Writing) — Spec-driven academic paper writing framework.

## Quick Navigation

| Need | Location |
|------|----------|
| Active paper | `manuscripts/{slug}/` |
| Paper template | `templates/elsevier/` |
| GSDAW skills | `skills/aw-*/` |
| Phase designs | `.planning/phase-*-design.md` |
| Planning docs | `.planning/*.md` |

## GSDAW Pipeline (3 Phases)

```
/aw-init              → Phase 1: Research Brief + Literature + Methodology + Plan
/aw-execute           → Phase 2: Wave-parallel section writing
/aw-cite              → Phase 3: Verify citations
/aw-table             → Phase 3: Build tables (CSV → LaTeX)
/aw-figure            → Phase 3: Generate figures (PlantUML + matplotlib)
/aw-abstract          → Phase 3: Write abstract
/aw-finalize          → Phase 3: make paper + verify
```

## All Commands

| Command | Phase | What it does |
|---------|-------|---------------|
| `/aw-init` | Init | Deep questioning → Research Brief → Literature + Methodology (parallel) → Plan |
| `/aw-execute` | Phase 2 | Wave planner → parallel subagents → quality gate → merge |
| `/aw-cite` | Phase 3 | Scan \cite{} against references.bib, auto-fix missing |
| `/aw-table` | Phase 3 | Ask for CSV → LaTeX booktabs, auto-insert |
| `/aw-figure` | Phase 3 | PlantUML diagrams + matplotlib plots, auto-insert |
| `/aw-abstract` | Phase 3 | 250-word IMRAD abstract from all sections |
| `/aw-finalize` | Phase 3 | make paper, check refs, word count, update STATE |
| `/aw-review` | Any | Section quality review (continue / modify / pause) |
| `/aw-wave-planner` | Manual | Re-plan waves from ROADMAP |

## Paragraph File Structure

Sections are built from independent paragraph files, merged by wave executor:

```
sections/
├── intro/
│   ├── 1-1-background.tex
│   ├── 1-2-problem.tex
│   ├── 1-3-contributions.tex
│   └── 1-4-structure.tex
├── related-work/
├── methodology/
├── experiment/
├── results/
├── discussion/
├── conclusion/
└── tables/
```

Each task writes one `.tex` paragraph. No two tasks write the same file in the same wave.

## Project Structure (per paper)

```
manuscripts/{slug}/
├── project.yaml
├── main.tex
├── references.bib
└── sections/
    ├── intro/
    ├── related-work/
    ├── methodology/
    ├── experiment/
    ├── results/
    ├── discussion/
    ├── conclusion/
    └── tables/
```

## Planning Outputs

```
.planning/
├── research-brief.json    ← /aw-init output
├── literature.md          ← Research Agent output
├── methodology.md         ← Methodology Agent output
├── ROADMAP.md            ← Phase-by-phase tasks + success criteria
├── STATE.md              ← Current phase, completion %
├── wave-plan.md          ← Wave assignments (auto-generated)
└── phase-*-design.md    ← GSDAW framework design docs
```

## Writing Order

Methodology → Results → Introduction → Discussion → Conclusion → Abstract

## Elsevier Format

- Document class: `\documentclass[review]{elsarticle}`
- Bibliography: `\bibliographystyle{elsarticle-num}`
- Citations: `\cite{key}` → numbered `[1]`
- Tables: booktabs (`\toprule`, `\midrule`, `\bottomrule`)

## Key Constraints

- Paragraph files are independent units — one per task, merged by wave executor
- Wave 1 tasks have no dependencies → run in parallel
- Later waves depend on earlier waves → sequential per wave
- Compilation is manual (`make paper`) — not automated per wave
- Tables need CSV from user — if not provided, leave `\placeholder{tab:name}`
- Figures: PlantUML for diagrams, matplotlib for plots, placeholder if no data
