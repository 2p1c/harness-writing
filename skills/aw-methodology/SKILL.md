---
name: aw-methodology
description: |
  GSDAW Methodology Agent — technical methodology design.
  Triggers when user approves Research Brief (after aw-discuss-1), or runs /aw-methodology.
  Reads research-brief.json to understand the problem and approach, then designs the full
  technical methodology: pipeline architecture, experiment plan, risk assessment.
  Outputs to .planning/methodology.md. Runs parallel with aw-research.
---

# Methodology Agent

## Purpose

Design the complete technical methodology for academic research based on the Research Brief. This agent operates **in parallel with `aw-research`** — no dependency between them. Both feed into Discuss #2 (consistency check).

## When to Trigger

- User approves Research Brief via Discuss #1
- User explicitly runs `/aw-methodology`
- Orchestrator calls this skill during GSDAW pipeline

## Prerequisites

Before starting, verify:
1. `.planning/research-brief.json` exists and is approved
2. User has approved proceeding to parallel research/methodology phase

## Workflow

```
aw-methodology starts
    │
    ▼
Read: .planning/research-brief.json
    │
    ▼
Design Technical Pipeline
    ├── Method Overview
    ├── Architecture Components
    └── Key Innovations
    │
    ▼
Design Experiment Plan
    ├── Datasets
    ├── Baselines
    ├── Evaluation Metrics
    └── Ablation Studies
    │
    ▼
Risk Assessment
    │
    ▼
Expected Results
    │
    ▼
Write: .planning/methodology.md
    │
    ▼
Report completion to user
```

---

## Step 1: Read Research Brief

Read `.planning/research-brief.json` and extract:

### Required Fields

| Field | Path | Use |
|-------|------|-----|
| Research Question | `researchQuestion.problem` | Method rationale |
| Novelty | `researchQuestion.novelty` | Innovation claims |
| Strategy | `researchApproach.strategy` | High-level approach |
| Assumptions | `researchApproach.assumptions` | Design constraints |
| Datasets | `methodology.dataAndExperiments.datasets` | Experiment datasets |
| Metrics | `methodology.evaluationMetrics` | Success criteria |
| Baselines | `methodology.baselines` | Comparison methods |
| Target Venue | `constraints.targetVenue` | Format requirements |

### Research Brief Example Structure

```json
{
  "researchQuestion": {
    "problem": "How to improve X under Y conditions?",
    "novelty": "First method to achieve Z"
  },
  "researchApproach": {
    "strategy": "Use transformer architecture with custom attention",
    "assumptions": ["Data follows distribution Z", "Labels are reliable"]
  },
  "methodology": {
    "dataAndExperiments": {
      "datasets": ["DatasetA", "DatasetB"],
      "existingAssets": "code from paper X"
    },
    "evaluationMetrics": ["Accuracy", "Latency"],
    "baselines": ["MethodX", "MethodY"]
  },
  "constraints": {
    "targetVenue": "ICML 2026"
  }
}
```

---

## Step 2: Technical Pipeline Design

### Section 2.1: Method Overview

Write 2-3 paragraphs:

**Paragraph 1: Problem & Motivation**
- State the problem being solved
- Why existing approaches fail (from brief's gap analysis)
- What this method aims to achieve

**Paragraph 2: High-Level Approach**
- Describe the core idea in technical terms
- How it solves the stated problem
- Key technical decisions

**Paragraph 3: Why This Works**
- Theoretical or empirical rationale
- How it leverages the novelty point
- Expected behavior in edge cases

### Section 2.2: Architecture Components

For each major component (aim for 3-5 components max):

```
1. **Component Name:**
   - **Purpose:** What it does in the pipeline
   - **Technical Detail:** How it works (inputs, outputs, transformations)
   - **Justification:** Why this component is needed for this problem
```

**Example:**
```
1. **Feature Encoder:**
   - **Purpose:** Transform raw input into dense representations
   - **Technical Detail:** 4-layer Transformer encoder with 512 hidden units,
     8 attention heads, GELU activation. Takes tokenized input X and outputs
     sequence of embeddings H = encode(X)
   - **Justification:** Captures long-range dependencies needed for problem Y.
     Alternative: CNN lacks global context; LSTM is slower.
```

### Section 2.3: Key Innovations

List each innovation as a numbered item:

```
1. **[Innovation Name]** — [Why it's novel compared to literature from the brief]
   State what it is and how it differs from prior work.

2. **[Second Innovation]** — [Why novel]
```

**Example:**
```
1. **Cross-Modal Attention Fusion** — Unlike prior work [X] which uses late fusion,
   this method introduces cross-modal attention at layer 3, allowing earlier
   representation negotiation between modalities.

2. **Adaptive Thresholding** — Previous methods use fixed thresholds for
   post-processing. This work proposes a learnable threshold that adapts
   per-sample based on confidence estimation.
```

---

## Step 3: Experiment Design

### Section 3.1: Datasets Table

| Dataset | Size | Split | Justification |
|---------|------|-------|---------------|
| DatasetA | 10K samples | 80/10/10 | Standard benchmark for problem X; used by [citations] |
| DatasetB | 50K samples | 70/15/15 | Larger variant with more diversity; provides cross-domain validation |

**Fields:**
- **Dataset:** Official name
- **Size:** Number of samples or scale indicator
- **Split:** Train/Val/Test ratio
- **Justification:** Why this dataset is appropriate for validating the method

### Section 3.2: Baselines Table

| Baseline | Source | Justification |
|----------|--------|---------------|
| MethodX | [Paper/URL] | Strong baseline; standard comparison in [venue]. Author's official implementation available. |
| MethodY | [Paper/URL] | Most similar approach to ours; fair comparison on [dimension]. |

**Fields:**
- **Baseline:** Method name
- **Source:** Citation or URL to official code
- **Justification:** Why this is a fair comparison

### Section 3.3: Evaluation Metrics Table

| Metric | Definition | Why Selected |
|--------|------------|--------------|
| Accuracy | % of correct predictions | Primary metric for [task type]; allows direct comparison with [baselines] |
| Latency | Inference time in ms | Critical for [application]; reported by [baselines] |
| F1-Score | Harmonic mean of precision/recall | Handles class imbalance in DatasetA |

**Fields:**
- **Metric:** Official metric name
- **Definition:** How it's calculated
- **Why Selected:** Alignment with task and comparability to baselines

### Section 3.4: Ablation Studies Table

| Ablation | Expected Impact | Rationale |
|----------|-----------------|------------|
| Remove Component A | Accuracy drops ~3-5% | Component provides X; without it, model falls back to weaker alternative |
| Replace custom attention with standard | Latency decreases but accuracy drops ~2% | Custom attention adds overhead but captures [specific pattern] |

**Fields:**
- **Ablation:** What component or technique to remove/replace
- **Expected Impact:** Directional and rough quantitative prediction
- **Rationale:** Why this component matters

---

## Step 4: Risk Assessment

### Risk Table

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Baseline X doesn't reproduce | Medium | High | Use official implementation from [URL]; if issues persist, use paper's reported numbers with disclosure |
| Dataset Y has label noise | Low | Medium | Run cross-validation; apply label smoothing; have backup dataset Z |
| GPU memory exceeds limit | Medium | Medium | Reduce batch size; use gradient checkpointing; quantize if needed |
| Experiment runtime too long | Low | Low | Parallelize across datasets; start with smaller dataset first as sanity check |

**Fields:**
- **Risk:** Specific risk item
- **Likelihood:** Low / Medium / High
- **Impact:** Low / Medium / High
- **Mitigation:** Concrete action to reduce risk

---

## Step 5: Expected Results

Quantify predictions where possible. Be specific but honest.

### Main Metric Prediction

```
Expected Main Result:
- [Metric Name]: expect [X]% improvement over best baseline
  - Baseline best: [Y]% (Method Z)
  - Predicted ours: [X+Y]%
  - Reasoning: [brief explanation]
```

### Ablation Predictions

```
Ablation Impact Predictions:
- Removing Component A: expect [Y-Z]% drop in [metric]
- Replacing custom attention: expect [Y-Z]% drop in [metric]
- Using fewer training data (50%): expect [Y-Z]% drop in [metric]
```

### Potential Negative Results

```
Potential Negative Results & Interpretations:
- If accuracy is lower than expected: [possible interpretation]
- If specific ablation has no effect: [possible interpretation]
- If results vary widely across datasets: [possible interpretation]
```

---

## Step 6: Figures Needed

List diagrams to be generated later by `aw-figure`:

```
## Figures Needed

- [ ] Figure 1: Pipeline overview (block diagram showing data flow from input to output)
- [ ] Figure 2: Architecture detail of [Component X] (internal workings)
- [ ] Figure 3: Experiment results comparison (bar chart or table visualization)
- [ ] Figure 4: [Optional - ablation results visualization]
```

---

## Step 7: Output Format

Write the complete methodology to `.planning/methodology.md`:

```markdown
# Methodology Design

**Generated:** [ISO date]
**Based on:** research-brief.json

---

## Technical Pipeline

### Method Overview

[2-3 paragraphs describing the approach]

### Architecture Components

1. **Component A:** [description] → [purpose]
2. **Component B:** [description] → [purpose]
3. **Component C:** [description] → [purpose]

### Key Innovations

1. [Innovation 1] — [why novel]
2. [Innovation 2] — [why novel]

---

## Experiment Design

### Datasets

| Dataset | Size | Split | Justification |
|---------|------|-------|---------------|
| Dataset A | 10K | 80/10/10 | [reason] |
| Dataset B | 50K | 70/15/15 | [reason] |

### Baselines

| Baseline | Source | Justification |
|----------|--------|---------------|
| Method X | [paper/URL] | [reason] |
| Method Y | [paper/URL] | [reason] |

### Evaluation Metrics

| Metric | Definition | Why Selected |
|--------|------------|--------------|
| Accuracy | [def] | [reason] |
| Latency | [def] | [reason] |

### Ablation Studies

| Ablation | Expected Impact | Rationale |
|----------|-----------------|------------|
| Remove Component A | [prediction] | [reason] |
| Replace attention | [prediction] | [reason] |

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Baseline X doesn't reproduce | Medium | High | Use official implementation |
| Dataset Y has label noise | Low | Medium | Cross-validation + label smoothing |

---

## Expected Results

### Main Metric Prediction

Expected [Metric]: [X]% improvement over best baseline ([Y]% → [X+Y]%)

### Ablation Impact Predictions

- Removing Component A: expect [Y-Z]% drop
- Replacing custom attention: expect [Y-Z]% drop

### Potential Negative Results

- If accuracy lower than expected: [interpretation]
- If cross-dataset variance high: [interpretation]

---

## Figures Needed

- [ ] Figure 1: Pipeline overview (block diagram)
- [ ] Figure 2: Architecture detail of [Component X]
- [ ] Figure 3: Experiment results comparison
```

---

## Step 8: Completion Report

After writing the methodology file, report to user in Chinese:

```
方法论设计完成。

核心方法：[1-sentence summary]
实验设计：[N] 个数据集，[M] 个 baselines
风险等级：[Low/Medium/High overall]

下一步：Discuss #2 — 一致性检查（将 Methodology 与 Research 结果对比）
```

**Risk Level Calculation:**
- Low: All risks Low/Medium likelihood, Low/Medium impact
- Medium: Any Medium likelihood + High impact risk
- High: Any High likelihood + High impact risk

---

## Edge Cases

### Missing Research Brief

If `.planning/research-brief.json` does not exist:
```
错误：未找到研究简报 (research-brief.json)。

请先运行 /aw-init 或 /aw-questioner 生成研究简报，
然后在 Discuss #1 确认后再设计方法论。
```

### Partial Research Brief

If required fields are missing:
```
警告：研究简报中缺少以下字段：
- [field name]

方法论设计将基于现有信息进行，部分内容可能需要补充。
请在继续前确认研究简报是否完整。
```

### Empty Baselines/Metrics

If user didn't specify baselines or metrics in brief:
- Propose standard baselines for the problem type
- Use established metrics for the domain
- Mark as "Proposed based on domain standards; adjust as needed"

---

## Integration Points

| Input | Source | Description |
|-------|--------|-------------|
| Research Brief | `.planning/research-brief.json` | User-approved brief from Questioner |

| Output | Destination | Consumed By |
|--------|-------------|-------------|
| Methodology Design | `.planning/methodology.md` | Discuss #2 (consistency check) |
| Figures List | `.planning/methodology.md` | `aw-figure` skill |

---

## File Locations

```
.planning/
├── research-brief.json    ← Input (from aw-questioner)
└── methodology.md         ← Output (this agent)
```

---

## Usage Examples

- `/aw-methodology` — Run methodology design for approved brief
- (Auto-triggered after Discuss #1 approves Research Brief)
