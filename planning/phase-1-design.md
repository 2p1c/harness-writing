# GSDAW Phase 1: Core Orchestration Framework

**Phase:** 1 of GSDAW Framework Development
**Status:** Design Draft — Pending User Approval
**Branch:** `gsdam-phase-1-design`

## What This Phase Does

Phase 1 builds the **core orchestration engine** of GSDAW:
1. User Questioner Agent with deep questioning + session reuse
2. Research Agent + Methodology Agent in parallel with Discuss #2 reconciliation
3. Planning Agent with coarse-grained roadmap
4. Discuss Agent checkpoints at each critical transition

**This phase does NOT implement:**
- Wave execution engine (Phase 2)
- Individual section writing agents (Phase 3+)
- Citation verification or figure generation (later phases)

---

## Phase 1 Architecture

### High-Level Flow

```
/aw-init
    │
    ▼
┌──────────────────────────────────────────────────────┐
│  USER QUESTIONER AGENT                               │
│  - Deep questioning (5 categories)                    │
│  - Generates Research Brief                           │
│  - Auto-detects & offers to reuse prior brief         │
└─────────────────────┬────────────────────────────────┘
                      │ Research Brief
                      ▼
┌──────────────────────────────────────────────────────┐
│  DISCUSS AGENT #1 — Confirm Research Brief            │
│  "Your research question is X, your approach is Y..." │
└─────────────────────┬────────────────────────────────┘
                      │ User approves
          ┌───────────┴───────────┐
          │                       │
          ▼                       ▼
┌─────────────────┐     ┌─────────────────────────┐
│  RESEARCH AGENT │     │  METHODOLOGY AGENT      │
│  (Parallel)     │     │  (Parallel)             │
│                 │     │                         │
│  - arXiv search │     │  - Technical pipeline    │
│  - Literature   │     │  - Experiment design    │
│    matrix       │     │  - Risk assessment       │
│  - Gap analysis │     │  - Expected results     │
└────────┬────────┘     └─────────────┬───────────┘
         │                           │
         └───────────┬───────────────┘
                     │ Both outputs
                     ▼
┌──────────────────────────────────────────────────────┐
│  DISCUSS AGENT #2 — Consistency Check                 │
│  - Compare Literature vs Methodology                 │
│  - If conflict → "Re-examine" mode                    │
│  - User decides: adjust / proceed / abort            │
└─────────────────────┬────────────────────────────────┘
                      │ User approves adjusted direction
                      ▼
┌──────────────────────────────────────────────────────┐
│  PLANNING AGENT                                      │
│  - Reads: Brief + Literature + Methodology           │
│  - Outputs: ROADMAP.md (coarse-grained by chapter)   │
│  - Each chapter = one phase in roadmap               │
└─────────────────────┬────────────────────────────────┘
                      │ Draft plan
                      ▼
┌──────────────────────────────────────────────────────┐
│  DISCUSS AGENT #3 — Final Plan Approval              │
│  "The plan has 7 phases, estimated X days..."        │
└─────────────────────┬────────────────────────────────┘
                      │ User approves
                      ▼
┌──────────────────────────────────────────────────────┐
│  PHASE 1 COMPLETE                                    │
│  Next: /aw-execute-phase 1                           │
└──────────────────────────────────────────────────────┘
```

---

## Agent Specifications

### 1. User Questioner Agent

**Type:** Orchestrator skill (`aw-questioner`)
**Trigger:** `/aw-init` or "开始写论文" / "new paper"
**Location:** `skills/aw-questioner/SKILL.md`

#### Session Reuse Logic

```javascript
// Pseudocode for session detection
if (exists(".planning/research-brief.json")) {
  // Offer reuse
  askUser("检测到上次的研究简报: [title]。是否继续使用？");
  if (user == "reuse") {
    loadBrief(".planning/research-brief.json");
    askUser("这次有什么变化吗？需要更新哪些部分？");
  } else if (user == "new") {
    startFreshQuestioning();
  }
} else {
  startFreshQuestioning();
}
```

#### Questioning Categories

Each category answered thoroughly before moving to next:

**Category 1: Research Question (研究问题)**
Questions to ask:
1. "你的研究要解决什么问题？" — 1-2 sentence problem statement
2. "这个问题的核心创新点是什么？" — novelty, not just incremental
3. "现有方法有什么主要缺陷？" — why existing methods fail
4. "你的研究对这个领域有什么影响？" — broader impact

**Category 2: Research Approach (研究思路)**
Questions to ask:
1. "你打算用什么思路解决这个问题？" — high-level strategy
2. "你的方法的核心假设是什么？" — key assumptions
3. "为什么这个思路比其他思路更好？" — comparison to alternatives

**Category 3: Methodology (研究方法)**
Questions to ask:
1. "你用什么数据/实验来验证？" — datasets, simulations, experiments
2. "你用什么评估指标？" — metrics, benchmarks
3. "你和哪些 baseline 比较？" — comparison methods
4. "你有现成的代码/工具吗？" — existing assets
5. "实验预计要多久跑完？" — time constraints

**Category 4: Constraints (约束条件)**
Questions to ask:
1. "目标期刊/会议是哪个？" — target venue + format requirements
2. "有截稿日期吗？" — deadline (hard or soft)
3. "有字数限制吗？" — page limit or word count
4. "需要特殊格式（如双栏、cover letter）吗？" — format quirks

**Category 5: Materials (参考资料)**
Questions to ask:
1. "你有哪些现成材料？" — drafts, notes, data, figures
2. "有必须引用的文献吗？" — key references to include
3. "有参考的论文风格吗？" — style reference
4. "有什么特别需要注意的点？" — red lines, non-negotiables

#### Research Brief Output Format

```markdown
# Research Brief

**Created:** YYYY-MM-DD
**Last Updated:** YYYY-MM-DD

## Research Question
[Core problem statement]

## Novelty / Contribution
[What makes this work novel]

## Research Approach
[High-level strategy and assumptions]

## Methodology

### Data & Experiments
- **Datasets:** [list]
- **Evaluation Metrics:** [list]
- **Baselines:** [list]
- **Existing Assets:** [code/datasets available]

### Expected Timeline
[Estimated experiment runtime]

## Constraints

### Target Venue
- **Journal/Conference:** [name]
- **Format:** [format requirements]
- **Deadline:** [date or "none"]
- **Word/Page Limit:** [limit]

## Materials Available
- [ ] Drafts/Notes
- [ ] Data
- [ ] Figures
- [ ] Code
- [ ] Key References

## Notes & Red Lines
[User-specified non-negotiables]
```

---

### 2. Discuss Agent #1

**Type:** Checkpoint skill (`aw-discuss-1`)
**Trigger:** Automatic after Questioner completes
**Purpose:** Confirm Research Brief accuracy before proceeding

**Output format:**
```
## 研究简报确认

我已经了解了以下内容：

**研究问题:** [X]
**创新点:** [Y]
**方法思路:** [Z]
**目标期刊:** [期刊名]
**截稿日期:** [日期/无]

是这样的吗？有什么需要补充或调整的？
```

**User choices:**
- "确认" → Proceed to parallel agents
- "补充" → Follow-up questions on specific category
- "重新开始" → Restart from Questioner

---

### 3. Research Agent

**Type:** Sub-agent skill (`aw-research`)
**Trigger:** Discuss #1 approved
**Parallel with:** Methodology Agent
**Location:** `skills/aw-research/SKILL.md`

#### Responsibilities

1. **Literature Search**
   - Query arXiv, Semantic Scholar, CrossRef by research question keywords
   - Prioritize: recent papers (2022+), highly-cited, from top venues
   - Limit: 30-50 most relevant papers initially

2. **Literature Matrix Generation**
   - For each paper: title, authors, year, venue, method, dataset, results, limitations
   - Group by: approach type, application domain, evaluation methodology

3. **Gap Analysis**
   - Identify: what problems remain unsolved
   - Identify: what approaches have been tried and failed
   - Identify: my research fills which gap

4. **Citation Network**
   - Build reference graph (which paper cites which)
   - Identify: seminal papers everyone cites
   - Identify: contested claims (papers arguing against each other)

#### Output: Literature Summary

```markdown
# Literature Summary

**Research Question:** [from Brief]
**Generated:** YYYY-MM-DD
**Papers Analyzed:** [count]

## Related Work by Category

### Category: [Method Type A]
| Paper | Year | Method | Dataset | Key Result | Gap Addressed |
|-------|------|--------|---------|------------|---------------|
| [Citation] | 2023 | Transformer | ImageNet | 95.2% acc | Long-range dep |

### Category: [Method Type B]
...

## Research Gaps

1. **[Gap 1]:** [description] — [which papers identify this]
2. **[Gap 2]:** [description] — [which papers identify this]

## My Research Positioning

**Gap I Fill:** [specific gap]
**Why Existing Methods Fail:** [reason]
**How My Approach Addresses:** [reasoning]

## Key References (Must Cite)
- [list of 5-10 most important papers]

## References
[full bibliography in BibTeX format]
```

---

### 4. Methodology Agent

**Type:** Sub-agent skill (`aw-methodology`)
**Trigger:** Discuss #1 approved
**Parallel with:** Research Agent
**Location:** `skills/aw-methodology/SKILL.md`

#### Responsibilities

1. **Technical Pipeline Design**
   - Full description of proposed method
   - Architecture diagrams needed (specify for figure-agent later)
   - Algorithm steps (pseudo-code if applicable)
   - Key hyperparameters and rationale

2. **Experiment Design**
   - **Datasets:** Which datasets, why, how split (train/val/test)
   - **Baselines:** Which baselines, why, how to compare fairly
   - **Metrics:** Which metrics, why, how to measure
   - **Ablations:** What to ablate, why each matters

3. **Risk Assessment**
   - For each component: risk level (low/medium/high) + mitigation
   - Timeline estimation for each experiment
   - Fallback plans if something fails

4. **Expected Results**
   - Predicted outcomes for main metrics
   - Expected improvements over baselines (quantitative if possible)
   - Potential negative results and their meaning

#### Output: Methodology Design

```markdown
# Methodology Design

**Generated:** YYYY-MM-DD

## Technical Pipeline

### Method Overview
[2-3 paragraph description of the approach]

### Architecture Components
1. **Component A:** [description] → [purpose]
2. **Component B:** [description] → [purpose]
3. ...

### Key Innovations
1. [Innovation 1] — [why novel]
2. [Innovation 2] — [why novel]

## Experiment Design

### Datasets
| Dataset | Size | Split | Justification |
|---------|------|-------|---------------|
| Dataset A | 10K | 80/10/10 | [reason] |

### Baselines
| Baseline | Source | Justification |
|----------|--------|---------------|
| Method X | [paper] | [reason] |

### Evaluation Metrics
| Metric | Definition | Why Selected |
|--------|------------|--------------|
| Accuracy | [def] | [reason] |

### Ablation Studies
| Ablation | Expected Impact |
|----------|-----------------|
| Remove Component A | [prediction] |

## Risks & Mitigations
| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Baseline X doesn't reproduce | Medium | Use official impl |

## Expected Results
[Quantitative predictions with reasoning]

## Figures Needed
- [ ] Figure 1: Pipeline overview
- [ ] Figure 2: Architecture detail
- [ ] Figure 3: Experiment results
```

---

### 5. Discuss Agent #2

**Type:** Checkpoint skill (`aw-discuss-2`)
**Trigger:** Automatic after Research + Methodology complete
**Purpose:** Consistency check + conflict resolution

**Consistency Check Points:**
1. Does Literature confirm the gap? (methodology addresses real gap)
2. Does Literature validate the approach? (similar methods succeeded)
3. Are the baselines in Literature actually comparable?
4. Are the datasets used in methodology realistic?

**If consistent:**
```
## 一致性检查通过

文献调研发现该方向有 [X] 篇相关工作，其中 [Y] 篇提出了类似方法。
你的方法解决了文献中提到的 [gap] 问题。

可以继续制定计划。
```

**If conflict detected:**
```
## ⚠️ 检测到不一致

文献调研发现：
- [Finding 1]

方法设计：
- [Finding 2]

这两者存在矛盾：[具体矛盾描述]

请选择处理方式：
1. 调整方法设计（[选项]）
2. 调整研究范围（[选项]）
3. 接受矛盾继续（解释原因）
4. 重新开始（回到 Questioner）
```

---

### 6. Planning Agent

**Type:** Sub-agent skill (`aw-planner`)
**Trigger:** Discuss #2 approved
**Location:** `skills/aw-planner/SKILL.md`

#### Responsibilities

1. **Phase Decomposition**
   - Break paper into logical phases (by chapter)
   - Each phase has: goal, task list, success criteria, dependencies

2. **Dependency Analysis**
   - Map which phases depend on which outputs
   - Identify which can run in parallel (Wave concept)

3. **Effort Estimation**
   - Rough time estimate per phase
   - Critical path identification

#### Output: ROADMAP.md

```markdown
# GSDAW Roadmap

**Paper:** [title from Brief]
**Target:** [journal]
**Estimated Duration:** [X weeks]
**Created:** YYYY-MM-DD

---

## Phase Dependencies

```
Phase 1 (Introduction)
Phase 2 (Related Work)    ← needs Phase 1 + Literature
Phase 3 (Methodology)    ← needs Phase 2
Phase 4 (Experiment)     ← needs Phase 3
Phase 5 (Results)        ← needs Phase 4
Phase 6 (Discussion)     ← needs Phase 5
Phase 7 (Conclusion)     ← needs Phase 6
```

---

## Phase 1: Introduction

**Goal:** Establish research context and motivation

**Dependencies:** None
**Estimated Duration:** [X days]

**Tasks:**
- [ ] 1.1 Research background (2-3 paragraphs)
- [ ] 1.2 Problem definition (1 paragraph)
- [ ] 1.3 Main contributions (3-4 bullet points)
- [ ] 1.4 Paper structure overview

**Success Criteria:**
1. Reader understands why this problem matters
2. Reader knows the 3 main contributions
3. Structure is clear and logical

---

## Phase 2: Related Work

**Goal:** Position work in context of existing research

**Dependencies:** Phase 1, Literature Summary
**Estimated Duration:** [X days]

**Tasks:**
- [ ] 2.1 Categorize existing methods
- [ ] 2.2 Discuss each category's strengths/weaknesses
- [ ] 2.3 Highlight research gap
- [ ] 2.4 Natural transition to proposed method

**Success Criteria:**
1. Covers major related work
2. Categorization is logical and defensible
3. Gap clearly sets up the proposed method

[... Phases 3-7 follow same pattern ...]
```

---

### 7. Discuss Agent #3

**Type:** Checkpoint skill (`aw-discuss-3`)
**Trigger:** Automatic after Planning Agent completes
**Purpose:** Final plan approval before execution

**Output format:**
```
## 写作计划确认

论文标题: [title]
目标期刊: [journal]
预计总时长: [X weeks]

### 计划概览

| Phase | 内容 | 预计时长 | 依赖 |
|-------|------|---------|------|
| 1 | Introduction | X days | - |
| 2 | Related Work | X days | Phase 1 |
| ... | ... | ... | ... |

### 关键里程碑
- 第 1 周: 完成 Introduction + Related Work
- 第 2 周: 完成 Methodology
- ...

这个计划你觉得合理吗？有需要调整的吗？
```

**User choices:**
- "确认" → Commit plan, ready for `/aw-execute-phase 1`
- "调整" → Specify which phase to modify, re-run Planner with feedback
- "查看详情" → Show full ROADMAP.md

---

## Skill File Structure (Phase 1)

```
skills/aw-questioner/SKILL.md         # User Questioner Agent
skills/aw-discuss-1/SKILL.md         # Discuss #1 (Brief confirmation)
skills/aw-research/SKILL.md          # Research Agent
skills/aw-methodology/SKILL.md       # Methodology Agent
skills/aw-discuss-2/SKILL.md         # Discuss #2 (Consistency check)
skills/aw-planner/SKILL.md            # Planning Agent
skills/aw-discuss-3/SKILL.md         # Discuss #3 (Plan approval)
skills/aw-orchestrator/SKILL.md      # Master orchestrator (glues all together)
```

**Command triggers:**
```yaml
/aw-init      → aw-questioner
/aw-discuss-1 → aw-discuss-1 (usually auto-triggered)
/aw-research  → aw-research (usually auto-triggered)
/aw-methodology → aw-methodology (usually auto-triggered)
/aw-discuss-2 → aw-discuss-2 (usually auto-triggered)
/aw-plan      → aw-planner
/aw-discuss-3 → aw-discuss-3 (usually auto-triggered)
```

---

## Phase 1 文件输出

| File | Location | Created By |
|------|----------|------------|
| Research Brief | `.planning/research-brief.json` | Questioner |
| Literature Summary | `.planning/literature.md` | Research Agent |
| Methodology Design | `.planning/methodology.md` | Methodology Agent |
| ROADMAP | `.planning/ROADMAP.md` | Planning Agent |
| STATE | `.planning/STATE.md` | Orchestrator |
| Project Context | `manuscripts/[slug]/project.yaml` | Orchestrator |

---

## Open Questions — RESOLVED

| # | Question | Decision | Rationale |
|---|----------|----------|-----------|
| 1 | Research Brief persistence | `.planning/research-brief.json` + `.gitignore` | Project-specific, git-tracked but not pushed |
| 2 | Literature search method | Local SQLite (priority) → Zotero API → PDF folder | Three-tier cascade, no API key needed for local Zotero; verified working |
| 5 | Distribution format | npm package (`harness-writing`) | `npx skills add harness-writing` auto-discovers all `skills/` subdirectories as individual skills |
| 3 | Initial paper count | 20 papers | Balanced speed vs coverage |
| 4 | Quick mode | `/aw-init --quick` skips Discuss checkpoints | For experienced users who know their research |

### Zotero Integration Notes

Three-tier literature search cascade:

1. **Local Zotero SQLite** (priority — no API key needed)
   - Read `~/Zotero/zotero.sqlite` directly
   - PDFs from `~/Zotero/storage/`
   - Uses `build_zotero_context.py` (verified working with pypdf 6.10.0)

2. **Zotero HTTP API** (fallback — requires API key)
   - Ask user for `ZOTERO_API_KEY`
   - `https://api.zotero.org` with 100 req/s rate limit

3. **User-provided PDF folder** (last resort)
   - User points to a folder of `.pdf` files
   - Extract with `pypdf` or `pdf` skill

PDF reading pipeline (verified):
```
Local SQLite → storage/{key}/file.pdf → markitdown → structured Markdown
                                                         ↓
                                          Sub-agent analyze: method, dataset, results, limitations
                                                         ↓
                                          Evidence passage ranking (keyword hits + length score)
                                                         ↓
                                          Store in Literature.md
```

**markitdown** (`conda install -c conda-forge markitdown`) converts PDFs to Markdown with headers, lists, and tables preserved — cleaner for agent analysis than raw pypdf text.

### Quick Mode Flag

```bash
/aw-init --quick    # Skip all Discuss checkpoints, run full pipeline
/aw-init             # Interactive mode with Discuss checkpoints (default)
```

---

## Status

- [x] Phase 1 design drafted
- [x] Discuss with user → resolve open questions
- [x] User approves design
- [x] npm package distribution architecture confirmed
- [x] Three-tier Zotero cascade verified (local SQLite + API + PDF folder)
- [x] Implement Phase 1 skills (all 8 skills in `skills/` dir)
- [x] Create `package.json` for npm publishing
- [ ] Test `/aw-init` with real paper project
- [ ] Phase 1 complete → proceed to Phase 2

## npm Package Structure

```
harness-writing/                 # npm package root
├── package.json                 # `npm publish` ready
├── skills/                      # ← npx skills add auto-scans this
│   ├── aw-questioner/
│   ├── aw-discuss-1/
│   ├── aw-discuss-2/
│   ├── aw-discuss-3/
│   ├── aw-research/
│   ├── aw-methodology/
│   ├── aw-planner/
│   └── aw-orchestrator/
├── scripts/
│   └── build_zotero_context.py  # Shared literature extraction tool
└── README.md
```

**Install:** `npx skills add harness-writing` → discovers all `skills/` subdirectories as individual commands (`/aw-init`, `/aw-questioner`, etc.)
