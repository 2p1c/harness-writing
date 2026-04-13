---
name: aw-write-conclusion
description: Write the conclusion section of an academic paper. Triggers when user requests "conclusion", "结论", "/write conclusion", or when the wave executor assigns a conclusion writing task. Reads all previous section files (introduction, related-work, methodology, experiment, results, discussion) to synthesize contributions, key findings, and future work. Produces three paragraph files: 7-1-summary.tex, 7-2-findings.tex, 7-3-future-work.tex, plus abstract.tex last.
---

# Conclusion Section Writer

## Purpose

Write the conclusion section by synthesizing insights from all previous paper sections. The conclusion is written last but implemented early in Phase 2 to demonstrate wave-based execution flow.

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
- Example structure:
  ```latex
  \paragraph{Summary of Contributions}
  This paper presented \textbf{X} to address the problem of \textbf{Y}.
  The key contributions are threefold:
  \begin{itemize}
      \item First, we proposed \textbf{Method A} \cite{...}, which achieves ...
      \item Second, we designed \textbf{Framework B} that ...
      \item Third, we released \textbf{Dataset C} containing ...
  \end{itemize}
  ```

### 7-2-findings.tex (Key Findings)

- Include specific quantitative results (accuracy, F1, speedup, etc.)
- Reference figures and tables with `\ref{}`
- Compare with baseline methods using citation
- Avoid interpretation (save for discussion)
- Example: "Our method achieved 94.2\% accuracy on Dataset X, outperforming Smith et al. \cite{smith2023} by 3.1 percentage points."

### 7-3-future-work.tex (Future Directions)

- Be specific, not generic (avoid "future work includes exploring more datasets")
- Reference limitations identified in discussion
- Suggest concrete extensions:
  - New application domains
  - Architectural improvements
  - Theoretical analysis
  - Scalability to larger settings
- Example: "While our approach handles static graphs, future work should address temporal graphs where node features evolve over time."

### abstract.tex

- 150-300 words
- No citations
- Structure: Problem → Method → Results → Conclusion
- Write this last after all sections are complete

```latex
\begin{abstract}
... (problem statement) ...
... (proposed method) ...
... (key results with numbers) ...
... (conclusion and implications) ...
\end{abstract}
```

## Quality Checks

Before completing:
- [ ] Total word count: ~500 words (within 20\% of target)
- [ ] All quantitative findings include numbers with units
- [ ] Future work is specific (not generic statements)
- [ ] Citation keys resolve to entries in `references.bib`
- [ ] No `\placeholder{}` or TODO/FIXME remaining
- [ ] Elsevier format: `\section{Conclusion}`, `\label{sec:conclusion}`
- [ ] Abstract written last, after all sections complete

## Integration

This skill is invoked by `aw-execute` during wave execution. It reads from previously written sections and outputs paragraph files that `aw-execute` merges into the final chapter file.

```
aw-execute (wave planner) → aw-write-conclusion → phase merger → aw-review
```
