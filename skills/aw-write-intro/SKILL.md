---
name: aw-write-intro
description: Write introduction section paragraphs for academic papers using wave-based execution. Triggers when /aw-execute assigns a Wave 1 or Wave 2 task for the introduction section (1.1, 1.2, 1.3, 1.4). Reads research-brief.json, literature.md, and methodology.md to produce independent paragraph .tex files. Each task writes one paragraph file following Elsevier LaTeX format.
---

# aw-write-intro — Introduction Section Writer

## Purpose

Write introduction section paragraphs as independent wave tasks. Each invocation writes one paragraph file following the ROADMAP task decomposition. Paragraphs are written in parallel when assigned to the same wave (no file overlap), and sequentially when dependencies require it.

## ⚠️ Factual Integrity (Highest Priority)

All examples in this skill are FORMAT TEMPLATES only. Follow these rules:

### Rule 1: Write Only from Input Files
- If `.planning/literature.md`, `.planning/research-brief.json`, or `.planning/methodology.md` does **not** contain a specific fact, number, or claim — **do not invent it**
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
% INPUT REQUIRED: Title from task context
 paragraph{INPUT REQUIRED: Section title}
% INPUT REQUIRED: Label following convention sec:intro:{task-id}
\label{INPUT REQUIRED: e.g., sec:intro:background}

% INPUT REQUIRED: 2-3 paragraphs from literature.md + research-brief.json
% Use \cite{key} from literature.md. Do not invent citations.
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
% INPUT REQUIRED: Problem statement
 paragraph{INPUT REQUIRED: Problem title}
\label{INPUT REQUIRED: e.g., sec:intro:problem}

% INPUT REQUIRED: 1 paragraph from research-brief.json gap description
% Be precise. If no gap is documented, write \placeholder{NEEDS: gap}.
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
% INPUT REQUIRED: Contributions from research-brief.json novelty claims
 paragraph{INPUT REQUIRED: Contributions title}
\label{INPUT REQUIRED: e.g., sec:intro:contributions}

\begin{itemize}
    % INPUT REQUIRED: Each \item from research-brief.json contribution bullet
    % If no contributions are documented, write \placeholder{NEEDS: contributions}
    \item INPUT REQUIRED: First contribution with \cite{key}
    \item INPUT REQUIRED: Second contribution
    \item INPUT REQUIRED: Third contribution
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
% INPUT REQUIRED: Section ordering from ROADMAP.md
 paragraph{INPUT REQUIRED: Structure title}
\label{INPUT REQUIRED: e.g., sec:intro:structure}

% INPUT REQUIRED: List sections from ROADMAP.md in IMRAD order
The remainder of this paper is organized as follows.
Section~\ref{INPUT REQUIRED: methodology label} describes INPUT REQUIRED.
Section~\ref{INPUT REQUIRED: results label} presents INPUT REQUIRED.
Section~\ref{INPUT REQUIRED: discussion label} discusses INPUT REQUIRED.
Section~\ref{INPUT REQUIRED: conclusion label} concludes INPUT REQUIRED.
% If any section is not yet planned, write \placeholder{NEEDS: section info}
```

**Coverage:**
- Follow standard IMRAD ordering (unless ROADMAP specifies otherwise)
- Reference section labels, not page numbers
- Keep brief (5-7 sentences max)

## LaTeX Formatting Rules

### Paragraph Block Structure
```latex
% INPUT REQUIRED: Title and label matching the task
 paragraph{INPUT REQUIRED: Section title}
\label{INPUT REQUIRED: Use convention sec:intro:task-id}

% INPUT REQUIRED: Content extracted from input files
% Use \cite{key} for every factual claim.
% If content is missing, write \placeholder{NEEDS: description}.

% For contributions, use itemize inside the paragraph block:
\begin{itemize}
    \item INPUT REQUIRED: First contribution with \cite{key}
    \item INPUT REQUIRED: Second contribution
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
- Quantify claims only when data is available in input files; otherwise use `\placeholder{}`
- Use hedging appropriately: "suggests", "indicates", "appears"
- Cite foundational and recent relevant work
- Match academic register (formal, objective tone)
- Cross-check each claim against input files before writing

### Do Not
- Invent numbers, methods, results, or citations not present in input files
- Use vague quantifiers ("significant", "many", "various") without context
- Make claims without citation support
- Copy example text from this skill into the output
- Use first-person if journal prefers passive voice (check research-brief.json)
- Include TODO or FIXME placeholders (use `\placeholder{}` instead)
- Write in bullet format for background/problem/structure (only contributions may use itemize)

## Task Execution Workflow

1. **Read inputs** in order: research-brief.json → literature.md → methodology.md
2. **Identify task ID** from the assigned wave task (e.g., `1-1`, `1-2`, etc.)
3. **Write paragraph content** following the task specification above
4. **Create output directory** `manuscripts/{paper-name}/sections/intro/` if not exists
5. **Write .tex file** with correct `\paragraph{}` block and label
6. **Verify** file compiles standalone (can be \input{} into main document)

## File Output Template

Use this template structure. **Replace every `% INPUT REQUIRED` comment with actual content from input files. Do not invent content.**

```latex
% ============================================
% INPUT REQUIRED: Write ONE \paragraph{} block
% Fill from: literature.md + research-brief.json
% Do NOT copy example content — extract from inputs
% ============================================
 paragraph{INPUT REQUIRED: Section title based on task}
\label{INPUT REQUIRED: Use convention sec:intro:{task-id}}

% INPUT REQUIRED: Content paragraph(s) based on task:
% - Task 1-1 (Background): 2-3 paragraphs tracing field evolution,
%   citing key prior work from literature.md, narrowing to the
%   specific sub-area. Use \cite{key} for every factual claim.
% - Task 1-2 (Problem): 1 paragraph stating the precise gap or
%   limitation from research-brief.json. Avoid vague language.
% - Task 1-3 (Contributions): 3-4 \item bullets from
%   research-brief.json novelty claims. Start with "We propose..."
% - Task 1-4 (Structure): 5-7 sentences outlining IMRAD sections
%   with \ref{} labels. No citations.
%
% If input files lack required information for a claim:
%   → Mark with \placeholder{NEEDS: description}
%   → Or skip the claim entirely
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
