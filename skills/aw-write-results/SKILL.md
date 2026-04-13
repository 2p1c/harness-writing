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

```markdown
## Experiment Design

### Datasets

| Dataset | Size | Split | Justification |
|---------|------|-------|---------------|
| Simulated | 10K samples | 80/10/10 | ... |
| Aluminum | 5K samples | 70/15/15 | ... |
| CFRP | 8K samples | 80/10/10 | ... |

### Baselines

| Baseline | Source | Justification |
|----------|--------|---------------|
| MethodX | [paper] | Standard baseline for this task |
| MethodY | [paper] | Most similar approach |

### Evaluation Metrics

| Metric | Definition | Why Selected |
|--------|------------|--------------|
| SNR Improvement | ... | Primary metric |
| Detection Rate | ... | Task-specific |
| Accuracy | ... | Standard classification metric |

### Ablation Studies

| Ablation | Expected Impact | Rationale |
|----------|-----------------|------------|
| Remove Component A | ~3-5% drop | Provides X |
| Replace attention | ~2% drop | Adds overhead but captures Y |
```

---

## Step 2: Locate Experimental Data

Check for experimental data in the following locations (in priority order):

1. `.planning/experimental-data/results.yaml` or `.planning/experimental-data/results.json`
2. `.planning/notes/` directory with per-dataset result files
3. Inline in `.planning/methodology.md` under "Expected Results"
4. `sections/experiment.tex` if experiment section was already written

### Experimental Data Format (if YAML/JSON)

```yaml
# .planning/experimental-data/results.yaml
simulated:
  snr_improvement: 12.4
  detection_rate: 94.2
  baseline_snr: [8.1, 9.3, 10.2]  # MethodX, MethodY, MethodZ
aluminum:
  snr_improvement: 9.8
  detection_rate: 91.5
  baseline_snr: [6.2, 7.1, 8.5]
cfrp:
  snr_improvement: 11.1
  detection_rate: 93.0
  baseline_snr: [7.5, 8.0, 9.1]
generalization:
  cross_domain_accuracy: 87.3
  seen_domain_accuracy: 95.1
ablation:
  full_model: 94.2
  without_component_a: 89.8
  without_attention: 91.5
  without_both: 85.3
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

```latex
\section{Results on Simulated Dataset}
\label{sec:results-simulated}

paragraph{5.1 Simulated Dataset Results}

We first evaluate the proposed method on the simulated dataset, which provides
a controlled environment for assessing performance under known signal conditions.
Table~\ref{tab:simulated-results} summarizes the Signal-to-Noise Ratio (SNR)
improvement and detection accuracy compared with baseline methods.

\begin{table}[htbp]
    \caption{SNR Improvement and Detection Accuracy on Simulated Dataset}
    \label{tab:simulated-results}
    \begin{tabular}{lcc}
        \toprule
        Method & SNR Improvement (dB) & Detection Accuracy (\%) \\
        \midrule
        MethodX \citeauthor{methodx2022} & 8.1 & 82.3 \\
        MethodY \citeauthor{methody2023} & 9.3 & 85.7 \\
        MethodZ \citeauthor{methodz2021} & 10.2 & 88.1 \\
        \midrule
        Proposed & \textbf{12.4} & \textbf{94.2} \\
        \bottomrule
    \end{tabular}
\end{table}

The proposed method achieves an SNR improvement of \textbf{12.4 dB}, representing
a \textbf{21.6\%} improvement over the best baseline (MethodZ, 10.2 dB).
This improvement is statistically significant (p $<$ 0.01, Wilcoxon signed-rank test).
The detection accuracy of \textbf{94.2\%} exceeds all baselines by at least 6.1
percentage points, confirming the effectiveness of the proposed approach under
controlled conditions where ground truth is precisely known.
```

**Key elements:**
- SNR improvement table with booktabs
- Bold best result
- Statistical significance note (p < 0.01)
- Comparison with best baseline (21.6\% improvement)
- Short interpretation paragraph

---

### File: 5-2-aluminum.tex

```latex
paragraph{5.2 Aluminum Dataset Results}

We next present results on the aluminum dataset, which represents a
real-world industrial inspection scenario with moderate complexity.
Table~\ref{tab:aluminum-results} presents the comparison with baseline methods.

\begin{table}[htbp]
    \caption{SNR Improvement and Detection Accuracy on Aluminum Dataset}
    \label{tab:aluminum-results}
    \begin{tabular}{lcc}
        \toprule
        Method & SNR Improvement (dB) & Detection Accuracy (\%) \\
        \midrule
        MethodX \citeauthor{methodx2022} & 6.2 & 78.4 \\
        MethodY \citeauthor{methody2023} & 7.1 & 81.2 \\
        MethodZ \citeauthor{methodz2021} & 8.5 & 84.9 \\
        \midrule
        Proposed & \textbf{9.8} & \textbf{91.5} \\
        \bottomrule
    \end{tabular}
\end{table}

On the aluminum dataset, the proposed method achieves an SNR improvement of
\textbf{9.8 dB}, a \textbf{15.3\%} improvement over the best baseline.
The detection accuracy reaches \textbf{91.5\%}, surpassing MethodZ by 6.6
percentage points. The relatively lower absolute performance compared to the
simulated dataset reflects the increased noise complexity in real industrial
environments, where material heterogeneity and surface irregularities introduce
additional challenges not present in synthetic data.
```

**Key elements:**
- Same table structure as simulated
- Cross-dataset comparison note
- Interpretation of lower absolute performance (industrial complexity)

---

### File: 5-3-cfrp.tex

```latex
paragraph{5.3 CFRP Dataset Results}

The carbon fiber reinforced polymer (CFRP) dataset presents the most challenging
scenario due to the anisotropic nature of carbon fiber materials and the complex
interference patterns they produce. Results are summarized in Table~\ref{tab:cfrp-results}.

\begin{table}[htbp]
    \caption{SNR Improvement and Detection Accuracy on CFRP Dataset}
    \label{tab:cfrp-results}
    \begin{tabular}{lcc}
        \toprule
        Method & SNR Improvement (dB) & Detection Accuracy (\%) \\
        \midrule
        MethodX \citeauthor{methodx2022} & 7.5 & 80.1 \\
        MethodY \citeauthor{methody2023} & 8.0 & 82.6 \\
        MethodZ \citeauthor{methodz2021} & 9.1 & 86.4 \\
        \midrule
        Proposed & \textbf{11.1} & \textbf{93.0} \\
        \bottomrule
    \end{tabular}
\end{table}

The proposed method achieves \textbf{11.1 dB} SNR improvement on CFRP,
representing a \textbf{22.0\%} gain over the best baseline. Detection accuracy
of \textbf{93.0\%} exceeds all baselines by at least 6.6 percentage points.
Notably, the improvement margin is larger on CFRP than on aluminum (+22.0\%
vs. +15.3\% over best baseline), suggesting that the proposed method's
architecture is particularly effective at handling the complex interference
patterns characteristic of anisotropic composite materials.
```

**Key elements:**
- Consistent table structure
- Highlights larger improvement margin on challenging dataset
- Material-specific interpretation

---

### File: 5-4-generalization.tex

```latex
paragraph{5.4 Cross-Domain Generalization}

To evaluate the model's ability to generalize to unseen material configurations,
we conduct cross-domain experiments where the model is trained on one material
and evaluated on another. Table~\ref{tab:generalization} reports cross-domain
detection accuracy alongside within-domain (seen) accuracy.

\begin{table}[htbp]
    \caption{Cross-Domain Generalization Results}
    \label{tab:generalization}
    \begin{tabular}{lcc}
        \toprule
        Training Domain & Test Domain & Detection Accuracy (\%) \\
        \midrule
        Simulated & Aluminum & 83.7 \\
        Simulated & CFRP & 81.2 \\
        Aluminum & Simulated & 86.4 \\
        Aluminum & CFRP & 84.9 \\
        CFRP & Simulated & 85.1 \\
        CFRP & Aluminum & 87.3 \\
        \midrule
        \midrule
        \emph{Seen Domains} & \emph{Matched Domain} & \emph{95.1} \\
        \bottomrule
    \end{tabular}
\end{table}

The cross-domain experiments reveal that the model exhibits meaningful transfer
between structurally similar materials. The best cross-domain performance
(87.3\% CFRP $\rightarrow$ Aluminum) approaches the seen-domain accuracy (95.1\%),
indicating that representations learned from CFRP data transfer effectively to
aluminum inspection. However, transfer from simulated to real data is weaker
(83.7\% and 81.2\%), highlighting the domain gap between synthetic and physical
measurements. These results suggest that fine-tuning on target-domain data
may be beneficial for deployment scenarios with limited labeled data.
```

**Key elements:**
- Cross-domain table with training/test domain pairs
- Within-domain baseline for comparison
- Analysis of transfer direction
- Practical recommendation for deployment

---

### File: 5-5-detection.tex

```latex
paragraph{5.5 Detection Performance Analysis}

Beyond SNR improvement, we analyze detection performance using precision-recall
metrics and receiver operating characteristic (ROC) curves. Table~\ref{tab:detection}
presents per-dataset detection metrics, while Figure~\ref{fig:roc} shows the
ROC curves for all methods.

\begin{table}[htbp]
    \caption{Detection Performance Metrics}
    \label{tab:detection}
    \begin{tabular}{lcccccc}
        \toprule
        \multirow{2}{*}{Method} & \multicolumn{2}{c}{Simulated} & \multicolumn{2}{c}{Aluminum} & \multicolumn{2}{c}{CFRP} \\
        \cmidrule{2-7}
        & Precision & Recall & Precision & Recall & Precision & Recall \\
        \midrule
        MethodX & 80.1 & 84.6 & 76.2 & 80.7 & 78.3 & 82.1 \\
        MethodY & 83.4 & 87.2 & 79.5 & 83.1 & 80.9 & 84.5 \\
        MethodZ & 86.7 & 89.5 & 83.1 & 86.8 & 84.7 & 88.2 \\
        \midrule
        Proposed & \textbf{93.8} & \textbf{94.6} & \textbf{90.2} & \textbf{92.8} & \textbf{91.9} & \textbf{94.1} \\
        \bottomrule
    \end{tabular}
\end{table}

The proposed method achieves precision exceeding 90\% and recall exceeding 92\%
across all three datasets, substantially outperforming all baselines on both
metrics. The balanced precision-recall performance indicates that the method
achieves high confidence in its predictions without sacrificing coverage.
The area under the ROC curve (AUC) for the proposed method reaches 0.97 on the
simulated dataset, 0.94 on aluminum, and 0.95 on CFRP, compared to 0.91, 0.88,
and 0.90 respectively for the best baseline methods.
```

**Key elements:**
- Precision-recall table (multi-row for datasets)
- Reference to ROC figure
- AUC values for comprehensive view
- Balanced performance interpretation

---

### File: 5-6-ablation.tex

```latex
paragraph{5.6 Ablation Study}

We conduct ablation experiments to quantify the contribution of each key
component to the overall performance. Table~\ref{tab:ablation} reports detection
accuracy when removing individual components.

\begin{table}[htbp]
    \caption{Ablation Study Results}
    \label{tab:ablation}
    \begin{tabular}{lc}
        \toprule
        Configuration & Detection Accuracy (\%) \\
        \midrule
        Full model (all components) & \textbf{94.2} \\
        Without Component A & 89.8 (\textbf{-4.4}) \\
        Without Attention mechanism & 91.5 (\textbf{-2.7}) \\
        Without Component B & 92.1 (\textbf{-2.1}) \\
        Without A and B & 87.3 (\textbf{-6.9}) \\
        Without Attention and A & 85.8 (\textbf{-8.4}) \\
        \bottomrule
    \end{tabular}
\end{table}

The ablation results demonstrate that Component A contributes the largest
individual improvement (+4.4\% accuracy), followed by the Attention mechanism
(+2.7\%) and Component B (+2.1\%). Removing both Component A and the Attention
mechanism results in an 8.4\% accuracy drop, indicating a synergistic effect
between these components. Component B's contribution is more modest but still
significant, providing robustness to material variability. These findings
validate the architectural decisions made during methodology design and
identify Component A as the primary performance driver.
```

**Key elements:**
- Ablation table showing removal of individual components
- Delta from full model shown in parentheses
- Synergy note when multiple components removed
- Architectural validation conclusion

---

## Step 4: Statistical Significance

For each result claim involving improvement or comparison, include statistical significance:

### Standard Test
```latex
The improvement is statistically significant (p $<$ 0.01, Wilcoxon signed-rank test,
N = 10 independent runs).
```

### Multiple Comparisons
```latex
After Bonferroni correction for multiple comparisons, the improvement remains
significant (adjusted p $<$ 0.017).
```

### Confidence Intervals
```latex
The mean SNR improvement is 12.4 dB (95\% CI: 11.8--13.0 dB), measured over
10 independent experimental runs with different random seeds.
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
- 5-1-simulated.tex：Simulated dataset results (SNR: 12.4 dB, Acc: 94.2%)
- 5-2-aluminum.tex：Aluminum dataset results (SNR: 9.8 dB, Acc: 91.5%)
- 5-3-cfrp.tex：CFRP dataset results (SNR: 11.1 dB, Acc: 93.0%)
- 5-4-generalization.tex：Cross-domain generalization (best: 87.3%)
- 5-5-detection.tex：Detection precision/recall analysis
- 5-6-ablation.tex：Ablation study (Component A: +4.4%)

所有表格使用 Elsevier booktabs 格式。
统计显著性已标注（p < 0.01）。

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
