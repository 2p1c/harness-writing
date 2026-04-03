# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Academic Writing Template for **Engineering & Technical Research** - A specialized workspace for English academic writing with Elsevier format, LaTeX compilation, and systematic writing workflows.

## Quick Navigation Map 🗺️

### Where to Find Things
| Need | Location | Purpose |
|------|----------|---------|
| **Reference sentences** | `corpus/` | Reusable academic phrases & high-quality expressions |
| **Work-in-progress** | `drafts/` | Messy notes, early drafts, brainstorming |
| **Final manuscripts** | `manuscripts/` | Chapter-organized formal writing |
| **Visual inspirations** | `figures/` | Collected academic figures for reference |
| **LaTeX templates** | `templates/elsevier/` | Elsevier article class and format templates |
| **Installed skills** | Global skills system | `latex-paper-en`, `research-paper-writer` |

### Core Writing Skills Available

**Installed Skills (Auto-triggered)**
- `latex-paper-en` - Complete LaTeX English paper writing workflow
- `research-paper-writer` - Comprehensive research paper writing assistance

**Citation & References**
- Elsevier numbered citation style `[1], [2], [3]`
- Source verification and traceability checking
- Auto-generated bibliography from references

**Document Generation**
- Primary: LaTeX → PDF (professional publication format)
- Secondary: LaTeX → Word conversion for collaboration
- Multi-chapter manuscript compilation

**Visual Creation**
- Technical diagrams via CLI tools (PlantUML, Graphviz)
- Academic figure templates and formatting
- Figure numbering and cross-reference management

## Essential Commands

### LaTeX Document Processing
```bash
# Compile LaTeX paper to PDF
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex

# Quick compilation
make paper

# Convert LaTeX to Word (when needed)
pandoc main.tex -o paper.docx
```

### Reference Management
```bash
# Generate bibliography
bibtex main.bib

# Validate citations
make check-refs

# Style validation
make check-style
```

### Figure Generation
```bash
# Generate diagrams
plantuml diagrams/*.puml
dot -Tpdf figures/*.dot -o figures/output.pdf

# Update figure references
make update-figs
```

## Workflow Patterns

### Starting New Research
1. **Literature Review** → Save good phrases to `corpus/`
2. **Initial Ideas** → Brain dump in `drafts/`
3. **Structure Planning** → Create chapter outline in `manuscripts/`
4. **LaTeX Writing** → Use `latex-paper-en` skill for structured composition

### Citation Workflow (Elsevier Format)
1. **Numbered Citations** → `[1], [2], [3]` format automatically applied
2. **Source Verification** → Every citation must link to verifiable source
3. **Bibliography** → Auto-generated from `.bib` file references
4. **Style Compliance** → Elsevier formatting rules enforced

### Figure Creation Process
1. **Inspiration Collection** → Save examples to `figures/reference/`
2. **Technical Diagrams** → Generate via LaTeX/TikZ, PlantUML, or Graphviz
3. **Integration** → Proper figure numbering and cross-referencing
4. **Format Compliance** → Elsevier figure formatting standards

### LaTeX-First Workflow
- **Primary Format**: LaTeX (.tex) for professional typesetting
- **Compilation**: PDF output optimized for publication submission
- **Collaboration**: Convert to Word (.docx) only when required by co-authors
- **Version Control**: LaTeX text files work seamlessly with Git

## Repository Architecture

### Skill Integration
- **Auto-triggered Skills**: `latex-paper-en` and `research-paper-writer` activate automatically for academic writing tasks
- **Elsevier Compliance**: Citations, formatting, and structure follow publisher standards
- **CLI Tool Integration**: External tools for advanced figure generation
- **Quality Assurance**: Built-in reference checking and style validation

### Content Organization
- **Chapter Structure**: Each manuscript section in separate `.tex` files
- **Bibliography Management**: Centralized `.bib` file with Elsevier citation style
- **Figure Library**: Organized by type (diagrams, plots, schematics)
- **Template System**: Elsevier article class as foundation

### LaTeX Environment
- **Document Class**: `elsarticle.cls` for Elsevier journals
- **Packages**: Standard academic packages (amsmath, graphicx, cite, etc.)
- **Compilation**: Full LaTeX toolchain with BibTeX for references
- **Output**: Publication-ready PDF with proper formatting

## Quick Start for New Papers
1. Copy Elsevier template structure from `templates/elsevier/`
2. Literature review → populate `corpus/` with reusable phrases
3. Initial ideas → use `drafts/` for brainstorming
4. Formal writing → structured LaTeX chapters in `manuscripts/`
5. Reference management → maintain `.bib` file for citations
6. Compilation → use LaTeX toolchain for PDF generation