---
name: aw-write-results
description: |
  GSDAW Results Section Writer — writes Phase 5 (Results) of an academic paper.
  Triggers when user approves Methodology via Discuss #3 and runs /aw-execute, or explicitly
  runs /aw-write-results. Reads methodology.md for metrics/baselines and experimental data/notes.
  Outputs independent paragraph .tex files to sections/results/ for wave aggregation.
---

# Results Section Writer

## Purpose

Write the Results section (Phase 5) of an academic paper based on the approved Methodology and experimental data. Produces six independent paragraph files for wave aggregation by `aw-execute`.

## When to Trigger

- User approves Methodology via Discuss #3
- Orchestrator calls this skill during GSDAW `/aw-execute` pipeline
- User explicitly runs `/aw-write-results`

## Prerequisites

Before starting, verify:
1. `.planning/methodology.md` exists and is approved
2. Experimental data or notes exist (either in `.planning/experimental-data/` or referenced in methodology.md)
3. `sections/results/` directory exists in the manuscript project

## ⚠️ Factual Integrity (Highest Priority)

All examples in this skill are FORMAT TEMPLATES only. Follow these rules:

### Rule 1: Write Only from Input Files
- If `.planning/methodology.md`, `.planning/research-brief.json`, or experimental data files do **not** contain a specific fact, number, or claim — **do not invent it**
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
aw-write-results starts
    │
    ▼
Read: .planning/methodology.md
    │  Extract: metrics, baselines, ablation studies, expected results
    ▼
Locate: Experimental data / notes
    │  Check: .planning/experimental-data/, .planning/notes/, or inline in methodology.md
    ▼
Write: sections/results/5-1-simulated.tex
    │  → Results on simulated dataset
    ▼
Write: sections/results/5-2-aluminum.tex
    │  → Results on aluminum dataset
    ▼
Write: sections/results/5-3-cfrp.tex
    │  → Results on CFRP dataset
    ▼
Write: sections/results/5-4-generalization.tex
    │  → Cross-domain generalization results
    ▼
Write: sections/results/5-5-detection.tex
    │  → Detection accuracy / precision results
    ▼
Write: sections/results/5-6-ablation.tex
    │  → Ablation study results
    ▼
Report completion
```

---

## Step 1: Read Methodology

Read `.planning/methodology.md` and extract:

### Required Fields

| Field | Section | Use |
|-------|---------|-----|
| Datasets | Experiment Design / Datasets | Which datasets to report results for |
| Baselines | Experiment Design / Baselines | Comparison targets |
| Evaluation Metrics | Experiment Design / Evaluation Metrics | What to measure |
| Ablation Studies | Experiment Design / Ablation Studies | What components to ablate |
| Expected Results | Expected Results | Baseline predictions for comparison |
| SNR Metrics | (if applicable) | Signal-to-noise improvement tables |

### Expected Methodology Structure

Your methodology.md may contain sections like datasets, baselines, evaluation metrics, and ablation studies. Extract content from the actual file. Do not assume any section exists.

```markdown
% INPUT REQUIRED: Fill from actual methodology.md structure
% Common sections to look for:
% - Datasets (table with size, split, justification)
% - Baselines (method name, source, justification)
% - Evaluation Metrics (metric name, definition, reason)
% - Ablation Studies (variant, expected impact, rationale)
% If any section is missing, skip it or mark \placeholder{NEEDS: [section name]}
```

---

## Step 2: Locate Experimental Data

Check for experimental data in the following locations (in priority order):

1. `.planning/experimental-data/results.yaml` or `.planning/experimental-data/results.json`
2. `.planning/notes/` directory with per-dataset result files
3. Inline in `.planning/methodology.md` under "Expected Results"
4. `sections/experiment.tex` if experiment section was already written

### Experimental Data Format (if YAML/JSON)

Experimental data structure varies by paper. Read the actual data file and use the keys/values it contains. **Do not invent experimental results.**

```yaml
# Expected format: .planning/experimental-data/results.yaml or results.json
# Structure depends on the specific paper's datasets and metrics
# Example (replace with actual keys from data file):
# % INPUT REQUIRED: per-dataset results from experimental data
# % INPUT REQUIRED: per-ablation results from experimental data
```

### Data Not Available

If no experimental data exists:
```
错误：未找到实验数据。

请提供以下任一位置的实验结果：
1. .planning/experimental-data/results.yaml
2. .planning/notes/ 目录下的结果文件
3. .planning/methodology.md 中的 Expected Results 部分

或者先运行实验并将结果记录到上述位置。
```

---

## Step 3: Write Paragraph Files

Write each paragraph as an independent `.tex` snippet. Use Elsevier LaTeX format with booktabs tables.

### Output Locations

```
sections/results/
├── 5-1-simulated.tex      # Results on simulated dataset
├── 5-2-aluminum.tex       # Results on aluminum dataset
├── 5-3-cfrp.tex           # Results on CFRP dataset
├── 5-4-generalization.tex # Cross-domain generalization
├── 5-5-detection.tex      # Detection accuracy / precision
└── 5-6-ablation.tex       # Ablation study results
```

---

### File: 5-1-simulated.tex

**Do not invent results.** Fill tables and values from experimental data only.

```latex
\section{Results on Simulated Dataset}
\label{sec:results-simulated}

 paragraph{5.1 Simulated Dataset Results}

% INPUT REQUIRED: Opening context paragraph describing the simulated dataset and its purpose
% From: methodology.md experiment design section

% INPUT REQUIRED: Results table from experimental data
% Use booktabs format. Bold the best result in each column.
\begin{table}[htbp]
    \caption{INPUT REQUIRED: Table caption}
    \label{tab:simulated-results}
    \begin{tabular}{lcc}
        \toprule
        % INPUT REQUIRED: Column headers from experimental data
        \midrule
        % INPUT REQUIRED: Each baseline method row with results
        \midrule
        % INPUT REQUIRED: Proposed method row with results
        \bottomrule
    \end{tabular}
\end{table}

% INPUT REQUIRED: 1-2 paragraphs interpreting the simulated results
% Report actual numbers from experimental data; use \cite{} for baseline citations
% If no experimental data exists, write \placeholder{NEEDS: simulated dataset results}
```

**Key elements:**
- Results table with booktabs
- Bold the best result in each column
- Short interpretation paragraph
- All numbers from experimental data only

---

### File: 5-2-aluminum.tex

```latex
 paragraph{5.2 Aluminum Dataset Results}

% INPUT REQUIRED: Context paragraph about the aluminum dataset
% From: methodology.md experiment design section

% INPUT REQUIRED: Results table from experimental data
\begin{table}[htbp]
    \caption{INPUT REQUIRED: Table caption}
    \label{tab:aluminum-results}
    \begin{tabular}{lcc}
        \toprule
        Method & INPUT REQUIRED: Column headers \\
        \midrule
        % INPUT REQUIRED: Each baseline method row with results
        \midrule
        % INPUT REQUIRED: Proposed method row with results
        \bottomrule
    \end{tabular}
\end{table}

% INPUT REQUIRED: 1-2 paragraphs interpreting aluminum results
% If no experimental data exists, write \placeholder{NEEDS: aluminum dataset results}
```

**Key elements:**
- Same table structure as simulated
- Cross-dataset comparison if data available
- Interpretation specific to material characteristics

---

### File: 5-3-cfrp.tex

```latex
 paragraph{5.3 CFRP Dataset Results}

% INPUT REQUIRED: Context paragraph about the CFRP dataset and its challenges
% From: methodology.md experiment design section

% INPUT REQUIRED: Results table from experimental data
\begin{table}[htbp]
    \caption{INPUT REQUIRED: Table caption}
    \label{tab:cfrp-results}
    \begin{tabular}{lcc}
        \toprule
        Method & INPUT REQUIRED: Column headers \\
        \midrule
        % INPUT REQUIRED: Each baseline method row with results
        \midrule
        % INPUT REQUIRED: Proposed method row with results
        \bottomrule
    \end{tabular}
\end{table}

% INPUT REQUIRED: 1-2 paragraphs interpreting CFRP results
% If no experimental data exists, write \placeholder{NEEDS: CFRP dataset results}
```

**Key elements:**
- Consistent table structure across datasets
- Material-specific interpretation
- Cross-material comparison where data available

---

### File: 5-4-generalization.tex

```latex
 paragraph{5.4 Cross-Domain Generalization}

% INPUT REQUIRED: Context paragraph describing the generalization evaluation
% From: experimental data (cross-domain results)

% INPUT REQUIRED: Cross-domain results table from experimental data
\begin{table}[htbp]
    \caption{INPUT REQUIRED: Table caption}
    \label{tab:generalization}
    \begin{tabular}{lcc}
        \toprule
        Training Domain & Test Domain & INPUT REQUIRED: Metric column \\
        \midrule
        % INPUT REQUIRED: Each cross-domain pair row
        \midrule
        % INPUT REQUIRED: Within-domain (seen) baseline row
        \bottomrule
    \end{tabular}
\end{table}

% INPUT REQUIRED: 1-2 paragraphs analyzing generalization patterns
% If no cross-domain data exists, write \placeholder{NEEDS: cross-domain results}
```

**Key elements:**
- Cross-domain table with training/test domain pairs
- Within-domain baseline for comparison
- Analysis of transfer direction with actual data

---

### File: 5-5-detection.tex

```latex
 paragraph{5.5 Detection Performance Analysis}

% INPUT REQUIRED: Context paragraph about detection analysis
% From: experimental data

% INPUT REQUIRED: Detection performance table from experimental data
\begin{table}[htbp]
    \caption{INPUT REQUIRED: Table caption}
    \label{tab:detection}
    % INPUT REQUIRED: Table structure matching available detection metrics
    % Common columns: Method, Precision, Recall, F1, AUC per dataset
    \begin{tabular}{lcccccc}
        \toprule
        % INPUT REQUIRED: Column headers (method + metrics per dataset)
        \midrule
        % INPUT REQUIRED: Each method row with detection metrics
        \midrule
        % INPUT REQUIRED: Proposed method row
        \bottomrule
    \end{tabular}
\end{table}

% INPUT REQUIRED: 1-2 paragraphs analyzing detection performance
% If no detection data exists, write \placeholder{NEEDS: detection performance data}
```

**Key elements:**
- Precision-recall table (structured per dataset)
- AUC or other comprehensive metrics if available
- Balanced performance interpretation

---

### File: 5-6-ablation.tex

```latex
 paragraph{5.6 Ablation Study}

% INPUT REQUIRED: Context paragraph describing the ablation study
% From: experimental data (ablation results)

% INPUT REQUIRED: Ablation results table from experimental data
\begin{table}[htbp]
    \caption{INPUT REQUIRED: Table caption}
    \label{tab:ablation}
    \begin{tabular}{lc}
        \toprule
        Configuration & INPUT REQUIRED: Metric \\
        \midrule
        % INPUT REQUIRED: Full model result row
        % INPUT REQUIRED: Each ablation variant row
        \bottomrule
    \end{tabular}
\end{table}

% INPUT REQUIRED: 1-2 paragraphs analyzing ablation results
% Discuss which component contributes most and why
% If no ablation data exists, write \placeholder{NEEDS: ablation study results}
```

**Key elements:**
- Ablation table showing removal of individual components
- Delta or percentage change shown where data available
- Synergy note when multiple components removed
- Architectural validation conclusion

---

## Step 4: Statistical Significance

For each result claim involving improvement or comparison, include statistical significance if documented in experimental data. **Do not invent significance values.**

### Standard Test
```latex
% INPUT REQUIRED: Statistical test and p-value from experimental data
% If significance not computed, write \placeholder{NEEDS: statistical significance}
```

### Multiple Comparisons
```latex
% INPUT REQUIRED: Correction method and adjusted p-value from experimental data
% If multiple comparison correction not applied, skip this
```

### Confidence Intervals
```latex
% INPUT REQUIRED: Confidence intervals from experimental data
% Include metric name, mean, CI range, and number of runs
```

---

## Step 5: Elsevier LaTeX Requirements

### Required Preamble Additions

Ensure these packages are available in `main.tex`:
```latex
\usepackage{booktabs}      % For tables
\usepackage{amsmath}       % For equations
\usepackage{graphicx}      % For figures
\usepackage{cite}          % For citations
```

### Table Style Rules

1. Always use `\toprule`, `\midrule`, `\bottomrule` (booktabs)
2. Never use vertical lines
3. Bold the best result in each column
4. Include units in column headers when applicable
5. Caption above table, label after caption

### Figure References

```latex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.8\textwidth]{figures/fig-roc.pdf}
    \caption{ROC curves for all methods on (a) Simulated, (b) Aluminum, and (c) CFRP datasets.}
    \label{fig:roc}
\end{figure}
```

---

## Step 6: Completion Report

After writing all paragraph files, report to user:

```
结果章节写作完成。

覆盖内容：
- 5-1-simulated.tex：Simulated dataset results (from experimental data)
- 5-2-aluminum.tex：Aluminum dataset results (from experimental data)
- 5-3-cfrp.tex：CFRP dataset results (from experimental data)
- 5-4-generalization.tex：Cross-domain generalization (from experimental data)
- 5-5-detection.tex：Detection precision/recall analysis (from experimental data)
- 5-6-ablation.tex：Ablation study results (from experimental data)

所有表格使用 Elsevier booktabs 格式。
所有数值来自实验数据，未虚构。

下一步：aw-write-discussion — 撰写讨论章节
```

---

## Edge Cases

### Partial Data Available

If only some datasets have results:
- Write available sections
- Mark missing sections as `\paragraph{X.Y Dataset Results} \placeholder{Results for [dataset] to be added after experiment completion.}`
- Report which sections are incomplete

### Baseline Numbers Mismatch

If provided baseline numbers differ from methodology's expected results:
- Use the actual experimental numbers
- Note the discrepancy briefly
- Do not change methodology.md; just proceed with actual numbers

### Statistical Significance Not Computable

If insufficient replicates for statistical test:
- Report descriptive statistics only
- Use "preliminary findings" or "observed trend" language
- Do not claim statistical significance without proper test

---

## Integration Points

| Input | Source | Description |
|-------|--------|-------------|
| Methodology | `.planning/methodology.md` | Metrics, baselines, ablation plan |
| Experimental Data | `.planning/experimental-data/` or inline | Actual results to report |

| Output | Destination | Consumed By |
|--------|-------------|-------------|
| 6 paragraph files | `sections/results/` | `aw-execute` (wave merger) |
| Results draft | `sections/results.tex` (via \input) | `aw-review` |

---

## File Locations

```
.planning/
├── methodology.md              ← Input: metrics, baselines, ablation
└── experimental-data/
    └── results.yaml            ← Input: actual experimental numbers

manuscripts/[paper-name]/sections/results/
├── 5-1-simulated.tex          ← Output
├── 5-2-aluminum.tex           ← Output
├── 5-3-cfrp.tex               ← Output
├── 5-4-generalization.tex    ← Output
├── 5-5-detection.tex          ← Output
└── 5-6-ablation.tex           ← Output
```

---

## Usage Examples

- `/aw-write-results` — Run results writing for approved methodology
- (Auto-triggered by `aw-execute` during Phase 5 wave)
