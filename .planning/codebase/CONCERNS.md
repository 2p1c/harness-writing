# Concerns & Technical Debt

## Missing Test Coverage

- **`npm test` is a no-op** — no unit, integration, or E2E tests exist
- No automated validation of skill behavior or script correctness
- Risk: regressions in helper scripts go undetected

## No CI/CD Pipeline

- No GitHub Actions or other CI configured
- No automated checks on push/PR
- Risk: broken builds or skill regressions are only caught manually

## Incomplete `make check-style`

- `make check-style` echoes a TODO with no actual validation
- Citation and style compliance rely entirely on manual review

## Duplicate `package.json` Files

- Two `package.json` files in the repo root (found at `package.json` and via Glob)
- Can cause confusion about which is authoritative
- Investigate if one is leftover from scaffolding

## Skill Write Permissions Issue

- Background mapper agents could not write to `.planning/codebase/` via Write tool
- Likely due to `settings.local.json` permission allowlist scope
- Workaround: orchestrator writes files manually after agent exploration

## No Version Locking on LaTeX Tools

- `pdflatex`, `bibtex`, `pandoc` must be installed system-wide with no version pinning
- `make update-figs` silently skips if PlantUML/Graphviz unavailable — easy to miss failures

## Live Preview Hardcoded Polling

- `pdf-live-server.js` uses 1000ms fixed polling interval (`pollInterval = 1000`)
- No backoff or adaptive timing
- Could cause unnecessary CPU usage on large projects

## `pdf-live-server.js` Has No Error Logging

- Silent catch in polling watcher (`// File not ready yet, ignore`)
- `evtSource.onerror` silently reconnects with no alerting
- Errors are swallowed rather than surfaced to user

## No Input Validation in Scripts

- `pdf-live-server.js` uses `process.argv[2]` and `process.argv[3]` directly with no validation
- `install-skill-links.js` assumes directories exist without thorough guards

## Skills Dir vs `.agents/skills` Dir

- Both `skills/` and `.agents/skills/` contain skill directories
- `install-skill-links.js` links from `skills/` to `~/.agents/skills/`
- Confusion about which location is canonical for skill development

## File References

- `.claude/settings.local.json` — permission scope
- `package.json` — test placeholder
- `Makefile` — `check-style` incomplete
- `.agents/skills/latex-live-preview/scripts/pdf-live-server.js` — error handling gaps
- `scripts/install-skill-links.js` — input validation gaps
