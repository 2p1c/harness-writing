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

```latex
\begin{table}[htbp]
\centering
\caption{Experimental Datasets}
\label{tab:datasets}
\begin{tabular}{llcccc}
    \toprule
    Test Set & Source & Material & Defects & Signal Count & SNR Range \\
    \midrule
    Sim-train & FEM simulation & Al + CFRP & FBH, SDH, delamination & 10,000 pairs & -10 to +20 dB \\
    Sim-val & FEM simulation & Al + CFRP & FBH, SDH, delamination & 1,000 pairs & -10 to +20 dB \\
    Sim-test & Held-out FEM & Al + CFRP & FBH, SDH, delamination & 500 pairs & -10 to +20 dB \\
    Al-exp & Experimental & Al 2024-T3 & FBH (3, 5, 8 mm depth) & 50 A-scans & -5 to +5 dB \\
    CFRP-exp & Experimental & CFRP laminate & Delamination, fiber breakage & 50 A-scans & -8 to +2 dB \\
    \bottomrule
\end{tabular}
\end{table}
```

### Baseline Configuration Table

```latex
\begin{table}[htbp]
\centering
\caption{Baseline Methods}
\label{tab:baselines}
\begin{tabular}{lll}
    \toprule
    Method & Configuration & Implementation \\
    \midrule
    Wiener filter & Adaptive, 5x5 local neighborhood & SciPy signal.wiener \\
    DWT denoising & Daubechies-4, 4-level decomp., soft thresholding & PyWavelets wtmm.denoise \\
    BM3D & Block matching 3D, 8x8x8 blocks, sigma\_est=auto & bm3d package \\
    Sparse coding & Overcomplete DCT (256 atoms), OMP reconstruction & SPAMS toolbox \\
    Bandpass filter & Butterworth 4th order, passband 1--10 MHz & SciPy signal.butterworth \\
    \bottomrule
\end{tabular}
\end{table}
```

### Evaluation Metrics Definitions

```latex
\subsection{Evaluation Metrics}

We evaluate denoising performance using five metrics.

\textbf{SNR Improvement} measures the gain in signal-to-noise ratio:
\[
\Delta\text{SNR} = 20 \log_{10}(\text{RMS}_{denoised}) - 20 \log_{10}(\text{RMS}_{noisy})
\]
where RMS denotes the root mean square of the signal amplitude.

\textbf{Mean Squared Error} quantifies the squared difference to the clean reference:
\[
\text{MSE} = \frac{1}{N}\|y_{clean} - y_{denoised}\|^2
\]

\textbf{Lin's Concordance Correlation Coefficient} (CCC) measures waveform morphology preservation independent of scale:
\[
\text{CCC} = \frac{2\text{Cov}(y_{true}, y_{pred})}{\text{Var}(y_{true}) + \text{Var}(y_{pred}) + (\bar{y}_{true} - \bar{y}_{pred})^2}
\]

\textbf{Waveform Similarity Index} (WSI) measures zero-lag normalized cross-correlation between denoised and clean waveforms.

\textbf{F1-score for Defect Detection} evaluates the probability of detecting defect echoes in denoised A-scans via peak detection, at SNR = -5 dB.
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
- Training set: 10,000 paired noisy-clean A-scan signals from FEM
- Validation: 1,000 held-out pairs
- Test sets: Sim-test (500), Al-exp (50), CFRP-exp (50)
- Materials: Aluminum 2024-T3 (60%), CFRP laminate (40%)
- Defect types: FBH, SDH, delamination, fiber breakage
- FEM parameters: Aluminum $v_L=6320$ m/s, CFRP $v_L=3000$ m/s
- Signal specs: 2048 samples at 100 MHz, SNR -10 to +20 dB

**4-2-baselines.tex — Baseline Methods:**
- Wiener filter (adaptive, 5x5 neighborhood)
- DWT denoising (Daubechies-4, 4-level, soft thresholding)
- BM3D (block matching 3D, 8x8x8 blocks)
- Sparse coding (overcomplete DCT, 256 atoms, OMP)
- Bandpass filter (Butterworth 4th order, 1-10 MHz)
- Include justification for why these are fair comparisons

**4-3-metrics.tex — Evaluation Metrics:**
- SNR improvement: $\Delta\text{SNR}$ target 8-12 dB
- MSE: target < 1.5 x 10^-3
- CCC: target > 0.95
- WSI: target > 0.90
- F1-score: target > 0.85 at -5 dB
- POD: Probability of Detection, slope > 2.5 dB^-1

**4-4-ablation.tex — Ablation Studies:**
- A1: Loss function (MSE-only vs. MSE+CCC vs. Full)
- A2: Architecture depth (3-level vs. 4-level vs. 5-level)
- A3: Skip connections (no skip vs. concat vs. concat+attention)
- A4: Training SNR distribution (fixed +10 dB vs. uniform -10 to +20 dB)
- A5: Input window size (256 vs. 512 vs. 1024)
- A6: Attention gating (with vs. without)

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
- Write available content with gap note
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
- [ ] No TODO/FIXME placeholders
- [ ] File saved to correct path `sections/experiment/{filename}.tex`