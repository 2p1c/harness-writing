---
name: aw-write-experiment
description: |
  GSDAW Experiment Section Writer — generates Phase 4 (Experiment) paragraph files.
  Triggered by /aw-write-experiment or by aw-execute during wave execution.
  Reads .planning/methodology.md (datasets, baselines, metrics, ablation sections)
  to generate experiment section paragraphs in Elsevier LaTeX format.
  Outputs independent paragraph .tex files to sections/experiment/ directory.
---

# aw-write-experiment — Experiment Section Writer

## Purpose

Write the Experiment section of an academic paper (Phase 4 of IMRAD) by generating independent paragraph files that are later merged into a complete chapter by `aw-execute`.

This skill is a **section-writing subagent** called by the Wave Executor during Phase 2. It receives a specific task (e.g., "Write 4.1 Dataset Description") and outputs a single paragraph `.tex` file.

## ⚠️ Factual Integrity (Highest Priority)

All examples in this skill are FORMAT TEMPLATES only. Follow these rules:

### Rule 1: Write Only from Input Files
- If `.planning/methodology.md`, `.planning/research-brief.json`, or `.planning/literature.md` does **not** contain a specific fact, number, or claim — **do not invent it**
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

## When to Trigger

- `aw-execute` wave executor calls this skill with a specific task
- User runs `/aw-write-experiment` directly
- Orchestrator delegates during GSDAW pipeline execution

## Inputs

| Input | Source | Description |
|-------|--------|-------------|
| Task description | Wave executor (objective field) | Which paragraph to write (e.g., "4.1 Dataset Description") |
| `research-brief.json` | `.planning/research-brief.json` | Author intent, novelty claims |
| `methodology.md` | `.planning/methodology.md` | Full experiment design — datasets, baselines, metrics, ablation |
| `literature.md` | `.planning/literature.md` | Related work context (for baseline positioning) |
| Elsevier template | `templates/elsevier/` | LaTeX format reference |

## Outputs

Paragraph files written to `sections/experiment/` with naming convention `{task-id}.tex`:

| File | Task ID | Content |
|------|---------|---------|
| `sections/experiment/4-1-datasets.tex` | 4.1 | Dataset description with dataset table |
| `sections/experiment/4-2-baselines.tex` | 4.2 | Baseline method configurations |
| `sections/experiment/4-3-metrics.tex` | 4.3 | Evaluation metric definitions |
| `sections/experiment/4-4-ablation.tex` | 4.4 | Ablation study setup |

### Dataset Table Format

**Do not invent dataset details.** Fill from methodology.md experiment design section.

```latex
% INPUT REQUIRED: Dataset table from methodology.md
% If no dataset is described, write \placeholder{NEEDS: dataset description}
\begin{table}[htbp]
\centering
\caption{INPUT REQUIRED: Dataset table caption}
\label{tab:datasets}
% INPUT REQUIRED: Fill table rows from methodology.md experiment design section
% Columns vary by paper. Typical columns: Test Set, Source, Material, Size, SNR Range
\begin{tabular}{llcccc}
    \toprule
    % INPUT REQUIRED: Column headers matching the dataset
    \midrule
    % INPUT REQUIRED: Each dataset row (training, validation, test sets)
    \bottomrule
\end{tabular}
\end{table}
```

### Baseline Configuration Table

**Do not invent baseline methods.** Fill from methodology.md experiment design section.

```latex
% INPUT REQUIRED: Baseline methods table from methodology.md
% If no baselines are described, write \placeholder{NEEDS: baseline methods}
\begin{table}[htbp]
\centering
\caption{INPUT REQUIRED: Baseline methods caption}
\label{tab:baselines}
% INPUT REQUIRED: Fill table rows from methodology.md baselines section
% Typical columns: Method, Configuration, Implementation
\begin{tabular}{lll}
    \toprule
    Method & Configuration & Implementation \\
    \midrule
    % INPUT REQUIRED: Each baseline method row
    \bottomrule
\end{tabular}
\end{table}
```

### Evaluation Metrics Definitions

**Define only metrics documented in methodology.md.** Do not invent metric names or formulas.

```latex
\subsection{Evaluation Metrics}

% INPUT REQUIRED: Brief intro to evaluation metrics from methodology.md

% INPUT REQUIRED: For each metric documented in methodology.md:
% - Metric name and what it measures
% - Formula using \[ ... \] display math
% - Brief description of interpretation
% If no metrics are documented, write \placeholder{NEEDS: evaluation metrics}
```

## Workflow

```
aw-write-experiment invoked with task "4.1 Dataset Description"
    │
    ▼
Read: .planning/methodology.md (Experiment Design section)
    │
    ▼
Read: .planning/research-brief.json (novelty)
    │
    ▼
Read: templates/elsevier/ (LaTeX format)
    │
    ▼
Write: sections/experiment/4-1-datasets.tex
    │
    ▼
Return completion with word count and preview
```

## Step-by-Step Execution

### Step 1: Read Inputs

Read `.planning/methodology.md` Section 3 (Experiment Design):
- 3.1 Datasets (training, validation, test sets)
- 3.2 Baseline Methods (configurations)
- 3.3 Evaluation Metrics (definitions)
- 3.4 Ablation Studies (variants)
- 3.5 Statistical Analysis (seed, significance testing)

Also read `.planning/research-brief.json` for novelty claims relevant to experimental validation.

### Step 2: Extract Content per Task

**4-1-datasets.tex — Dataset Description:**
- % INPUT REQUIRED: Training set composition (size, source, characteristics) from methodology.md
- % INPUT REQUIRED: Validation and test set splits
- % INPUT REQUIRED: Materials, defect types, and signal specifications
- % INPUT REQUIRED: Key dataset parameters (sample rate, signal length, SNR range)

**4-2-baselines.tex — Baseline Methods:**
- % INPUT REQUIRED: Each baseline method name and configuration from methodology.md
- % INPUT REQUIRED: Implementation details or library references
- % INPUT REQUIRED: Justification for why these are fair comparisons

**4-3-metrics.tex — Evaluation Metrics:**
- % INPUT REQUIRED: Primary evaluation metric with formula
- % INPUT REQUIRED: Secondary metrics with formulas or definitions
- % INPUT REQUIRED: Target values or expected ranges if documented

**4-4-ablation.tex — Ablation Studies:**
- % INPUT REQUIRED: Ablation study variants from methodology.md
- % INPUT REQUIRED: What each variant removes or modifies
- % INPUT REQUIRED: Expected impact or hypothesis for each ablation

### Step 3: Write Paragraph File

Write the `.tex` file with:
1. `\paragraph{Section Title}` heading with label
2. Running text with technical detail
3. Tables using `booktabs` format
4. Metric definitions with inline math
5. Cross-references via `\ref{tab:}`

### Step 4: Verify Output

- At least 150 words per paragraph
- Academic register
- Elsevier citation format
- Tables use `booktabs`
- No hardcoded numbers in `\ref{}`
- No TODO/FIXME placeholders

### Step 5: Report Completion

```
Paragraph 4.1 (Dataset Description) written.
Word count: 312
File: sections/experiment/4-1-datasets.tex
Preview: "The training dataset consists of 10,000 paired noisy-clean A-scan signals..."
```

## Elsevier LaTeX Conventions

Same as `aw-write-methodology`:
- `\documentclass[review]{elsarticle}`
- `\usepackage{booktabs}` for tables
- `\cite{key}` for numbered citations
- `\ref{tab:}`, `\ref{fig:}`, `\ref{eq:}` for cross-references

## Error Handling

### Missing methodology.md

```
错误：未找到方法论设计文件 (.planning/methodology.md)。

请先运行 /aw-methodology 生成实验设计，
或确认方法论已通过 Discuss #2 审批。
```

### Incomplete Experiment Design

If a section is missing content:
- Write available content with `\placeholder{NEEDS: description of missing content}`
- Report in completion message

## File Locations

```
manuscripts/[paper-name]/
├── .planning/
│   ├── research-brief.json
│   ├── methodology.md         ← Primary input
│   └── literature.md
├── templates/elsevier/
└── sections/
    └── experiment/
        ├── 4-1-datasets.tex       ← Output
        ├── 4-2-baselines.tex      ← Output
        ├── 4-3-metrics.tex        ← Output
        └── 4-4-ablation.tex       ← Output
```

## Integration Points

| Connection | Agent/File | Direction |
|------------|------------|-----------|
| Called by | `aw-execute` (Wave Executor) | Input: task |
| Feeds into | `aw-execute` (Phase Merger) | Output: paragraphs |
| Reads | `.planning/methodology.md` | Input |
| Later review | `aw-review` | After wave |

## Quality Gate Checklist

- [ ] At least 150 words in paragraph
- [ ] Academic register
- [ ] Elsevier citation format
- [ ] Dataset table uses `booktabs`
- [ ] Baseline table uses `booktabs`
- [ ] Metric definitions include formulas
- [ ] No hardcoded numbers in cross-references
- [ ] No TODO/FIXME placeholders (use `\placeholder{}` for missing content)
- [ ] File saved to correct path `sections/experiment/{filename}.tex`