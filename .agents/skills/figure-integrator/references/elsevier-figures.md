# Elsevier Figure Formatting Guide

## Overview

Proper figure formatting is critical for publication. Elsevier has specific requirements for file types, dimensions, and placement.

---

## File Specifications

### Accepted Formats

| Format | Use Case | Quality |
|--------|----------|---------|
| PDF | Vector graphics, diagrams | Excellent (infinite zoom) |
| PNG | Raster images, screenshots | Good (if 300+ dpi) |
| JPEG | Photographs | Acceptable (if 300+ dpi) |
| TIFF | High-quality raster | Excellent (large file size) |

### Resolution Requirements

- **Line art / diagrams**: 300 dpi minimum
- **Half-tone photographs**: 300 dpi minimum
- **Combination figures**: 300 dpi minimum
- **Color figures**: 300-600 dpi recommended

### Size Limits

| Column Type | Maximum Width |
|------------|---------------|
| Single column | 8 cm (~3.1 inches) |
| 1.5 column | 12 cm |
| Double column | 17 cm (~6.7 inches) |
| Full page | 19 cm |

---

## LaTeX Figure Environment

### Basic Figure
```latex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.8\textwidth]{figures/fig1.pdf}
    \caption{Descriptive caption explaining the figure clearly and concisely.}
    \label{fig:example}
\end{figure}
```

### Figure spanning two columns
```latex
\begin{figure*}[htbp]
    \centering
    \includegraphics[width=0.9\textwidth]{figures/fig1.pdf}
    \caption{Caption for double-column figure.}
    \label{fig:wide}
\end{figure*}
```

### Subfigures
```latex
\usepackage{subcaption}

\begin{figure}[htbp]
    \centering
    \begin{subcaptiongroup}
        \includegraphics[width=0.45\textwidth]{figures/fig1a.pdf}
        \subcaption{First part}
        \label{fig:part1}
    \end{subcaptiongroup}
    \hfill
    \begin{subcaptiongroup}
        \includegraphics[width=0.45\textwidth]{figures/fig1b.pdf}
        \subcaption{Second part}
        \label{fig:part2}
    \end{subcaptiongroup}
    \caption{Overall caption for (a) and (b).}
    \label{fig:combined}
\end{figure}
```

---

## Caption Guidelines

### Good Caption Practices
1. **Be concise** - One to two sentences maximum
2. **Be descriptive** - Explain what the figure shows, not just "Results"
3. **Include key findings** - "Accuracy increased with model depth (see Section 3.2)"
4. **Define abbreviations** - If using acronyms, define on first use

### Caption Examples

**Good**:
```
\caption{Comparison of model performance on validation set.
Higher values indicate better accuracy.}
```

**Poor**:
```
\caption{Results.}
```

**Good**:
```
\caption{Network architecture of proposed method, showing
three encoder layers (E1-E3), attention mechanism (Att),
and decoder layers (D1-D3).}
```

---

## Figure Placement

### Placement Priority (use in order)
1. `[h]` - Here (where specified, if possible)
2. `[t]` - Top of page
3. `[b]` - Bottom of page
4. `[p]` - On separate float page

### Best Practice
Use `[htbp]` to let LaTeX find optimal placement:
```latex
\begin{figure}[htbp]
```

---

## Color Figure Considerations

### For Online Publication
- RGB color accepted
- CMYK not required

### For Print Publication
- Confirm if journal accepts color figures
- Consider grayscale compatibility
- Some journals charge for color figures

### Accessibility
- Don't rely solely on color to convey information
- Use patterns, labels, or different shapes
- Include alt text for screen readers

---

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| Figure not found | Wrong file path | Check `\includegraphics{path}` |
| Too large | Width exceeds column | Use `\textwidth` fraction |
| Low quality | Resolution too low | Resample to 300+ dpi |
| Caption too long | Wordy description | Keep concise, under 2 sentences |
| Missing label | No \label after caption | Add `\label{fig:name}` |

---

## Figure Referencing

In text, reference figures as:
```latex
Figure~\ref{fig:example} shows that...
As illustrated in Fig~\ref{fig:overview},...
```

Note: Use `~` for non-breaking space to prevent "Figure" and number from separating.

---

## Figure File Organization

Recommended structure:
```
project/
├── figures/
│   ├── fig1_system_overview.pdf
│   ├── fig2_algorithm_flow.png
│   ├── fig3a_results_exp1.pdf
│   ├── fig3b_results_exp2.pdf
│   └── fig4_comparison.pdf
├── main.tex
└── references.bib
```

Naming conventions:
- Use descriptive names: `fig1_system_overview.pdf`
- Number figures sequentially
- Use consistent file types (prefer PDF for diagrams)
