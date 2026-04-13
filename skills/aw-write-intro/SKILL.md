---
name: aw-write-intro
description: Write introduction section paragraphs for academic papers using wave-based execution. Triggers when /aw-execute assigns a Wave 1 or Wave 2 task for the introduction section (1.1, 1.2, 1.3, 1.4). Reads research-brief.json, literature.md, and methodology.md to produce independent paragraph .tex files. Each task writes one paragraph file following Elsevier LaTeX format.
---

# aw-write-intro — Introduction Section Writer

## Purpose

Write introduction section paragraphs as independent wave tasks. Each invocation writes one paragraph file following the ROADMAP task decomposition. Paragraphs are written in parallel when assigned to the same wave (no file overlap), and sequentially when dependencies require it.

## When to Trigger

- `/aw-execute` assigns a wave task with `section: introduction`
- Wave planner outputs task IDs: `1-1`, `1-2`, `1-3`, `1-4`
- Each task is independent and produces its own paragraph file

## Input Sources (read in order)

1. **`.planning/research-brief.json`** — Problem statement, novelty claims, contribution bullets, author intent
2. **`.planning/literature.md`** — Relevant prior work for background context and gap identification
3. **`.planning/methodology.md`** — Technical approach overview for contribution framing
4. **`templates/elsevier/sections/introduction.tex`** — LaTeX format reference (Elsevier template)

## Output Convention

```
manuscripts/{paper-name}/sections/intro/
├── 1-1-background.tex     # \paragraph{1.1 Research Background}
├── 1-2-problem.tex        # \paragraph{1.2 Problem Definition}
├── 1-3-contributions.tex  # \paragraph{1.3 Main Contributions}
└── 1-4-structure.tex      # \paragraph{1.4 Paper Structure}
```

Each file contains exactly one `\paragraph{}` block with appropriate content.

## Task Specifications

### Task 1-1: Research Background

**Input context:** Problem domain, broad research area, recent developments

**Output:** 2-3 paragraphs establishing the research context

**LaTeX structure:**
```latex
 paragraph{Reviewing Past Work}
\label{sec:intro:background}

[2-3 paragraphs tracing the evolution of the field,
 citing key prior work, narrowing down to the specific
 sub-area the paper addresses]
```

**Coverage:**
- Start broad (field-level)
- Narrow to specific sub-area
- Cite foundational and recent work
- Show logical progression toward the gap

### Task 1-2: Problem Definition

**Input context:** Specific gap or limitation identified in research-brief.json

**Output:** 1 paragraph precisely defining the problem

**LaTeX structure:**
```latex
 paragraph{Problem Statement}
\label{sec:intro:problem}

[1 paragraph clearly stating the specific problem,
 limitation, or gap that motivates the paper.
 Avoid vague language; be precise about what is missing
 or suboptimal in existing work.]
```

**Coverage:**
- State the specific gap precisely
- Avoid vague quantifiers (say "X achieves 70% accuracy" not "X achieves good accuracy")
- Connect directly to the gap identified in prior work

### Task 1-3: Main Contributions

**Input context:** Novelty claims and contribution bullets from research-brief.json

**Output:** 3-4 bullet items summarizing contributions

**LaTeX structure:**
```latex
 paragraph{Main Contributions}
\label{sec:intro:contributions}

\begin{itemize}
    \item We propose \ldots
    \item We demonstrate \ldots
    \item We provide \ldots
\end{itemize}
```

**Coverage:**
- Start with "We propose..." or "This paper presents..."
- Be specific: name the method/approach, report key numbers where available
- Avoid generic claims ("significant improvement") without quantification
- Match the contributions to the problem gap stated in 1-2

### Task 1-4: Paper Structure

**Input context:** Section ordering from ROADMAP.md

**Output:** 1 brief paragraph outlining paper structure

**LaTeX structure:**
```latex
 paragraph{Paper Organization}
\label{sec:intro:structure}

The remainder of this paper is organized as follows.
Section~\ref{sec:methodology} describes \ldots
Section~\ref{sec:results} presents \ldots
Section~\ref{sec:discussion} discusses \ldots
Section~\ref{sec:conclusion} concludes \ldots
```

**Coverage:**
- Follow standard IMRAD ordering (unless ROADMAP specifies otherwise)
- Reference section labels, not page numbers
- Keep brief (5-7 sentences max)

## LaTeX Formatting Rules

### Paragraph Block Structure
```latex
 paragraph{Title}
\label{sec:intro:task-id}

Content here...

% For contributions, use itemize inside the paragraph block:
\begin{itemize}
    \item First contribution...
    \item Second contribution...
\end{itemize}
```

### Citation Style
- Numbered format: `\cite{key1,key2}`
- Grouped citations: `\citealp{key1,key2,key3}`
- In-text citation: `\citeauthor{smith2020} found that...`

### Elsevier Template Reference

From `templates/elsevier/main.tex`:
```latex
\documentclass[review]{elsarticle}
\usepackage{amsmath,amsfonts,amssymb}
\usepackage{graphicx}
\usepackage{cite}
```

### Label Naming Convention
- Background: `\label{sec:intro:background}`
- Problem: `\label{sec:intro:problem}`
- Contributions: `\label{sec:intro:contributions}`
- Structure: `\label{sec:intro:structure}`

## Writing Quality Standards

### Do
- Use precise, specific language
- Quantify claims when data is available
- Use hedging appropriately: "suggests", "indicates", "appears"
- Cite foundational and recent relevant work
- Match academic register (formal, objective tone)

### Do Not
- Use vague quantifiers ("significant", "many", "various") without context
- Make claims without citation support
- Use first-person if journal prefers passive voice (check research-brief.json)
- Include TODO or FIXME placeholders
- Write in bullet format for background/problem/structure (only contributions may use itemize)

## Task Execution Workflow

1. **Read inputs** in order: research-brief.json → literature.md → methodology.md
2. **Identify task ID** from the assigned wave task (e.g., `1-1`, `1-2`, etc.)
3. **Write paragraph content** following the task specification above
4. **Create output directory** `manuscripts/{paper-name}/sections/intro/` if not exists
5. **Write .tex file** with correct `\paragraph{}` block and label
6. **Verify** file compiles standalone (can be \input{} into main document)

## File Output Example

**File:** `manuscripts/my-paper/sections/intro/1-1-background.tex`

```latex
 paragraph{Reviewing Past Work}
\label{sec:intro:background}

Deep learning has transformed computer vision over the past decade, with
convolutional neural networks achieving human-level performance on benchmark
datasets \cite{lecun2015deep,krizhevsky2012imagenet}. Recent advances in
transformer architectures have further improved results on complex visual
understanding tasks \cite{dosovitskiy2021image,vit2020}. However, despite
these improvements, existing approaches face challenges when applied to
low-resolution medical imaging data \cite{smith2021limitations}. In the
domain of remote sensing, similar limitations have been observed, where
computational costs grow prohibitive for large-scale deployment \cite{chen2022remote}.

The field of low-light image enhancement has seen particular interest,
with traditional histogram equalization methods \cite{pizer1987adaptive}
gradually replaced by learning-based approaches \cite{lorenz2021learning}.
Despite these advances, real-time enhancement for video streams remains
computationally challenging \cite{wang2023real}, motivating the need for
more efficient architectures suitable for edge deployment.
```

## Integration

This skill is spawned by `aw-execute` (wave executor) for each introduction paragraph task. It is not triggered directly by the user. The wave executor merges all paragraph outputs into `sections/introduction.tex` after all wave tasks complete.

## Usage Example

```
aw-execute assigns:
  Task: 1-1 | Section: Introduction | Paragraph: Research Background
  → Spawns aw-write-intro for 1-1-background.tex
  → Writes: sections/intro/1-1-background.tex
```
