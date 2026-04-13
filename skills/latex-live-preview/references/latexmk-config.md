# latexmk Configuration Reference

## What is latexmk?

`latexmk` is a Perl script that automatically runs LaTeX, BibTeX, and index generators the correct number of times to resolve all references.

## Key Flags Used

| Flag | Meaning |
|------|---------|
| `-pvc` | Preview Continuous: watch for file changes and recompile |
| `-pdf` | Output PDF (instead of DVI) |
| `-quiet` | Suppress most output to stdout |

## Global latexmkrc Configuration

Create `~/.latexmkrc` for persistent defaults:

```perl
# Always use pdflatex
$pdf_mode = 1;

# pdflatex with nonstopmode (no interactive prompts)
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode %O %S';

# Auto-run bibtex if .bib exists
$bibtex_use = 1;

# Suppress intermediate files we don't need
$PDFLATEX = 'pdflatex %O %S';

# Watch these file types
@watch_files = qw(*.tex *.bib *.cls *.sty *.cfg);
```

## Project-level .latexmkrc

Place a `.latexmkrc` in the paper directory:

```perl
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode %O %S';
$out_dir = '.';
```

## Troubleshooting

### "LaTeX Warning: Reference `fig:1' undefined"
Run `latexmk` twice. First pass resolves labels, second pass picks them up.

### "BibTeX: couldn't find database file"
Ensure your `.bib` file matches the `.tex` filename:
- `main.tex` looks for `main.bib`

### "PDF not updating in browser"
- `pdf-live-server` only watches the PDF file, not the `.tex` files
- `latexmk -pvc` handles `.tex` → PDF compilation
- If browser doesn't refresh, the PDF may be cached — try hard refresh (Cmd+Shift+R)

### Slow compilation
Add `$max_repeat = 2;` to `.latexmkrc` to limit recompile passes.
