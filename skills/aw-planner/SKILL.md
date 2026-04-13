---
name: aw-planner
description: |
  GSDAW Planning Agent — creates coarse-grained writing roadmap.
  Triggers after aw-discuss-2 confirms consistency, or runs /aw-plan.
  Reads research-brief.json, literature.md, and methodology.md.
  Outputs ROADMAP.md (by-chapter phases) and initial STATE.md.
  Each chapter = one phase with tasks and success criteria.
---

# GSDAW Planning Agent

## Purpose

Create a coarse-grained writing roadmap based on the Research Brief, Literature Summary, and Methodology Design. This skill operates **after** `aw-discuss-2` confirms consistency between the research and methodology outputs. It breaks the paper into **chapter-level phases** (not paragraph-level tasks).

## When to Trigger

- `aw-discuss-2` confirms consistency between Research and Methodology
- User explicitly runs `/aw-plan` command
- Orchestrator calls this skill during GSDAW pipeline

## Workflow

```
aw-discuss-2 (consistency confirmed)
    │
    ▼
aw-planner  ◄── You are here
    │
    ▼
┌─────────────────────────────────────────────────┐
│  READ INPUT DOCUMENTS                            │
│  1. .planning/research-brief.json (title, constraints, deadline) │
│  2. .planning/literature.md (Related Work structure)            │
│  3. .planning/methodology.md (Method/Experiment/Results chapters) │
│  4. .planning/discuss-2-summary.md (optional consensus notes)    │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  PHASE DECOMPOSITION                             │
│  - Map IMRAD chapters → 6 phases               │
│  - Extract tasks from literature.md + methodology.md │
│  - Calculate estimated duration from deadline    │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  OUTPUT GENERATION                              │
│  1. Write .planning/ROADMAP.md                 │
│  2. Write .planning/STATE.md (initial state)    │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
Report completion to user
```

---

## Step 1: Read Input Documents

### 1.1 Read Research Brief

Read `.planning/research-brief.json` and extract:

| Field | Path | Use |
|-------|------|-----|
| Title | `title` | Paper title in ROADMAP header |
| Target Venue | `constraints.targetVenue` | Journal/conference |
| Deadline | `constraints.deadline` | Calculate duration |
| Problem | `researchQuestion.problem` | Introduction context |
| Novelty | `researchQuestion.novelty` | Introduction contributions |
| Strategy | `researchApproach.strategy` | Methodology overview |

### 1.2 Read Literature Summary

Read `.planning/literature.md` and extract:

| Field | Use |
|-------|-----|
| Categories of related work | Structure Related Work chapter |
| Key references (must-cite) | Ensure proper citations |
| Research gaps | Position the contribution |
| Papers analyzed count | Estimate Related Work scope |

### 1.3 Read Methodology

Read `.planning/methodology.md` and extract:

| Field | Use |
|-------|-----|
| Architecture components | Methodology chapter tasks |
| Datasets | Experiment chapter |
| Baselines | Experiment chapter |
| Evaluation metrics | Results chapter |
| Ablation studies | Results chapter |
| Figures needed | Coordinate with figure skill |
| Risks | Discussion chapter |

### 1.4 Read Discuss-2 Summary (if exists)

Read `.planning/discuss-2-summary.md` for any consensus notes or adjustments from the consistency check.

---

## Step 2: Phase Decomposition

### Standard IMRAD Phases

| Phase | Chapter | Goal |
|-------|---------|------|
| 1 | Introduction | Establish context and motivate the work |
| 2 | Related Work | Position in existing literature |
| 3 | Methodology | Describe proposed approach |
| 4 | Experiment | Present experimental setup and results |
| 5 | Discussion | Interpret results and implications |
| 6 | Conclusion | Summarize contributions and future work |

### Phase Dependencies

```
Phase 1 (Introduction) → None
Phase 2 (Related Work) → Phase 1 + Literature Summary
Phase 3 (Methodology) → Phase 2 + Methodology Design
Phase 4 (Experiment) → Phase 3
Phase 5 (Discussion) → Phase 4 + Literature Summary
Phase 6 (Conclusion) → Phase 5
```

### Duration Estimation

Calculate estimated total duration based on deadline:

1. Count days from today to deadline
2. Allocate time per phase:

| Phase | Default Allocation |
|-------|-------------------|
| Introduction | 10% of total |
| Related Work | 15% of total |
| Methodology | 20% of total |
| Experiment | 25% of total |
| Discussion | 20% of total |
| Conclusion | 10% of total |

**Example:** 5 weeks (35 days) until deadline:
- Introduction: 3-4 days
- Related Work: 5 days
- Methodology: 7 days
- Experiment: 9 days
- Discussion: 7 days
- Conclusion: 3-4 days

---

## Step 3: Generate ROADMAP.md

Write to `.planning/ROADMAP.md`:

```markdown
# GSDAW Roadmap

**Paper:** [title from brief]
**Target:** [journal/conference from brief]
**Estimated Duration:** [X weeks based on deadline]
**Created:** [ISO date]

## Phase Dependencies

```
Phase 1 (Introduction)
Phase 2 (Related Work)    ← needs Phase 1 + Literature
Phase 3 (Methodology)     ← needs Phase 2 + Methodology
Phase 4 (Experiment)      ← needs Phase 3
Phase 5 (Discussion)       ← needs Phase 4 + Literature
Phase 6 (Conclusion)       ← needs Phase 5
```

---

## Phase 1: Introduction

**Goal:** Establish research context and motivate the work

**Dependencies:** None

**Estimated Duration:** [X days]

**Tasks:**
- [ ] 1.1 Research background (2-3 paragraphs on problem domain)
- [ ] 1.2 Problem definition (1 paragraph)
- [ ] 1.3 Main contributions (3-4 bullet points, numbered)
- [ ] 1.4 Paper structure overview (brief paragraph)

**Success Criteria:**
1. Reader understands why this problem matters
2. Reader knows the main contributions (3 distinct items)
3. Structure roadmap is clear

---

## Phase 2: Related Work

**Goal:** Position work in context of existing research

**Dependencies:** Phase 1, Literature Summary (from .planning/literature.md)

**Estimated Duration:** [X days]

**Tasks:**
- [ ] 2.1 Categorize existing methods (group by approach type)
- [ ] 2.2 Discuss each category (strengths + weaknesses)
- [ ] 2.3 Highlight research gap (from literature.md)
- [ ] 2.4 Natural transition to proposed method

**Success Criteria:**
1. Covers major related work (from literature.md)
2. Categorization is logical and defensible
3. Gap clearly sets up proposed method

---

## Phase 3: Methodology

**Goal:** Describe the proposed approach in technical detail

**Dependencies:** Phase 2, Methodology Design (from .planning/methodology.md)

**Estimated Duration:** [X days]

**Tasks:**
- [ ] 3.1 Method overview (2-3 paragraphs)
- [ ] 3.2 Architecture components (describe each component)
- [ ] 3.3 Key innovations (explain novelty points)
- [ ] 3.4 Experimental setup overview (datasets, baselines preview)

**Success Criteria:**
1. Technical description is complete and reproducible
2. Reader understands how the method works
3. Innovations are clearly stated and justified

---

## Phase 4: Experiment

**Goal:** Present experimental setup and results

**Dependencies:** Phase 3

**Estimated Duration:** [X days]

**Tasks:**
- [ ] 4.1 Dataset description (statistics, splits, preprocessing)
- [ ] 4.2 Baseline methods (describe each baseline)
- [ ] 4.3 Evaluation metrics (define each metric)
- [ ] 4.4 Main results (compare with baselines)
- [ ] 4.5 Ablation studies (component-wise analysis)
- [ ] 4.6 Statistical significance (if applicable)

**Success Criteria:**
1. All baselines from methodology.md are evaluated
2. Results are reproducible from description
3. Ablation study validates component contributions

---

## Phase 5: Discussion

**Goal:** Interpret results and discuss implications

**Dependencies:** Phase 4, Literature Summary

**Estimated Duration:** [X days]

**Tasks:**
- [ ] 5.1 Result interpretation (what do the numbers mean)
- [ ] 5.2 Comparison with literature (how do results compare to prior work)
- [ ] 5.3 Limitations (honest assessment of weaknesses)
- [ ] 5.4 Risks from methodology.md (address each risk)
- [ ] 5.5 Practical implications (what this means for practitioners)

**Success Criteria:**
1. Results are interpreted honestly (not over-sold)
2. Limitations are acknowledged
3. Comparison with literature is fair and complete

---

## Phase 6: Conclusion

**Goal:** Summarize contributions and future work

**Dependencies:** Phase 5

**Estimated Duration:** [X days]

**Tasks:**
- [ ] 6.1 Summary of contributions (restate main contributions)
- [ ] 6.2 Key findings (1-2 paragraphs on most important results)
- [ ] 6.3 Future work directions
- [ ] 6.4 Closing statement

**Success Criteria:**
1. Contributions are clearly restated
2. Paper ends on a strong note
3. Future work is plausible and interesting

---

## Key Milestones

| Milestone | Target Week | Phase | Deliverable |
|-----------|-------------|-------|-------------|
| Outline Complete | Week 1 | Phases 1-2 | Full paper outline |
| Methodology Done | Week 2 | Phase 3 | Technical description |
| Results Done | Week 3 | Phase 4 | Experiment chapter |
| Discussion Done | Week 4 | Phase 5 | Interpretation |
| Submission Ready | Week 5 | Phase 6 | Final PDF |

---

## Appendix: Input Document Summary

### From research-brief.json

- **Title:** [title]
- **Target Venue:** [venue]
- **Deadline:** [deadline or "not specified"]
- **Problem:** [problem statement]
- **Novelty:** [novelty statement]

### From literature.md

- **Papers Analyzed:** [count]
- **Categories:** [list from literature.md]
- **Key Gaps:** [from literature.md]

### From methodology.md

- **Datasets:** [list]
- **Baselines:** [list]
- **Metrics:** [list]
- **Components:** [list]
- **Figures Needed:** [count]
```

---

## Step 4: Generate STATE.md

Write to `.planning/STATE.md`:

```markdown
# GSDAW State

**Paper:** [title]
**Updated:** [ISO date]

## Overall Status

| Phase | Status | Completion |
|-------|--------|------------|
| 1. Introduction | pending | 0% |
| 2. Related Work | pending | 0% |
| 3. Methodology | pending | 0% |
| 4. Experiment | pending | 0% |
| 5. Discussion | pending | 0% |
| 6. Conclusion | pending | 0% |

## Current Phase

None — planning complete, awaiting execution.

## Open Issues

(None yet)

## Notes

(Add notes as work progresses)
```

---

## Step 5: Post-Completion Report

After generating ROADMAP.md and STATE.md, report to user:

```
写作计划已生成。

论文分为 6 个阶段：
1. Introduction — 建立研究背景
2. Related Work — 相关工作调研
3. Methodology — 方法论
4. Experiment — 实验
5. Discussion — 讨论
6. Conclusion — 结论

下一步：开始 Phase 1 — Introduction
```

---

## Edge Cases

### Missing Input Documents

| Scenario | Handling |
|----------|----------|
| `research-brief.json` not found | Abort: "错误：未找到研究简报。请先运行 /aw-init。" |
| `literature.md` not found | Abort: "错误：未找到文献总结。请先运行 /aw-research。" |
| `methodology.md` not found | Abort: "错误：未找到方法论设计。请先运行 /aw-methodology。" |
| `discuss-2-summary.md` not found | Skip — proceed without consensus notes |

### Missing Fields in research-brief.json

| Field | Handling |
|-------|----------|
| `title` is null | Use "未命名论文" in ROADMAP |
| `deadline` is null | Use "未指定" — don't calculate duration |
| `targetVenue` is null | Use "未指定" in ROADMAP |

### Deadline Too Short

If days until deadline < 21 (3 weeks):
```
警告：距离截稿日期仅 [X] 天，时间非常紧张。
将优先保证核心章节（Introduction, Methodology, Experiment, Conclusion），
Related Work 和 Discussion 可能需要压缩。
```

---

## Integration Points

| Input | Source | Description |
|-------|--------|-------------|
| Research Brief | `.planning/research-brief.json` | User-approved brief from Questioner |
| Literature Summary | `.planning/literature.md` | From Research Agent |
| Methodology Design | `.planning/methodology.md` | From Methodology Agent |
| Discuss-2 Notes | `.planning/discuss-2-summary.md` | Consensus from consistency check (optional) |

| Output | Destination | Consumed By |
|--------|-------------|-------------|
| Roadmap | `.planning/ROADMAP.md` | User, orchestrator |
| State | `.planning/STATE.md` | User, orchestrator |

---

## File Locations

```
.planning/
├── research-brief.json    ← Input (from aw-questioner)
├── literature.md          ← Input (from aw-research)
├── methodology.md         ← Input (from aw-methodology)
├── discuss-2-summary.md   ← Input (from aw-discuss-2, optional)
├── ROADMAP.md             ← Output (this agent)
└── STATE.md               ← Output (this agent)
```

---

## Usage Examples

- `/aw-plan` — Generate writing roadmap from existing documents
- (Auto-triggered after Discuss #2 confirms consistency)
