# Makefile for Academic Paper Template

# Variables
MAIN = main
BIBFILE = references
SECTIONS_DIR = sections
FIGURES_DIR = figures

# LaTeX compilation
.PHONY: all clean paper quick pdf bib

all: paper

# Full compilation with bibliography
paper: $(MAIN).pdf

$(MAIN).pdf: $(MAIN).tex $(BIBFILE).bib $(SECTIONS_DIR)/*.tex
	pdflatex $(MAIN)
	bibtex $(MAIN)
	pdflatex $(MAIN)
	pdflatex $(MAIN)

# Quick compilation without bibliography
quick:
	pdflatex $(MAIN)

# Force PDF generation
pdf:
	pdflatex $(MAIN)

# Bibliography only
bib:
	bibtex $(MAIN)

# Convert to Word (requires pandoc)
word: $(MAIN).docx

$(MAIN).docx: $(MAIN).tex
	pandoc $(MAIN).tex --bibliography=$(BIBFILE).bib --citeproc -o $(MAIN).docx

# Validation commands
check-refs:
	@echo "Checking citation references..."
	@grep -n "\\cite{" $(MAIN).tex $(SECTIONS_DIR)/*.tex || echo "No citations found"

check-style:
	@echo "Checking style compliance..."
	@echo "TODO: Add style checking tools"

# Figure management
update-figs:
	@echo "Processing figures..."
	@find $(FIGURES_DIR) -name "*.puml" -exec plantuml {} \; 2>/dev/null || echo "PlantUML not found"
	@find $(FIGURES_DIR) -name "*.dot" -exec dot -Tpdf {} -o {}.pdf \; 2>/dev/null || echo "Graphviz not found"

# Clean build files
clean:
	rm -f *.aux *.bbl *.blg *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz

# Deep clean including PDF
distclean: clean
	rm -f $(MAIN).pdf $(MAIN).docx

# Help
help:
	@echo "Available commands:"
	@echo "  make paper      - Full compilation with bibliography"
	@echo "  make quick      - Quick compilation without bibliography"
	@echo "  make word       - Convert to Word format"
	@echo "  make check-refs - Check citation references"
	@echo "  make update-figs- Process figure files"
	@echo "  make clean      - Remove build files"
	@echo "  make distclean  - Remove all generated files"