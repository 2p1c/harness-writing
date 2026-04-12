# Testing

## Test Status: Not Configured

```json
// package.json
"test": "echo \"No tests configured\" && exit 0"
```

## No Test Framework

This is a **skill workspace** (markdown prompts + helper scripts), not an application with business logic to unit test. No testing framework is used.

## Validation Approaches

| Check | Method | Command |
|-------|--------|---------|
| Citation references | grep | `make check-refs` |
| Style compliance | TODO | `make check-style` |
| LaTeX compilation | pdflatex | `make paper` |
| PDF generation | LaTeX build | `make pdf` |

## Quality Gates

- **Citation check** — `grep -n "\\cite{"` validates `\cite{}` usage
- **LaTeX compilation** — `pdflatex` exit code confirms successful build
- **BibTeX** — validates `.bib` file syntax

## Manual Testing

- **Live preview** — `latex-live-preview` skill runs pdf-live-server for visual verification
- **PDF output** — `manuscripts/*/main.pdf` generated and reviewed manually
- **Pandoc export** — `make word` produces DOCX for collaborator review

## CI/CD

- No CI pipeline configured
- Manual `make paper` / `make quick` for validation

## File References

- `package.json` — test script placeholder
- `Makefile` — `check-refs`, `check-style` targets
