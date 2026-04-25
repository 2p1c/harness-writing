---
name: aw-write-methodology
description: |
  GSDAW Methodology Section Writer — generates Phase 3 (Methodology) paragraph files.
  Triggered by /aw-write-methodology or by aw-execute during wave execution.
  Reads .planning/methodology.md and .planning/research-brief.json to generate
  methodology section paragraphs in Elsevier LaTeX format.
  Outputs independent paragraph .tex files to sections/methodology/ directory.
---

# aw-write-methodology — Methodology Section Writer

## Purpose

Write the Methodology section of an academic paper (Phase 3 of IMRAD) by generating independent paragraph files that are later merged into a complete chapter by `aw-execute`.

This skill is a **section-writing subagent** called by the Wave Executor during Phase 2. It receives a specific task (e.g., "Write 3.2 Architecture Components") and outputs a single paragraph `.tex` file.

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
- User runs `/aw-write-methodology` directly
- Orchestrator delegates during GSDAW pipeline execution

## Inputs

| Input | Source | Description |
|-------|--------|-------------|
| Task description | Wave executor (objective field) | Which paragraph to write (e.g., "3.2 Architecture Components") |
| `research-brief.json` | `.planning/research-brief.json` | Author intent, novelty claims, research question |
| `methodology.md` | `.planning/methodology.md` | Full technical methodology with pipeline, architecture, loss, hyperparameters |
| `literature.md` | `.planning/literature.md` | Related work context (for positioning against baselines) |
| Elsevier template | `templates/elsevier/` | LaTeX format reference (document class, packages, citation style) |

## Outputs

Paragraph files written to `sections/methodology/` with naming convention `{task-id}.tex`:

| File | Task ID | Content |
|------|---------|---------|
| `sections/methodology/3-1-overview.tex` | 3.1 | Method overview (2-3 paragraphs) |
| `sections/methodology/3-2-architecture.tex` | 3.2 | Architecture components with architecture table |
| `sections/methodology/3-3-innovations.tex` | 3.3 | Key innovations and technical contributions |
| `sections/methodology/3-4-experiment-preview.tex` | 3.4 | Experimental setup preview (datasets, metrics preview) |

### Output File Format

Each paragraph file uses Elsevier LaTeX conventions:

```latex
paragraph{Method Overview}
\label{sec:method:overview}

% Write 2-3 paragraphs here describing the high-level approach.
% Use \cite{key} for citations, \ref{fig:xxx} for figures.

paragraph{Architecture Components}
\label{sec:method:arch}

% Describe each architectural component in technical detail.
% Include inline formulas with \[
% Reference the architecture table (Table~\ref{tab:arch}).
```

### Architecture Table Format

Include an architecture table from methodology.md. **Do not invent architecture details.**

```latex
% INPUT REQUIRED: Architecture table caption from methodology.md
% If no architecture is described, write \placeholder{NEEDS: architecture description}
\begin{table}[htbp]
\centering
\caption{INPUT REQUIRED: Architecture table caption}
\label{tab:arch}
% INPUT REQUIRED: Fill table rows from methodology.md architecture description
% Use booktabs format: \toprule, \midrule, \bottomrule
% Typical columns: Stage, Layer, Output Channels, Spatial Resolution
% Fill values from actual architecture, not from example
\begin{tabular}{lccc}
    \toprule
    Stage & Layer & Output Channels & Spatial Resolution \\
    \midrule
    % INPUT REQUIRED: Each architecture stage row
    \bottomrule
\end{tabular}
\end{table}
```

### Loss Function Formula

Include the loss function from methodology.md. **Do not invent loss terms or weights.**

```latex
% INPUT REQUIRED: Loss function from methodology.md
% Include the actual formula and term weights. Do not invent terms.
\subsection{Loss Function}

% INPUT REQUIRED: Description of the loss function from methodology.md
% Include the formula:
\[
\mathcal{L}_{total} = \text{INPUT REQUIRED: Loss formula with actual terms and weights}
\]

% INPUT REQUIRED: Define each loss term individually
% If no loss function is documented, write \placeholder{NEEDS: loss function}
```

### Key Hyperparameters Table

Include hyperparameters from methodology.md. **Do not invent hyperparameters.**

```latex
% INPUT REQUIRED: Training hyperparameters from methodology.md
% Fill each row from actual hyperparameters. Do not invent values.
\begin{table}[htbp]
\centering
\caption{INPUT REQUIRED: Hyperparameters table caption}
\label{tab:hyperparams}
\begin{tabular}{ll}
    \toprule
    Parameter & Value \\
    \midrule
    % INPUT REQUIRED: Fill rows from methodology.md hyperparameters section
    \bottomrule
\end{tabular}
\end{table}
```

## Workflow

```
aw-write-methodology invoked with task "3.2 Architecture Components"
    │
    ▼
Read: .planning/methodology.md (full document)
    │
    ▼
Read: .planning/research-brief.json (novelty, assumptions)
    │
    ▼
Read: templates/elsevier/sections/methodology.tex (LaTeX format)
    │
    ▼
Write: sections/methodology/3-2-architecture.tex
    │
    ▼
Return completion with word count and first 200 chars preview
```

## Step-by-Step Execution

### Step 1: Read Inputs

Read `.planning/methodology.md` and extract the relevant subsection for the assigned task:

- For task 3.1: read Section 1 (Technical Pipeline) + Section 4 (Method Overview from Expected Results)
- For task 3.2: read Section 2 (Network Architecture) — includes architecture table, loss function, skip connections
- For task 3.3: read Section 2.3 (Key architectural features) + Section 3.4 (Ablation studies — innovations)
- For task 3.4: read Section 3 (Experiment Design) — datasets table, baseline summary, metrics preview

Also read `.planning/research-brief.json` to understand the novelty claims that need emphasizing.

### Step 2: Extract Content for Task

For each paragraph file, extract relevant content from methodology.md:

**3-1-overview.tex (Method Overview):**
- % INPUT REQUIRED: Problem domain and high-level approach from methodology.md and research-brief.json
- % INPUT REQUIRED: Key motivation for the proposed method
- % INPUT REQUIRED: Expected behavior or generalization goals

**3-2-architecture.tex (Architecture):**
- % INPUT REQUIRED: Architecture table from methodology.md (fill Table~\ref{tab:arch})
- % INPUT REQUIRED: Key architectural components (skip connections, attention, etc.)
- % INPUT REQUIRED: Loss function with formula and terms
- % INPUT REQUIRED: Hyperparameters table from methodology.md (fill Table~\ref{tab:hyperparams})

**3-3-innovations.tex (Key Innovations):**
- % INPUT REQUIRED: Novel contributions from research-brief.json novelty claims
- % INPUT REQUIRED: Architectural innovations described in methodology.md
- % INPUT REQUIRED: Training strategies or design choices that are novel

**3-4-experiment-preview.tex (Experiment Setup Preview):**
- % INPUT REQUIRED: Dataset overview from methodology.md experiment design section
- % INPUT REQUIRED: Materials and defect types studied
- % INPUT REQUIRED: Baseline methods for comparison
- % INPUT REQUIRED: Evaluation metrics for performance assessment

### Step 3: Write Paragraph File

Write the `.tex` paragraph file with:

1. `\paragraph{Section Title}` heading with label
2. 2-4 paragraphs of running text (academic register, past tense for methods)
3. Inline math with `\[ ... \]` for formulas
4. `\ref{tab:}` and `\ref{fig:}` for cross-references
5. `\cite{key}` for citations
6. End with a blank line before potential next section

### Step 4: Verify Output

Check that the written file:
- Compiles (valid LaTeX syntax)
- Contains at least 150 words (target: 200-400)
- Has no TODO/FIXME placeholders
- Uses `\ref{}` correctly (not hardcoded numbers)
- Uses Elsevier citation style (`\cite{key}`, not `\citep`)

### Step 5: Report Completion

Return to wave executor:
```
Paragraph 3.2 (Architecture) written.
Word count: 387
File: sections/methodology/3-2-architecture.tex
Preview: "The encoder-decoder architecture follows a U-Net topology..."
```

## Elsevier LaTeX Conventions

### Document Class
```latex
\documentclass[review]{elsarticle}
```

### Packages Used
```latex
\usepackage{amsmath,amsfonts,amssymb}  % Math
\usepackage{graphicx}                   % Figures
\usepackage{float}                      % Float positioning
\usepackage{booktabs}                   % Tables (requires: \toprule, \midrule, \bottomrule)
\usepackage{cite}                       % Citations
```

### Citation Style
- Use `\cite{key}` → numbered citation `[1]`
- Use `\citealp{key1,key2}` for grouped without parentheses
- DO NOT use author-date format

### Table Format (booktabs)
```latex
\begin{table}[htbp]
\centering
\caption{Caption Here}
\label{tab:label}
\begin{tabular}{lccc}
    \toprule
    Header 1 & Header 2 & Header 3 \\
    \midrule
    Row 1 col 1 & Row 1 col 2 & Row 1 col 3 \\
    Row 2 col 1 & Row 2 col 2 & Row 2 col 3 \\
    \bottomrule
\end{tabular}
\end{table}
```

### Cross-References
- Figures: `\ref{fig:arch}` → "Fig. \ref{fig:arch}"
- Tables: `\ref{tab:arch}` → "Table \ref{tab:arch}"
- Equations: `\ref{eq:loss}` → "Eq. \ref{eq:loss}"
- Sections: `\ref{sec:method:overview}` → "Section \ref{sec:method:overview}"

## Error Handling

### Missing Input Files

If `.planning/methodology.md` does not exist:
```
错误：未找到方法论设计文件 (.planning/methodology.md)。

请先运行 /aw-methodology 生成方法论设计文件，
或确认研究简报已通过 Discuss #1 审批。
```

If `.planning/research-brief.json` does not exist:
```
警告：未找到研究简报 (research-brief.json)。
方法论写作将仅基于 methodology.md 内容进行。
```

### Incomplete Content

If the assigned task references content not present in methodology.md:
- Write what is available; mark gaps with `\placeholder{NEEDS: description of missing content}`
- Report the gap in the completion message

### Compilation Check

After writing, scan for common LaTeX errors:
- Unmatched braces `{}`
- Missing `$` for inline math
- Undefined labels (will be resolved during merge)
- `\begin{}` without matching `\end{}`

## File Locations

```
manuscripts/[paper-name]/
├── .planning/
│   ├── research-brief.json    ← Input
│   ├── methodology.md         ← Input
│   └── literature.md          ← Input (for related work positioning)
├── templates/elsevier/        ← Format reference
│   └── sections/methodology.tex
└── sections/
    └── methodology/
        ├── 3-1-overview.tex       ← Output (paragraph file)
        ├── 3-2-architecture.tex   ← Output (paragraph file)
        ├── 3-3-innovations.tex     ← Output (paragraph file)
        └── 3-4-experiment-preview.tex  ← Output (paragraph file)
```

## Integration Points

| Connection | Agent/File | Direction |
|------------|------------|-----------|
| Called by | `aw-execute` (Wave Executor) | Input: task assignment |
| Feeds into | `aw-execute` (Phase Merger) | Output: paragraph files |
| Reads | `.planning/methodology.md` | Input |
| Reads | `.planning/research-brief.json` | Input |
| Format reference | `templates/elsevier/` | Input |
| Later review | `aw-review` | After wave completion |

## Quality Gate Checklist

Before reporting completion, verify:
- [ ] At least 150 words in paragraph
- [ ] Academic register (past tense for methods, no informal language)
- [ ] Elsevier citation format (`\cite{key}`)
- [ ] Architecture table uses `booktabs` format
- [ ] Loss function formula uses `\[ ... \]` display math
- [ ] No hardcoded figure/table numbers (use `\ref{}`)
- [ ] No TODO/FIXME placeholders (use `\placeholder{}` for missing content)
- [ ] File saved to correct path `sections/methodology/{filename}.tex`