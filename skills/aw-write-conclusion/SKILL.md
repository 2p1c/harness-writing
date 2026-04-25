---
name: aw-write-conclusion
description: Write the conclusion section of an academic paper. Triggers when user requests "conclusion", "结论", "/write conclusion", or when the wave executor assigns a conclusion writing task. Reads all previous section files (introduction, related-work, methodology, experiment, results, discussion) to synthesize contributions, key findings, and future work. Produces three paragraph files: 7-1-summary.tex, 7-2-findings.tex, 7-3-future-work.tex, plus abstract.tex last.
---

# Conclusion Section Writer

## Purpose

Write the conclusion section by synthesizing insights from all previous paper sections. The conclusion is written last but implemented early in Phase 2 to demonstrate wave-based execution flow.

## ⚠️ Factual Integrity (Highest Priority)

All examples in this skill are FORMAT TEMPLATES only. Follow these rules:

### Rule 1: Write Only from Input Files
- If a section file, `.planning/research-brief.json`, or `references.bib` does **not** contain a specific fact, number, or claim — **do not invent it**
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

## Inputs

This skill reads all available previous sections:
- `sections/introduction.tex` (and paragraph files in `sections/introduction/`)
- `sections/related-work.tex` (and paragraph files in `sections/related-work/`)
- `sections/methodology.tex` (and paragraph files in `sections/methodology/`)
- `sections/experiment.tex` (and paragraph files in `sections/experiment/`)
- `sections/results.tex` (and paragraph files in `sections/results/`)
- `sections/discussion.tex` (and paragraph files in `sections/discussion/`)
- `sections/conclusion/` (existing paragraph files if any)
- `.planning/research-brief.json` (author intent, novelty, contributions)
- `references.bib` (for citation keys)

## Output Files

Write three paragraph files under `sections/conclusion/`:

| File | Content | Target Length |
|------|---------|---------------|
| `sections/conclusion/7-1-summary.tex` | Restatement of contributions | 150-200 words |
| `sections/conclusion/7-2-findings.tex` | Key quantitative findings with citations | 150-200 words |
| `sections/conclusion/7-3-future-work.tex` | Specific future work directions | 100-150 words |
| `sections/conclusion/abstract.tex` | Abstract (written after all sections) | 150-300 words |

**Total target: ~500 words** (concise conclusion)

## Workflow

1. **Read all previous sections** to extract:
   - Main contributions (from introduction and discussion)
   - Key quantitative results (from results and experiment)
   - Specific future directions (from discussion)
   - Citation keys to reuse

2. **Write paragraph files** in order:
   - `7-1-summary.tex` first (restate contributions)
   - `7-2-findings.tex` second (key findings with numbers)
   - `7-3-future-work.tex` third (specific future work)
   - `abstract.tex` last (after all other sections complete)

3. **Assemble chapter file** `sections/conclusion.tex` with `\input{}` commands in correct order

## Elsevier LaTeX Format

```latex
\section{Conclusion}
\label{sec:conclusion}

\input{sections/conclusion/7-1-summary}
\input{sections/conclusion/7-2-findings}
\input{sections/conclusion/7-3-future-work}
```

## Content Guidelines

### 7-1-summary.tex (Contributions)

- Restate the paper's main contributions in past tense
- Use numbered list or bullet points for clarity
- Do NOT introduce new information
- **Do not invent contributions.** Use only what is documented in the introduction, results, and research-brief.json.
- Template structure:
  ```latex
  \paragraph{Summary of Contributions}
  % INPUT REQUIRED: Restate the problem and the proposed solution
  % From: introduction and research-brief.json
  The key contributions are as follows:
  \begin{itemize}
      \item % INPUT REQUIRED: First contribution from research-brief.json
      \item % INPUT REQUIRED: Second contribution
      \item % INPUT REQUIRED: Third contribution
  \end{itemize}
  ```

### 7-2-findings.tex (Key Findings)

- Include specific quantitative results from the results section only
- Reference figures and tables with `\ref{}`
- Compare with baseline methods using citation
- Avoid interpretation (save for discussion)
- **Do not invent findings.** Use only numbers from the results section.
- Template structure:
  ```latex
  \paragraph{Key Findings}
  % INPUT REQUIRED: Summarize key quantitative findings from results section
  % Include actual numbers with \ref{} references to tables/figures
  % Use \cite{} for baseline comparisons
  ```

### 7-3-future-work.tex (Future Directions)

- Be specific, not generic (avoid "future work includes exploring more datasets")
- Reference limitations identified in discussion
- Suggest concrete extensions from documented limitations:
  - New application domains
  - Architectural improvements
  - Theoretical analysis
  - Scalability to larger settings
- **Do not invent future directions.** Base them on documented limitations.
- Template structure:
  ```latex
  \paragraph{Future Work}
  % INPUT REQUIRED: Specific future directions based on discussion limitations
  % Each direction should connect to a documented limitation or gap
  ```

### abstract.tex

- 150-300 words
- No citations
- Structure: Problem → Method → Results → Conclusion
- Write this last after all sections are complete
- **Do not invent abstract claims.** Synthesize from existing sections only.

```latex
\begin{abstract}
% INPUT REQUIRED: Problem statement (from introduction)
% INPUT REQUIRED: Proposed method (from methodology)
% INPUT REQUIRED: Key results with numbers (from results section)
% INPUT REQUIRED: Conclusion and implications (from discussion)
\end{abstract}
```

## Quality Checks

Before completing:
- [ ] Total word count: ~500 words (within 20\% of target)
- [ ] All quantitative findings include numbers with units
- [ ] Future work is specific (not generic statements)
- [ ] Citation keys resolve to entries in `references.bib`
- [ ] No TODO/FIXME remaining (use `\placeholder{}` for missing content)
- [ ] Elsevier format: `\section{Conclusion}`, `\label{sec:conclusion}`
- [ ] Abstract written last, after all sections complete

## Integration

This skill is invoked by `aw-execute` during wave execution. It reads from previously written sections and outputs paragraph files that `aw-execute` merges into the final chapter file.

```
aw-execute (wave planner) → aw-write-conclusion → phase merger → aw-review
```
