#!/bin/bash
# LaTeX Compile Check Script
# Validates that LaTeX files compile without errors

set -e

MAIN_FILE="${1:-main}"
AUX_FILE="${MAIN_FILE}.aux"
LOG_FILE="${MAIN_FILE}.log"

echo "=== LaTeX Compile Check ==="
echo "Main file: ${MAIN_FILE}.tex"
echo ""

# Check if main.tex exists
if [ ! -f "${MAIN_FILE}.tex" ]; then
    echo "ERROR: ${MAIN_FILE}.tex not found"
    exit 1
fi

# Run pdflatex twice to resolve references
echo "Running pdflatex (pass 1)..."
pdflatex -interaction=nonstopmode "${MAIN_FILE}.tex" > /dev/null 2>&1

echo "Running pdflatex (pass 2)..."
pdflatex -interaction=nonstopmode "${MAIN_FILE}.tex" > /dev/null 2>&1

# Run bibtex if .bib file exists
if [ -f "${MAIN_FILE}.bib" ]; then
    echo "Running bibtex..."
    bibtex "${MAIN_FILE}" > /dev/null 2>&1 || echo "BibTeX warning (see ${LOG_FILE})"

    echo "Running pdflatex (pass 3 - after bibtex)..."
    pdflatex -interaction=nonstopmode "${MAIN_FILE}.tex" > /dev/null 2>&1

    echo "Running pdflatex (pass 4 - final)..."
    pdflatex -interaction=nonstopmode "${MAIN_FILE}.tex" > /dev/null 2>&1
fi

echo ""
echo "=== Checking for Errors ==="

# Check for fatal errors in log
if grep -q "Fatal error" "${LOG_FILE}"; then
    echo "FATAL ERROR detected!"
    grep -A 5 "Fatal error" "${LOG_FILE}"
    exit 1
fi

# Check for undefined references
if grep -q "LaTeX Warning: Reference.*undefined" "${LOG_FILE}"; then
    echo "WARNING: Undefined references found:"
    grep "LaTeX Warning: Reference.*undefined" "${LOG_FILE}"
fi

# Check for undefined citations
if grep -q "LaTeX Warning:.*undefined" "${LOG_FILE}"; then
    echo "WARNING: Undefined citations found:"
    grep "LaTeX Warning:.*undefined" "${LOG_FILE}"
fi

# Check for overfull/underfull boxes
OVERFULL=$(grep -c "Overfull" "${LOG_FILE}" 2>/dev/null || echo "0")
UNDERFULL=$(grep -c "Underfull" "${LOG_FILE}" 2>/dev/null || echo "0")

if [ "${OVERFULL}" -gt 0 ]; then
    echo "WARNING: ${OVERFULL} overfull hbox(es) detected"
fi

if [ "${UNDERFULL}" -gt 0 ]; then
    echo "INFO: ${UNDERFULL} underfull box(es) detected (usually not critical)"
fi

# Check if PDF was generated
if [ -f "${MAIN_FILE}.pdf" ]; then
    PDF_SIZE=$(du -h "${MAIN_FILE}.pdf" | cut -f1)
    echo ""
    echo "SUCCESS: PDF generated (${PDF_SIZE})"
    exit 0
else
    echo "ERROR: PDF file not generated"
    exit 1
fi
