# Wave Plan — Phase 1: Introduction

**Generated:** 2026-04-13
**Phase:** 1 (Introduction)
**Word target:** 1500 words
**Figure:** Fig. 1 — Laser Ultrasound Acquisition System schematic

---

## Wave 1 (Parallel — no dependencies)

| Task ID | Paragraph | File | Dependencies |
|---------|-----------|------|-------------|
| 1-1 | Research Background | sections/intro/1-1-background.tex | — |
| 1-2 | Problem Definition | sections/intro/1-2-problem.tex | — |
| 1-4 | Paper Structure Overview | sections/intro/1-4-structure.tex | — |

## Wave 2 (Depends on Wave 1)

| Task ID | Paragraph | File | Dependencies |
|---------|-----------|------|-------------|
| 1-3 | Main Contributions | sections/intro/1-3-contributions.tex | 1-1, 1-2 |

## Phase Merge

| Step | Action | Output |
|------|--------|--------|
| M1 | Merge all 4 paragraphs into introduction.tex | sections/introduction.tex |

**Conflicts detected:** None — all paragraph files are independent.

---

## Execution Order

1. Wave 1: Spawn 3 parallel subagents (1-1, 1-2, 1-4)
2. Wave 1 completes → quality gate
3. Wave 2: Spawn 1 subagent (1-3)
4. Wave 2 completes → quality gate
5. Phase merge: concatenate all paragraphs into introduction.tex
6. Final quality gate
