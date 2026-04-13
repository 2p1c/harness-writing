---
name: latex-paper-en
description: Write academic paper sections in LaTeX with Elsevier format compliance. Triggers when user explicitly requests section writing via /write command, says "write section", "撰写章节", or asks to produce LaTeX content for a specific paper section. Does NOT activate passively on .tex file opens. Produces properly formatted LaTeX content with correct markup, citations, and academic voice.
---

# LaTeX Paper Writing (Elsevier Format)

## Purpose

Write or refine academic paper sections in proper LaTeX format following Elsevier guidelines.

## Elsevier Article Requirements

### Document Class
```latex
\documentclass[review]{elsarticle}
```

### Required Packages
```latex
\usepackage{amsmath,amsfonts,amssymb}
\usepackage{graphicx}
\usepackage{float}
\usepackage{cite}
\usepackage{url}
\usepackage{lineno,hyperref}
\modulolinenumbers[5]
```

### Bibliography Style
```latex
\bibliographystyle{elsarticle-num}
```

## Section Writing Guidelines

### Abstract
- 150-300 words
- No citations
- Summarize: context, problem, approach, findings, implications
- 4-5 sentences

```latex
\begin{abstract}
Problem: ...
Method: ...
Results: ...
Conclusion: ...
\end{abstract}
```

### Introduction
- Establish context for the research
- Review relevant prior work (cite key papers)
- Identify gap or problem
- State research questions/objectives
- Outline paper structure

Key phrases:
- "In recent years, ... has gained increasing attention"
- "Despite significant advances in ..., several challenges remain"
- "In this paper, we propose ..."

### Methodology
- Describe research design clearly
- Include sufficient detail for replication
- Use past tense, passive voice acceptable
- Number equations, reference figures/tables

Key phrases:
- "The dataset consists of..."
- "We evaluate our approach using..."
- "Parameter settings follow..."

### Results
- Present findings objectively
- Use figures and tables effectively
- Report statistical significance
- No interpretation (save for Discussion)

Key phrases:
- "As shown in Figure 2, ..."
- "Results indicate that ..."
- "The difference is statistically significant (p < 0.05)"

### Discussion
- Interpret results
- Compare with prior work (cite)
- Discuss implications
- Acknowledge limitations
- Suggest future work

Key phrases:
- "These findings suggest that ..."
- "In contrast to Smith et al. [10], we observe ..."
- "One limitation of this study is ..."

### Conclusion
- Brief summary (no new information)
- Emphasize contributions
- State practical implications

Key phrases:
- "In this paper, we presented ..."
- "The key contributions include ..."

## LaTeX Markup Guidelines

### Equations
```latex
Equation numbers in parentheses:
\begin{equation}
    y = \beta_0 + \beta_1 x + \epsilon
    \label{eq:linear}
\end{equation}
```

### Figures
```latex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.8\textwidth]{figures/fig1.pdf}
    \caption{Description of figure content.}
    \label{fig:overview}
\end{figure}
```

### Tables (use booktabs style)
```latex
\usepackage{booktabs}  % Add to preamble

\begin{table}[htbp]
    \caption{Descriptive Statistics}
    \label{tab:desc}
    \begin{tabular}{lccc}
        \toprule
        Variable & Mean & SD & Range \\
        \midrule
        X & 10.2 & 2.1 & 5.0--15.0 \\
        Y & 8.7 & 1.9 & 4.0--13.0 \\
        \bottomrule
    \end{tabular}
\end{table}
```

### Citations
```latex
Single: \cite{smith2020}
Multiple: \citealp{smith2020,jones2021,wang2022}
Textual: \citeauthor{smith2020} found that...
```

## Academic Voice Guidelines

- Use precise, specific language
- Avoid vague quantifiers ("many", "significant", "good")
- Prefer active voice: "We propose..." over "It is proposed..."
- Use hedging appropriately: "suggests", "indicates", "appears"
- Avoid first-person if journal prefers passive

## Common Errors to Avoid

1. **Citation inconsistency** - Check all \cite{} keys exist in references.bib
2. **Figure placement** - Use [htbp] for flexibility
3. **Math spacing** - Use \, \; \: for thin/thick spaces in math
4. **Reference format** - Elsevier uses numbered references, not author-date

## Integration

### Workflow Pipeline
This skill works as part of a larger writing pipeline:

```
paper-outline-generator → latex-paper-en → academic-review
```

- **Input**: Topic, research questions, or outline from paper-outline-generator
- **Output**: LaTeX-formatted section text, ready for academic-review
- **After completion**: Consider running /review on the written section

### Multi-Section Coordination
When writing multiple sections:
1. Write Introduction first (sets structure for rest)
2. Write Methodology next (methodology informs results)
3. Write Results
4. Write Discussion and Conclusion last

## Usage Examples

- `/write introduction for deep learning medical imaging paper`
- `/write methodology section about transformer architecture`
- `/write results comparing baseline methods`
- `/write 撰写methodology章节，关于深度学习模型架构`
- `/write 根据以下大纲撰写introduction部分`
