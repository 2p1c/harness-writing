# Elsevier LaTeX Article Template

This directory contains the standard Elsevier article template for academic paper writing.

## Files Structure

```
templates/elsevier/
├── main.tex              # Main LaTeX document
├── elsarticle.cls         # Elsevier document class
├── references.bib         # Bibliography file
├── figures/               # Figure files directory
├── sections/             # Individual chapter files
│   ├── abstract.tex
│   ├── introduction.tex
│   ├── methodology.tex
│   ├── results.tex
│   ├── discussion.tex
│   └── conclusion.tex
└── README.md             # This file
```

## Usage

1. Copy this template to your `manuscripts/` directory
2. Rename the project folder appropriately
3. Edit `main.tex` to configure paper details
4. Write content in individual section files
5. Manage references in `references.bib`
6. Compile using standard LaTeX workflow

## Compilation Commands

```bash
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

## Citation Format

This template uses Elsevier's numbered citation style:
- In-text citations: `[1], [2], [3]`
- Bibliography: Auto-generated from `references.bib`
- Style: Elsevier standard format