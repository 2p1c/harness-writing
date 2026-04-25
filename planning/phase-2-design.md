# GSDAW Phase 2: Wave Execution Engine

**Phase:** 2 of GSDAW Framework Development
**Status:** Design Draft — Pending User Approval
**Branch:** `gsdam-phase-1-design`

## What This Phase Does

Phase 1 built the **planning pipeline** (Questioner → Discuss → Research+Methodology → Discuss → Planner → Discuss → ROADMAP).

Phase 2 builds the **execution engine** that implements each paper section from ROADMAP.md using wave-based parallel execution.

**Phase 2 implements:**
1. Section decomposition — breaking each IMRAD phase into waveable section tasks
2. Wave planner — grouping independent tasks into waves for parallel execution
3. Section writing agents — individual agents for each section type (intro, related work, methodology, etc.)
4. Result aggregation — merging parallel section outputs into coherent chapter drafts
5. Quality gates — section-level review before advancing to next phase

---

## Phase 2 Architecture

### High-Level Flow

```
/aw-execute
    │
    ▼
┌──────────────────────────────────────────────────────┐
│  WAVE PLANNER                                        │
│  - Read ROADMAP.md (phase tasks)                    │
│  - Read .planning/literature.md + methodology.md     │
│  - Group tasks into dependency-ordered waves         │
│  - Output: wave plan (which tasks per wave)          │
└─────────────────────┬────────────────────────────────┘
                      │ Wave plan
                      ▼
┌──────────────────────────────────────────────────────┐
│  WAVE EXECUTOR                                       │
│  For each wave (sequentially):                       │
│    For each task in wave (in parallel if independent)│
│      → Spawn section-writing agent                   │
│      → Collect output                                │
│    → Merge wave results into draft                   │
│    → Quality gate (user review checkpoint)           │
└─────────────────────┬────────────────────────────────┘
                      │ All waves complete
                      ▼
┌──────────────────────────────────────────────────────┐
│  PHASE MERGER                                        │
│  - Aggregate all section drafts                     │
│  - Resolve cross-references                          │
│  - Build complete chapter file                       │
│  - Update STATE.md with completion                   │
└─────────────────────┬────────────────────────────────┘
                      │ Phase draft complete
                      ▼
┌──────────────────────────────────────────────────────┐
│  SECTION REVIEW (aw-review)                         │
│  - Run adversarial review on section                  │
│  - User approves or requests revision                │
└─────────────────────┬────────────────────────────────┘
                      │ Approved
                      ▼
┌──────────────────────────────────────────────────────┐
│  NEXT PHASE or /aw-complete                         │
└──────────────────────────────────────────────────────┘
```

---

## Key Concepts

### Waves

A **wave** is a group of tasks that can execute **in parallel** because they have no dependencies on each other's outputs.

Within a wave:
- Tasks with **no file overlap** → run in parallel (worktree-isolated subagents)
- Tasks with **file overlap** → run sequentially to avoid conflicts

**Example — Phase 1 Introduction:**

```
Wave 1 (parallel):
  ├── Write 1.1 Research Background
  ├── Write 1.2 Problem Definition
  └── Write 1.4 Paper Structure Overview

Wave 2 (depends on Wave 1):
  └── Write 1.3 Main Contributions (needs 1.1 + 1.2 context)
```

**Example — Phase 3 Methodology:**

```
Wave 1 (parallel):
  ├── Write 3.1 Dataset Description
  ├── Write 3.2 Baseline Methods
  └── Write 3.3 Evaluation Metrics

Wave 2 (depends on Wave 1):
  ├── Write 3.4 Network Architecture
  └── Write 3.5 Loss Function

Wave 3 (depends on Wave 2):
  └── Write 3.6 Training Scheme + Inference
```

### Section Writing Agents

Each paper section type has a specialized agent:

| Agent | Trigger | Output |
|-------|---------|--------|
| `aw-write-intro` | Wave task | `sections/introduction.tex` |
| `aw-write-related` | Wave task | `sections/related-work.tex` |
| `aw-write-methodology` | Wave task | `sections/methodology.tex` |
| `aw-write-experiment` | Wave task | `sections/experiment.tex` |
| `aw-write-results` | Wave task | `sections/results.tex` |
| `aw-write-discussion` | Wave task | `sections/discussion.tex` |
| `aw-write-conclusion` | Wave task | `sections/conclusion.tex` |

All agents read from:
- `.planning/research-brief.json`
- `.planning/literature.md`
- `.planning/methodology.md`
- `templates/elsevier/` (LaTeX format reference)

---

## Wave Planner

### Input

- `.planning/ROADMAP.md` — Phase tasks with dependencies
- `.planning/literature.md` — Context for writing
- `.planning/methodology.md` — Technical details
- `.planning/research-brief.json` — Author intent

### Process

1. **Parse ROADMAP** — Extract tasks per phase, their dependencies
2. **Build dependency graph** — Each task = node, dependency = edge
3. **Topological sort** — Order tasks respecting dependencies
4. **Group into waves** — Assign wave number to each task
5. **Check intra-wave conflicts** — Tasks modifying same file → sequential within wave

### Output

```
# Wave Plan — Phase {N}: {Phase Name}

**Generated:** [ISO timestamp]

## Wave 1

| Task | Section | File | Dependencies |
|------|---------|------|-------------|
| 1.1 | Research Background | introduction.tex | — |
| 1.2 | Problem Definition | introduction.tex | — |
| 1.4 | Paper Structure | introduction.tex | — |

## Wave 2

| Task | Section | File | Dependencies |
|------|---------|------|-------------|
| 1.3 | Main Contributions | introduction.tex | 1.1, 1.2 |

**Conflicts detected:** None
```

---

## Wave Executor

### Execution Model

For each wave:

```
FOR EACH task IN wave:
  IF task can_parallelize WITH other tasks:
    SPAWN subagent WITH isolation="worktree"
  ELSE:
    SPAWN subagent ON main tree

  WAIT all subagents IN wave TO complete
  MERGE outputs
  QUALITY gate (user review)
```

### Subagent Contract

Each section-writing subagent receives:

```yaml
objective: Write Section {X.Y} — {Task Name}
inputs:
  - ROADMAP task description
  - research-brief.json (context)
  - literature.md (relevant excerpts)
  - methodology.md (technical details)
  - LaTeX template reference
output:
  - Independent paragraph file: sections/{chapter}/{task-id}.tex
  - SUMMARY.md in task directory
```

**Paragraph file structure** — 每个 task 写一个独立的 `.tex` snippet：
```
sections/
├── introduction/
│   ├── 1-1-background.tex      # \paragraph{1.1 Research Background}
│   ├── 1-2-problem.tex         # \paragraph{1.2 Problem Definition}
│   ├── 1-3-contributions.tex   # \paragraph{1.3 Main Contributions}
│   └── 1-4-structure.tex       # \paragraph{1.4 Paper Structure}
├── related-work/
│   ├── 2-1-categorization.tex
│   └── ...
```

Wave 结束后，`aw-execute` 负责将段落文件按正确顺序 `\input{}` 进主章节文件。

### Quality Gates

After each wave completes, a quality gate runs:

**Automated checks:**
- LaTeX compiles without errors
- Word count target met (±20%)
- All citations resolve
- No TODO/FIXME placeholders remaining

**User checkpoint:**
```
## Phase {N} Wave {M} — Quality Gate

**Task:** {task description}
**Status:** ✅ Draft complete

[Preview of written content — first 500 chars]

Automated checks:
- ✅ Compiles: Yes
- ✅ Word count: {X} / {target}
- ✅ Citations: {N} resolved
- ✅ Placeholders: None

---
Options:
1. "继续" — Approve, proceed to next wave
2. "修改" — Request specific changes
3. "暂停" — Save checkpoint, resume later
```

---

## Phase Merger

After all waves for a phase complete:

### Merge Process

1. **Collect section files** — Gather all `sections/*.tex` for the phase
2. **Resolve cross-references** — Figure numbers, equation numbers, citations
3. **Build chapter file** — Concatenate sections in correct order
4. **Run full compile** — `make paper` to verify end-to-end
5. **Update STATE.md** — Mark phase as "writing complete"

### Cross-Reference Resolution

```
Before merge, scan for:
- \ref{fig:} → assign figure numbers sequentially
- \ref{tab:} → assign table numbers sequentially
- \ref{eq:} → assign equation numbers sequentially
- \cite{} → verify all in references.bib
```

---

## Section Writing Agents (Skills)

### `aw-write-intro`

**Inputs:** Research Brief (problem, novelty, contributions)

**Tasks from ROADMAP:**
- 1.1 Research background (2-3 paragraphs)
- 1.2 Problem definition (1 paragraph)
- 1.3 Main contributions (3-4 bullets)
- 1.4 Paper structure overview (brief paragraph)

**Output:** `sections/introduction.tex`

**LaTeX template:**
```latex
\section{Introduction}
\label{sec:intro}

% 1.1 Research Background
% 1.2 Problem Definition
% 1.3 Contributions
% 1.4 Paper Structure
```

### `aw-write-related`

**Inputs:** Literature.md (categorized related work by category)

**Tasks from ROADMAP:**
- 2.1 Categorize existing methods
- 2.2 Discuss each category (strengths + weaknesses)
- 2.3 Highlight research gap
- 2.4 Natural transition to proposed method

**Output:** `sections/related-work.tex`

### `aw-write-methodology`

**Inputs:** Methodology.md (architecture, datasets, baselines, metrics)

**Tasks from ROADMAP:**
- 3.1 Method overview (2-3 paragraphs)
- 3.2 Architecture components
- 3.3 Key innovations
- 3.4 Experimental setup preview

**Output:** `sections/methodology.tex`

### `aw-write-experiment`

**Inputs:** Methodology.md (datasets, baselines, metrics, ablation)

**Tasks from ROADMAP:**
- 4.1 Dataset description
- 4.2 Baseline methods
- 4.3 Evaluation metrics
- 4.4 Main results
- 4.5 Ablation studies
- 4.6 Statistical significance

**Output:** `sections/experiment.tex`

### `aw-write-results`

**Inputs:** Methodology.md + experimental data/notes

**Tasks from ROADMAP:**
- 5.1-5.6 (all results subsections)

**Output:** `sections/results.tex`

### `aw-write-discussion`

**Inputs:** Results + Literature.md

**Tasks from ROADMAP:**
- 6.1 Result interpretation
- 6.2 Comparison with literature
- 6.3 Limitations
- 6.4 Risks
- 6.5 Practical implications

**Output:** `sections/discussion.tex`

### `aw-write-conclusion`

**Inputs:** All previous sections

**Tasks from ROADMAP:**
- 7.1 Summary of contributions
- 7.2 Key findings
- 7.3 Future work directions

**Output:** `sections/conclusion.tex`

---

## File Structure (Phase 2)

```
skills/
├── aw-questioner/SKILL.md        # Phase 1 ✓
├── aw-discuss-1/SKILL.md         # Phase 1 ✓
├── aw-discuss-2/SKILL.md         # Phase 1 ✓
├── aw-discuss-3/SKILL.md         # Phase 1 ✓
├── aw-research/SKILL.md           # Phase 1 ✓
├── aw-methodology/SKILL.md       # Phase 1 ✓
├── aw-planner/SKILL.md           # Phase 1 ✓
├── aw-orchestrator/SKILL.md      # Phase 1 ✓
├── aw-execute/SKILL.md           # Phase 2 NEW — Wave execution orchestrator
├── aw-wave-planner/SKILL.md      # Phase 2 NEW — Wave planning
├── aw-review/SKILL.md            # Phase 2 NEW — Section quality review
├── aw-write-intro/SKILL.md       # Phase 2 NEW — Introduction writer
├── aw-write-related/SKILL.md     # Phase 2 NEW — Related work writer
├── aw-write-methodology/SKILL.md # Phase 2 NEW — Methodology writer
├── aw-write-experiment/SKILL.md   # Phase 2 NEW — Experiment writer
├── aw-write-results/SKILL.md     # Phase 2 NEW — Results writer
├── aw-write-discussion/SKILL.md  # Phase 2 NEW — Discussion writer
└── aw-write-conclusion/SKILL.md  # Phase 2 NEW — Conclusion writer
```

---

## Open Questions — RESOLVED

| # | Question | Decision | Rationale |
|---|----------|----------|-----------|
| 1 | Worktree isolation strategy | **A) Each worktree writes independent paragraph file** | 每个 task 对应一个独立的 `.tex` snippet 文件（如 `sections/intro/1-1-background.tex`），无文件冲突，wave 内完全并行 |
| 2 | Figure/table generation | **A) Inline placeholder during writing** | 写作时内嵌 `\placeholder{fig:xxx}` 或描述性格式，Figure Agent 在 Phase 3 统一生成 |
| 3 | Author voice preservation | **A) Review agent corrects from user feedback** | Review Agent 根据用户反馈实时纠正语体风格，不需要训练数据 |
| 4 | Full compilation trigger | **C) User manually triggered** | `make paper` 手动触发，避免频繁编译消耗资源 |

---

## Status

- [x] Phase 2 design drafted
- [x] Discuss with user → resolve open questions
- [x] Implement Phase 2 skills (10 new skills)
- [ ] Test `/aw-execute` with Phase 1 Introduction
- [ ] Phase 2 complete → proceed to Phase 3
