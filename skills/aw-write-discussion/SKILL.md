---
name: aw-write-discussion
description: |
  GSDAW Discussion Section Writer — writes Phase 6 (Discussion) of an academic paper.
  Triggers when user approves Results via quality gate after aw-write-results, or explicitly
  runs /aw-write-discussion. Reads results.tex, literature.md, and methodology.md (risks).
  Outputs independent paragraph .tex files to sections/discussion/ for wave aggregation.
---

# Discussion Section Writer

## Purpose

Write the Discussion section (Phase 6) of an academic paper. Interprets results, compares with prior work, acknowledges limitations, and discusses failure cases. Produces four independent paragraph files for wave aggregation by `aw-execute`.

## When to Trigger

- User approves Results via quality gate after `aw-write-results`
- Orchestrator calls this skill during GSDAW `/aw-execute` pipeline
- User explicitly runs `/aw-write-discussion`

## Prerequisites

Before starting, verify:
1. `sections/results.tex` (or paragraph files in `sections/results/`) exists and is approved
2. `.planning/literature.md` exists (prior work context)
3. `.planning/methodology.md` exists (risks and limitations documented)
4. `sections/discussion/` directory exists in the manuscript project

## ⚠️ Factual Integrity (Highest Priority)

All examples in this skill are FORMAT TEMPLATES only. Follow these rules:

### Rule 1: Write Only from Input Files
- If `.planning/methodology.md`, `.planning/literature.md`, `.planning/research-brief.json`, or the results section does **not** contain a specific fact, number, or claim — **do not invent it**
- Mark missing content with `\placeholder{NEEDS: description of what is missing}`
- Less content is better than fabricated content

### Rule 2: Examples Are Format Templates — Never Copy Numbers
- Every `% INPUT REQUIRED` marker below must be filled from actual input data
- **Never copy example values, citations, or claims into the output**

### Rule 3: When Uncertain, Hedge
- "suggests" / "indicates" / "appears" — not "proves" / "demonstrates conclusively"
- "one possible explanation is" / "this pattern may indicate"
- "further investigation is needed to determine"

### Rule 4: Self-Check Before Finalizing
Ask: Is every claim in this paragraph directly supported by an input file? If not, remove it or mark as `\placeholder{}`.

## Workflow

```
aw-write-discussion starts
    │
    ▼
Read: sections/results.tex (or sections/results/*.tex)
    │  Extract: key findings to interpret
    ▼
Read: .planning/literature.md
    │  Extract: prior work comparisons, research gap
    ▼
Read: .planning/methodology.md
    │  Extract: risks, limitations, expected challenges
    ▼
Write: sections/discussion/6-1-interpretation.tex
    │  → What the results mean
    ▼
Write: sections/discussion/6-2-literature-comparison.tex
    │  → How results compare with prior work
    ▼
Write: sections/discussion/6-3-limitations.tex
    │  → Honest acknowledgment of limitations
    ▼
Write: sections/discussion/6-4-failure-cases.tex
    │  → Analysis of when and why method fails
    ▼
Report completion
```

---

## Step 1: Read Results

Read the results section (either consolidated `sections/results.tex` or individual paragraph files) and extract:

### Key Findings to Interpret

| Finding | Where Found | Interpretation Direction |
|---------|-------------|--------------------------|
| SNR improvement magnitude | 5-1, 5-2, 5-3 | Why is the improvement (or not) as expected? |
| Cross-domain transfer | 5-4-generalization.tex | What does the generalization pattern tell us? |
| Ablation impact | 5-6-ablation.tex | Which component matters most and why? |
| Detection precision/recall | 5-5-detection.tex | What drives the high detection rate? |

### Typical Result Patterns to Address

```
Pattern A: Results exceed expectations
→ What factors contributed to better-than-expected performance?
→ Is this reproducible or an artifact?

Pattern B: Results meet expectations
→ Are there any surprising aspects within expected range?
→ Do different datasets show consistent patterns?

Pattern C: Results below expectations
→ What are the plausible explanations?
→ Does ablation reveal why?
→ Is this a fundamental limitation or fixable?

Pattern D: Mixed results across datasets
→ Which conditions favor the method?
→ Is there a common factor in better-performing datasets?
```

---

## Step 2: Read Literature

Read `.planning/literature.md` and extract prior work comparisons:

### Required Fields

| Field | Use |
|-------|-----|
| Research Gap | What the paper addresses that prior work does not |
| Baseline Methods | Methods to compare results against |
| Category weaknesses | Where prior methods fall short |
| Citation keys | For \cite{} in discussion |

### Literature Structure Example

Read `.planning/literature.md` for actual categories, methods, strengths, and weaknesses. **Do not invent literature categories.**

```markdown
% INPUT REQUIRED: Extract from .planning/literature.md
% Categories of related work with methods, strengths, and weaknesses
% Research gap statement from literature.md
```

---

## Step 3: Read Methodology (Risks)

Read `.planning/methodology.md` and extract risk/limitation documentation:

### Risk Categories

% INPUT REQUIRED: Extract risks and limitations from .planning/methodology.md
% If no risks are documented, skip this section

| Risk | Documented Likelihood | Documented Mitigation |
|------|----------------------|----------------------|
| % INPUT REQUIRED: Risk 1 description | % INPUT REQUIRED: Likelihood | % INPUT REQUIRED: Mitigation |
| % INPUT REQUIRED: Risk 2 description | % INPUT REQUIRED: Likelihood | % INPUT REQUIRED: Mitigation |

---

## Step 4: Write Paragraph Files

Write each paragraph as an independent `.tex` snippet using Elsevier LaTeX format.

### Output Locations

```
sections/discussion/
├── 6-1-interpretation.tex       # Result interpretation
├── 6-2-literature-comparison.tex # Comparison with prior work
├── 6-3-limitations.tex          # Honest limitations
└── 6-4-failure-cases.tex        # Failure case analysis
```

---

### File: 6-1-interpretation.tex

**Do not invent interpretations.** Base all claims on actual results from experimental data and the results section.

```latex
\section{Discussion}
\label{sec:discussion}

 paragraph{6.1 Interpretation of Results}

% INPUT REQUIRED: Opening paragraph summarizing the key result patterns to interpret
% From: results section and experimental data

\textbf{INPUT REQUIRED: First finding heading.}
% INPUT REQUIRED: Interpret the first key finding
% - What does this result mean in context of the problem?
% - Why did the method perform this way?
% - Reference actual numbers from results

\textbf{INPUT REQUIRED: Second finding heading.}
% INPUT REQUIRED: Interpret the second key finding
% - Connect to practical implications
% - Use hedge language for interpretations

\textbf{INPUT REQUIRED: Third finding heading.}
% INPUT REQUIRED: Interpret ablation or additional findings
% - Tie results back to architectural design choices
```

---

### File: 6-2-literature-comparison.tex

**Do not invent comparison claims.** Compare only against baselines and literature documented in input files.

```latex
 paragraph{6.2 Comparison with Prior Work}

% INPUT REQUIRED: Opening sentence framing the comparison dimensions
% From: literature.md and results

\textbf{INPUT REQUIRED: First comparison dimension.}
% INPUT REQUIRED: Compare proposed method with specific prior work using \cite{}
% Include actual numbers from both experimental data and literature
% If prior work lacks comparable metrics, note this limitation

\textbf{INPUT REQUIRED: Second comparison dimension.}
% INPUT REQUIRED: Compare detection or secondary metrics
% Use \citeauthor{} for in-text citations

\textbf{INPUT REQUIRED: Third comparison dimension (optional).}
% INPUT REQUIRED: Compare generalization or other dimensions
% Use \cite{} for parenthetical citations
```

---

### File: 6-3-limitations.tex

**Base limitations on actual constraints documented in methodology.md.** Do not invent limitations.

```latex
 paragraph{6.3 Limitations}

% INPUT REQUIRED: Opening sentence acknowledging limitations scope
% Key categories to consider (extract from methodology.md risks section):

\textbf{INPUT REQUIRED: First limitation category.}
% INPUT REQUIRED: Describe the limitation specifically
% - What data or conditions are missing?
% - What impact does this have on generalizability?
% - How could future work address this?

\textbf{INPUT REQUIRED: Second limitation category.}
% INPUT REQUIRED: Describe another limitation
% - Be specific about scope and impact
% - Avoid self-undermining; contextualize within contributions

\textbf{INPUT REQUIRED: Additional limitations as needed.}
% If no limitations are documented, write \placeholder{NEEDS: limitations from methodology.md}
```

---

### File: 6-4-failure-cases.tex

**Base failure cases on actual experimental observations.** Do not invent failure patterns.

```latex
 paragraph{6.4 Failure Case Analysis}

% INPUT REQUIRED: Opening sentence about the value of examining failure cases
% Key patterns to look for (from experimental data):

\textbf{INPUT REQUIRED: First failure pattern.}
% INPUT REQUIRED: Describe the failure case with specific characteristics
% - What conditions trigger this failure?
% - What is the quantified impact?
% - Why does it happen (mechanistic explanation)?

\textbf{INPUT REQUIRED: Second failure pattern.}
% INPUT REQUIRED: Describe another failure case
% - Connect to architectural or data limitations
% - Suggest how to mitigate

\textbf{INPUT REQUIRED: Additional failure patterns as needed.}
% If no failure cases are documented, write \placeholder{NEEDS: failure case analysis from experimental data}
```

---

## Step 5: Elsevier LaTeX Requirements

### Section Structure

```latex
\section{Discussion}
\label{sec:discussion}

% 6.1 Interpretation
% 6.2 Comparison with Prior Work
% 6.3 Limitations
% 6.4 Failure Cases
```

### Citation Style

Use `\citeauthor{}` for text citations and `\cite{}` for parenthetical:
```latex
MethodX \citeauthor{methodx2022} achieves ...
This finding contradicts \cite{zhang2020}.
```

### Emphasis

Use `\textbf{}` for key findings, not asterisks or capitalization:
```latex
The \textbf{largest improvement} occurs on CFRP data.
```

---

## Step 6: Academic Voice Guidelines for Discussion

The Discussion section requires careful balance of confidence and hedging:

### Confident Statements (for clear results)
```latex
The proposed method achieves ...
This improvement is attributable to ...
These results confirm ...
```

### Hedged Statements (for interpretations)
```latex
The results suggest that ...
One possible explanation is ...
This pattern may indicate ...
```

### Limitation Acknowledgment (honest but not self-undermining)
```latex
A limitation of this approach is ...
This constraint may affect ...
Future work could address ...
```

---

## Step 7: Completion Report

After writing all paragraph files, report to user:

```
讨论章节写作完成。

覆盖内容：
- 6-1-interpretation.tex：结果解读（基于实际实验数据）
- 6-2-literature-comparison.tex：与 Prior Work 对比（基于 literature.md）
- 6-3-limitations.tex：局限性分析（基于 methodology.md）
- 6-4-failure-cases.tex：失败案例分析（基于实验观察）

关键洞察：
- 所有解读基于实际数据，未虚构数值
- 所有对比基于文献记录
- 局限性实事求是

下一步：aw-write-conclusion — 撰写结论章节
```

---

## Edge Cases

### Results Disagree with Literature Claims

If results contradict literature expectations:
- Acknowledge the discrepancy directly
- Propose possible explanations
- Do not dismiss prior work; instead, highlight what is different in this study

### No Prior Work for Comparison

If the method addresses a novel problem with no direct baselines:
- Frame comparison around the closest related approaches
- Emphasize the absolute performance levels rather than relative
- Clearly define what constitutes "good" performance in this new domain

### Methodology Risks Materialized

If documented risks occurred during experiments (e.g., baseline didn't reproduce):
- Acknowledge in limitations or failure cases section
- Frame as limitation of evaluation rather than method flaw
- Propose mitigation for future evaluation

---

## Integration Points

| Input | Source | Description |
|-------|--------|-------------|
| Results | `sections/results.tex` or `sections/results/*.tex` | Key findings to interpret |
| Literature | `.planning/literature.md` | Prior work context |
| Methodology | `.planning/methodology.md` | Risks, limitations |

| Output | Destination | Consumed By |
|--------|-------------|-------------|
| 4 paragraph files | `sections/discussion/` | `aw-execute` (wave merger) |
| Discussion draft | `sections/discussion.tex` (via \input) | `aw-review` |

---

## File Locations

```
.planning/
├── literature.md               ← Input: prior work comparisons
└── methodology.md              ← Input: risks, limitations

manuscripts/[paper-name]/sections/discussion/
├── 6-1-interpretation.tex       ← Output
├── 6-2-literature-comparison.tex ← Output
├── 6-3-limitations.tex         ← Output
└── 6-4-failure-cases.tex        ← Output
```

---

## Usage Examples

- `/aw-write-discussion` — Run discussion writing after results approval
- (Auto-triggered by `aw-execute` during Phase 6 wave)
