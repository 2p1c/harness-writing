# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Academic Writing Template for **Engineering & Technical Research** - A specialized workspace for English academic writing with Elsevier format, LaTeX compilation, and systematic writing workflows.

## Quick Navigation Map

| Need | Location | Purpose |
|------|----------|---------|
| **Paper projects** | `manuscripts/` | Active paper writing projects |
| **Templates** | `templates/elsevier/` | Elsevier LaTeX template |
| **Corpus** | `corpus/` | Academic phrase collection |
| **Reference docs** | `.agents/skills/*/references/` | Detailed guides per skill |

## Installed Skills (Auto-triggered)

| Skill | Purpose | Triggers |
|-------|---------|----------|
| `paper-outline-generator` | Generate IMRAD paper outlines | `/outline`, "大纲", "论文结构" |
| `latex-paper-en` | Write LaTeX sections with Elsevier format | `/write`, "撰写章节" |
| `academic-review` | Adversarial dual-agent text critique | `/review`, "审查", "润色" |
| `research-paper-writer` | Orchestrate full paper workflow | `/newpaper`, "写论文" |
| `literature-manager` | Manage citations and references | `/cite`, "添加引用" |
| `figure-integrator` | Generate and format figures | `/figure`, "图表" |

## Commands

**All commands run inside a project directory** (`manuscripts/your-paper/`):

```bash
# Paper Writing Pipeline
/newpaper <title>      # Initialize new paper project
/outline <topic>        # Generate IMRAD outline
/write <section>       # Write a section (introduction, methodology, etc.)
/review                 # Adversarial review of current text
/compile                # Compile to PDF (make paper)
/check-refs             # Validate citation references

# Supporting Commands
/cite <author year>     # Add citation to references.bib
/figure <description>   # Generate figure with PlantUML/Graphviz
```

### Compilation (Makefile)

```bash
make paper        # Full compilation with bibliography
make quick        # Quick compilation (no bibliography)
make word         # Export to Word via pandoc
make clean        # Remove .aux, .bbl, .log, etc.
make distclean     # Remove all generated files
```

## Workflow Pipeline

```
/newpaper <title>
    │
    ▼
/outline <topic>
    │  (approve outline)
    ▼
/write <section> (for each section)
    │
    ▼
/review (2-3 adversarial rounds)
    │
    ▼
/compile
    │
    ▼
PDF ready
```

### Writing Order
1. Methodology (know what you did)
2. Results (have the data)
3. Introduction (understand context)
4. Discussion (interpret findings)
5. Conclusion (summarize)
6. Abstract (write last)

## Architecture

### Project Structure (per paper)
```
manuscripts/[paper-name]/
├── project.yaml       # Metadata (title, authors, journal)
├── outline.md        # Generated outline
├── main.tex          # Main document
├── references.bib    # Bibliography
└── sections/
    ├── abstract.tex
    ├── introduction.tex
    ├── methodology.tex
    ├── results.tex
    ├── discussion.tex
    └── conclusion.tex
```

**Note**: `templates/elsevier/` is the source template. Copy it to `manuscripts/` to start a new project:
```bash
cp -r templates/elsevier manuscripts/my-paper
```

### Skill Structure
```
.agents/skills/[skill-name]/
├── SKILL.md           # Main skill file (auto-triggered)
├── references/        # Detailed reference docs
├── agents/           # Sub-agents (for complex skills)
└── scripts/           # Helper scripts
```

## Academic Review System (Adversarial Loop)

The `/review` command uses a dual-agent critique system:

```
Text → Critic Agent → Critique Report → Improver Agent → Improved Text
                                            │
                              ┌─────────────┴─────────────┐
                              │ User decides: continue?   │
                              └─────────────┬─────────────┘
                                            │ Yes (max 3)
                                            ▼
                                      Final Text
```

**Critic Agent** identifies:
- Vague language and precision issues
- Missing citations or unsupported claims
- Logical flow problems
- Academic register inconsistencies

**Improver Agent** refines text to address critique while preserving author voice.

## Elsevier Format Reference

### Document Setup
- Document class: `\documentclass[review]{elsarticle}`
- Bibliography: `\bibliographystyle{elsarticle-num}`
- Packages: `amsmath`, `booktabs`, `graphicx`, `cite`, `lineno`, `hyperref`

### Citation Style
- Use `\cite{key}` → numbered `[1]`
- Use `\citealp{key1,key2}` for grouped citations
- DO NOT use author-date format

### Table Format (booktabs)
```latex
\begin{tabular}{lccc}
    \toprule
    Header & Value & Result & Notes \\
    \midrule
    Data & 10.2 & 0.95 & OK \\
    \bottomrule
\end{tabular}
```

## Important Notes

- This is a **template workspace**, not a running application
- Skills activate via slash commands (/) or skill trigger phrases
- Review `/review` output carefully for escalated issues (structural problems needing author attention)
- PlantUML and Graphviz optional — `/figure` gracefully handles missing tools
