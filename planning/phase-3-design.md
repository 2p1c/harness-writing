# GSDAW Phase 3: Figures, Tables & Citations

**Phase:** 3 of GSDAW Framework Development
**Status:** Design Draft — Pending User Approval
**Branch:** `gsdam-phase-1-design`

## What This Phase Does

Phase 1 built the **planning pipeline**.
Phase 2 built the **wave execution engine** (section writing via paragraph files).

Phase 3 fills the remaining gaps:

1. **Figure Generator** — Generate pipeline diagrams, architecture schematics, experiment result plots from structured data
2. **Table Builder** — Build results tables (SNR, accuracy, ablation) in LaTeX booktabs format
3. **Citation Verifier** — Validate all `\cite{}` keys resolve to entries in `references.bib`
4. **Abstract Writer** — Synthesize all sections into a coherent 250-word abstract

---

## Phase 3 Architecture

### High-Level Flow

```
After Phase 2 completes (all sections written):
    │
    ▼
┌──────────────────────────────────────────────────────┐
│  CITATION VERIFIER (aw-cite)                        │
│  - Scan all sections/*.tex for \cite{} keys         │
│  - Cross-check against references.bib               │
│  - Report missing or undefined keys                  │
│  - Auto-fix: add missing entries from literature.md │
└─────────────────────┬────────────────────────────────┘
                      │ All citations verified
                      ▼
┌──────────────────────────────────────────────────────┐
│  TABLE BUILDER (aw-table)                          │
│  - Collect structured data from methodology.md       │
│  - Build: dataset table, baseline table, ablation    │
│  - Output: LaTeX booktabs tables as snippet files  │
└─────────────────────┬────────────────────────────────┘
                      │ Tables inserted into sections
                      ▼
┌──────────────────────────────────────────────────────┐
│  FIGURE GENERATOR (aw-figure)                       │
│  - Generate: Fig.1 pipeline schematic                │
│  - Generate: Fig.2 architecture diagram            │
│  - Generate: result plots (SNR curves, bar charts) │
│  - Output: .tex + .pdf or .png figures             │
└─────────────────────┬────────────────────────────────┘
                      │ Figures inserted into sections
                      ▼
┌──────────────────────────────────────────────────────┐
│  ABSTRACT WRITER (aw-abstract)                       │
│  - Read: all section drafts                          │
│  - Synthesize: 250-word structured abstract          │
│  - Output: sections/abstract.tex                     │
└─────────────────────┬────────────────────────────────┘
                      │ Abstract approved by user
                      ▼
┌──────────────────────────────────────────────────────┐
│  FINAL PREPARE (aw-finalize)                        │
│  - Run make paper                                    │
│  - Check compile errors                              │
│  - Verify all \ref{} resolved                       │
│  - Update STATE.md to "ready for submission"         │
└──────────────────────────────────────────────────────┘
```

---

## Skills (Phase 3)

```
skills/
├── aw-cite/SKILL.md          # Citation verifier
├── aw-table/SKILL.md        # Table builder
├── aw-figure/SKILL.md       # Figure generator
├── aw-abstract/SKILL.md      # Abstract writer
└── aw-finalize/SKILL.md      # Final compile & check
```

---

## aw-cite — Citation Verifier

### Purpose

Scan all `.tex` files for `\cite{}`, `\citealp{}`, `\citep{}` keys and verify each exists in `references.bib`.

### Process

```
1. Glob: sections/**/*.tex
2. Regex: find all \cite{key}, \citep{key}, \citealp{key}
3. Load: references.bib
4. For each key:
   - In bib? → ✅
   - Not in bib? → ❌ missing
5. Report:
   - Missing keys list
   - Unused bib entries (warning)
```

### Output

```markdown
# Citation Report

**Checked:** 7 files, 42 citations
**Missing:** 2 keys
- `wiener1985` — referenced in methodology.tex but not in references.bib
- `bm3d2007` — referenced in experiment.tex but not in references.bib

**Auto-fix:** Add missing entries from literature.md references?
[Add] [Skip] [Manual]
```

### Auto-fix

For missing keys found in `literature.md`, extract the BibTeX entry and append to `references.bib`.

---

## aw-table — Table Builder

### Purpose

Build LaTeX booktabs tables from structured data in `methodology.md` and results data.

### Table Types

| Table | Source | Output File |
|-------|--------|-------------|
| Dataset table | methodology.md → Datasets section | sections/tables/datasets.tex |
| Baseline configs | methodology.md → Baselines section | sections/tables/baselines.tex |
| Architecture table | methodology.md → Architecture | sections/tables/architecture.tex |
| Ablation results | methodology.md → Ablation | sections/tables/ablation.tex |
| Main results | methodology.md → Results | sections/tables/results.tex |
| Summary table | All results | sections/tables/summary.tex |

### LaTeX Template

```latex
\begin{table}[htbp]
  \centering
  \caption{...}
  \begin{tabular}{lccc}
    \toprule
    Header & Col1 & Col2 & Col3 \\
    \midrule
    Row1 & val & val & val \\
    \bottomrule
  \end{tabular}
  \label{tab:...}
\end{table}
```

### Process

1. **Ask user** to provide CSV data for the table
2. If CSV provided → convert to LaTeX booktabs
3. If no CSV yet → write `\placeholder{tab:name}` in section, skip file
4. Write to `sections/tables/{name}.tex`
5. Auto-insert `\input{tables/{name}}` at correct location in section

---

## aw-figure — Figure Generator

### Purpose

Generate figures from structured data and placeholders in section drafts.

### Figure Inventory (from methodology.md)

| Figure | Type | Data Source |
|--------|------|-------------|
| Fig. 1 | Pipeline schematic | Architecture description |
| Fig. 2 | Network architecture diagram | Layer table |
| Fig. 3 | Training pipeline flowchart | Training scheme |
| Fig. 4 | Simulated denoising examples | SNR data |
| Fig. 5 | Al experimental results | Al-exp dataset results |
| Fig. 6 | CFRP experimental results | CFRP dataset results |
| Fig. 7 | SNR comparison bar chart | All methods |
| Fig. 8 | Cross-domain generalization | Sim-to-Al, Sim-to-CFRP |
| Fig. 9 | F1/POD curves | Detection metrics |
| Fig. 10 | Ablation detail | Ablation study |
| Fig. 11 | Failure case analysis | Limitation cases |
| Fig. 12 | Summary table | All results |

### Output Formats

Tool priority by figure type:
- **Pipeline/architecture diagrams** → PlantUML → `.tex` vector
- **Results plots** → Python matplotlib → `.pdf` bitmap
- **No data yet** → `\placeholder{fig:name}` — leave space for later

### Figure Wrapper Template

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.9\textwidth]{figures/fig-name.pdf}
  \caption{...}
  \label{fig:name}
\end{figure}
```

### Process

1. Read figure list from `methodology.md`
2. For each figure:
   - Check if data exists in results files
   - If data complete → generate using available tool (TikZ/matplotlib)
   - If partial → generate with placeholder
   - If none → leave `\placeholder{}` tag
3. Output: `manuscripts/{slug}/figures/{fig-name}.tex` or `.pdf`
4. Report insertion command

---

## aw-abstract — Abstract Writer

### Purpose

Synthesize all section drafts into a coherent 250-word structured abstract.

### Structure (IMRAD)

```
Background (2 sentences) — problem and motivation
Objective (1 sentence) — what this paper aims to do
Method (2-3 sentences) — U-Net, mixed loss, dataset
Results (2-3 sentences) — SNR improvement, CCC, generalization
Conclusion (1 sentence) — significance and impact
```

### Word Budget: 250 words

| Section | Words |
|---------|-------|
| Background | 40 |
| Objective | 20 |
| Method | 80 |
| Results | 80 |
| Conclusion | 30 |

### Process

1. Read: all section drafts (`sections/**/*.tex`)
2. Read: `research-brief.json` (hypothesis, novelty)
3. Read: key results from `methodology.md`
4. Draft abstract following IMRAD structure
5. Word count check (target: 250 ± 10%)
6. Output: `sections/abstract.tex`

### Quality Checks

- [ ] All acronyms defined on first use
- [ ] No citation in abstract
- [ ] No figures/tables referenced
- [ ] Stands alone without reading the paper
- [ ] Active voice where possible

---

## aw-finalize — Final Prepare

### Purpose

Compile the complete paper and verify readiness for submission.

### Process

```bash
cd manuscripts/{slug}
make clean
make paper
```

### Checklist

| Check | Method | If Fail |
|-------|--------|---------|
| Compiles | `make paper` exit code | Show .log errors |
| No \ref{???} | Search output .log | Missing cross-refs |
| No undefined citations | Search .bbl | Run `bibtex main` |
| Word count | `make word` then count | Note deviation |
| Abstract present | Check abstract.tex | Generate or warn |

### Output

```markdown
# Final Check Report

**Compile:** ✅ No errors
**Citations:** ✅ All 42 resolved
**Cross-refs:** ✅ No undefined \ref
**Word count:** 7,842 / 8,000 (target)
**Abstract:** ✅ Present

**Status:** Ready for submission
```

---

## Integration Chain

```
Phase 2 (aw-execute) completes
    ↓
aw-cite — verify all citations
    ↓
aw-table — build result tables
    ↓
aw-figure — generate figures
    ↓
aw-abstract — write abstract
    ↓
aw-finalize — compile & verify
    ↓
STATE.md: "ready for submission"
```

---

## Open Questions

| # | Question | Options | Status |
|---|----------|---------|--------|
| 1 | Figure generation tool | **C) Both** — Pipeline/architecture → PlantUML/Graphviz (vector); Results plots → Python matplotlib (bitmap) | RESOLVED |
| 2 | Table data source | **B) User provides CSV** — If data not yet available, leave `\placeholder{tab:name}` in paragraph | RESOLVED |
| 3 | Figure placement | **A) aw-figure inserts automatically** — \input{figures/fig-name} auto-inserted at correct location | RESOLVED |

---

## Status

- [x] Phase 3 design drafted
- [x] Discuss with user → resolve open questions
- [x] Implement Phase 3 skills (5 new skills)
- [ ] Test citation verify on existing sections
- [ ] Phase 3 complete → full paper pipeline ready
