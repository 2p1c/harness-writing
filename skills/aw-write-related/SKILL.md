---
name: aw-write-related
description: Write related work section paragraphs for academic papers using wave-based execution. Triggers when /aw-execute assigns a wave task for the related work section (2.1, 2.2, 2.3, 2.4). Reads literature.md categorized by theme to produce independent paragraph .tex files organized by category and method. Each task writes one paragraph file with proper citations following Elsevier LaTeX format.
---

# aw-write-related — Related Work Section Writer

## Purpose

Write related work section paragraphs organized by categories from literature.md. Each invocation writes one paragraph file for a specific task (categorization, method discussion, gap, or transition). Tasks are written in parallel when assigned to the same wave (no file overlap).

## When to Trigger

- `/aw-execute` assigns a wave task with `section: related-work`
- Wave planner outputs task IDs: `2-1`, `2-2-methodA`, `2-2-methodB`, `2-3`, `2-4`
- Each task is independent and produces its own paragraph file

## Input Sources (read in order)

1. **`.planning/literature.md`** — Primary source; categorized related work by theme, method, or approach
2. **`.planning/research-brief.json`** — Problem definition and gap to compare against
3. **`.planning/methodology.md`** — Technical context for positioning the proposed method
4. **`templates/elsevier/main.tex`** — LaTeX format reference (Elsevier template)

## Output Convention

```
manuscripts/{paper-name}/sections/related-work/
├── 2-1-categorization.tex     # \paragraph{Categorization of Related Work}
├── 2-2-methodA.tex           # \paragraph{Category A: Method A Approaches}
├── 2-2-methodB.tex           # \paragraph{Category B: Method B Approaches}
├── 2-3-gap.tex               # \paragraph{Research Gap}
└── 2-4-transition.tex        # \paragraph{From Related Work to Proposed Method}
```

Each file contains exactly one `\paragraph{}` block with citations.

## Task Specifications

### Task 2-1: Categorization

**Input context:** literature.md categories and the key themes/types identified

**Output:** Opening paragraph that organizes related work into categories

**LaTeX structure:**
```latex
 paragraph{Categorization of Related Work}
\label{sec:related:categorization}

[Opening paragraph that surveys the landscape of related work,
 organizing approaches into N categories. Briefly name each category
 and indicate what binds the work within it.]
```

**Coverage:**
- Survey the landscape broadly at the start
- Organize by meaningful dimension (e.g., by approach type, by problem framing, by technical mechanism)
- Name categories explicitly
- Keep this paragraph high-level; details go in 2-2 sections

### Task 2-2: Method-Specific Paragraphs

**Input context:** All literature entries belonging to one category

**Output:** 1 paragraph per category discussing methods, strengths, and weaknesses

**LaTeX structure (per category):**
```latex
 paragraph{Category Name: [Approach Type]}
\label{sec:related:methodA}

[1-2 paragraphs discussing methods in this category.
 Cover: what they do, key representative work, strengths.
 Then pivot to: limitations, outstanding challenges, or
 why this category alone does not fully address the problem.]
```

**Coverage per paragraph:**
- Start with what characterizes this category
- Cite representative papers with parenthetical context: `\citealp{smith2020}` — note their key technique or finding
- State a clear "However, ..." limitation that leads into the gap
- Connect back to the specific problem from research-brief.json

**Category naming examples:**
- `\paragraph{Learning-Based Methods}` — for deep learning approaches
- `\paragraph{Classical Optimization Methods}` — for traditional techniques
- `\paragraph{Transformer Architectures}` — for attention-based methods
- `\paragraph{Edge Deployment Strategies}` — for inference optimization work

### Task 2-3: Research Gap

**Input context:** Limitations identified across all 2-2 category paragraphs + problem from research-brief.json

**Output:** 1-2 paragraphs explicitly stating the gap

**LaTeX structure:**
```latex
 paragraph{Research Gap}
\label{sec:related:gap}

[1-2 paragraphs that synthesize the limitations from each category.
 Explicitly state: what is missing, what remains unsolved,
 or what combination of strengths has not been achieved.
 The gap should directly motivate the proposed method.]
```

**Coverage:**
- Synthesize across all categories (not repeat each limitation)
- Be precise: say exactly what combination does not exist or what specific sub-problem remains open
- The gap should directly connect to the contribution described in research-brief.json
- Avoid generic "more research is needed" language

### Task 2-4: Transition to Proposed Method

**Input context:** Gap from 2-3 + methodology.md approach overview

**Output:** 1 paragraph smoothly transitioning from literature to the proposed method

**LaTeX structure:**
```latex
 paragraph{From Related Work to Proposed Method}
\label{sec:related:transition}

[1 paragraph that begins by acknowledging the gap,
 then pivots to: "To address this, we propose..."
 Introduce the proposed method name/approach at a high level.
 Refer to Section~\ref{sec:methodology} for details.]
```

**Coverage:**
- Open with the gap (1-2 sentences, referencing 2-3)
- Pivot with a clear bridging phrase: "To overcome this limitation...", "In this paper, we propose...", "Motivated by this gap, we develop..."
- Name the proposed approach at a high level (detailed description belongs in methodology)
- End with a forward reference: "Section~\ref{sec:methodology} describes our approach in detail"

## LaTeX Formatting Rules

### Paragraph Block Structure
```latex
 paragraph{Title}
\label{sec:related:task-id}

Content with citations inline \cite{key} or \citealp{key1,key2}.
Multiple sentences supporting and citing various works.
```

### Citation Style
- Numbered format: `\cite{key1,key2}`
- Grouped citations: `\citealp{key1,key2,key3}` — preferred for listing multiple works without full context
- In-text: `\citeauthor{smith2020} proposed...`

### Label Naming Convention
- Categorization: `\label{sec:related:categorization}`
- Method A: `\label{sec:related:methodA}`
- Method B: `\label{sec:related:methodB}`
- Gap: `\label{sec:related:gap}`
- Transition: `\label{sec:related:transition}`

### Elsevier Template Reference

From `templates/elsevier/main.tex`:
```latex
\documentclass[review]{elsarticle}
\usepackage{amsmath,amsfonts,amssymb}
\usepackage{graphicx}
\usepackage{cite}
```

## Literature.md Category Handling

When literature.md contains multiple categories:

1. **Identify categories** from literature.md section headings or thematic groupings
2. **Assign each category** to its own 2-2 paragraph (e.g., 2-2-methodA, 2-2-methodB)
3. **If only 2 categories exist**: produce exactly 2 method paragraphs (2-2-methodA, 2-2-methodB)
4. **If 3+ categories exist**: group them into 2 dominant categories, or consolidate minor categories

**Category mapping example:**
```
literature.md categories:
  - Transformer-based methods (5 papers)
  - CNN-based methods (4 papers)
  - Hybrid methods (3 papers)

Output:
  2-2-methodA.tex → "Transformer-Based Methods"
  2-2-methodB.tex → "Convolutional and Hybrid Methods"
```

## Writing Quality Standards

### Do
- Use formal academic register throughout
- Be specific about what each category achieves and fails at
- Use `\citealp{...}` to compactly list related works in context
- Clearly distinguish between categories; avoid mixing them
- End each method paragraph with the limitation that feeds into the gap

### Do Not
- List papers without analytical commentary
- Use vague language ("many approaches", "significant progress")
- Make unsubstantiated claims (cite to support)
- Use bullet lists in related work (prose paragraphs only)
- Include TODO or FIXME placeholders
- Write 2-4 as a bullet list (transition is a prose paragraph)

## Task Execution Workflow

1. **Read literature.md** to identify categories and relevant entries
2. **Map categories** to task IDs (2-2-methodA, 2-2-methodB, etc.)
3. **Read research-brief.json** to understand the gap and proposed contribution
4. **Write each paragraph** following the task specification above
5. **Create output directory** `manuscripts/{paper-name}/sections/related-work/` if not exists
6. **Write .tex files** with correct `\paragraph{}` blocks, labels, and citations
7. **Verify** each file compiles standalone

## File Output Example

**File:** `manuscripts/my-paper/sections/related-work/2-1-categorization.tex`

```latex
 paragraph{Categorization of Related Work}
\label{sec:related:categorization}

Existing approaches to low-light image enhancement can be broadly organized
into three categories: classical signal processing methods that operate on
histogram redistribution \cite{pizer1987adaptive,celik2011contextual}, model-based
optimization techniques that impose priors on the latent illumination map
\cite{lorenz2021learning,wei2020exposure}, and learning-based methods that
train deep networks to learn the enhancement mapping end-to-end
\cite{lorenz2021learning,guo2020lime}. Each category offers distinct trade-offs
in computational efficiency, perceptual quality, and generalization to diverse
capture conditions.
```

**File:** `manuscripts/my-paper/sections/related-work/2-2-methodA.tex`

```latex
 paragraph{Classical Signal Processing Methods}
\label{sec:related:methodA}

Classical approaches to low-light enhancement rely on hand-crafted
transformations of image statistics. Histogram equalization aims to
redistribute intensity values to match a uniform distribution, improving
global contrast \cite{pizer1987adaptive}. Contextual contrast enhancement
extends this by considering local neighborhood statistics \cite{celik2011contextual}.
While these methods are computationally efficient and require no training
data, they operate pixel-wise without understanding semantic content,
leading to artifacts in complex scenes with mixed lighting conditions.
Furthermore, they do not model the physical image formation process,
limiting their ability to recover detailed textures in severely underexposed
regions \cite{guo2020lime}.
```

## Integration

This skill is spawned by `aw-execute` (wave executor) for each related-work paragraph task. It is not triggered directly by the user. The wave executor merges all paragraph outputs into `sections/related-work.tex` after all wave tasks complete.

## Usage Example

```
aw-execute assigns:
  Task: 2-1 | Section: Related Work | Paragraph: Categorization
  → Spawns aw-write-related for 2-1-categorization.tex

  Task: 2-2 | Section: Related Work | Paragraph: Method A (Transformer-based)
  → Spawns aw-write-related for 2-2-methodA.tex

  Task: 2-2 | Section: Related Work | Paragraph: Method B (CNN-based)
  → Spawns aw-write-related for 2-2-methodB.tex

  Wave executor merges all into sections/related-work.tex
```
