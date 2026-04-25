# External Integrations

**Analysis Date:** 2026-04-24

## APIs & External Services

**Developer/Tooling Platforms:**
- GitHub - repository hosting and docs deployment target
  - SDK/Client: `git` CLI + GitHub Actions runners configured in `.github/workflows/ci.yml`
  - Auth: GitHub Actions token (implicit in workflow job permissions `contents: write` in `.github/workflows/ci.yml`)
- Exa Search MCP (optional, user-configured) - external web research from the local permission surface
  - SDK/Client: MCP endpoint `mcp__plugin_ecc_exa__web_search_exa` in `.claude/settings.local.json`
  - Auth: managed by local MCP setup (no repo-stored credentials)

**Research/Literature Services:**
- Zotero (local DB + optional HTTP API) - literature metadata and PDF context ingestion
  - SDK/Client: direct SQLite reads in `scripts/build_zotero_context.py`
  - Auth: optional `ZOTERO_API_KEY` for HTTP API fallback documented in `skills/aw-research/SKILL.md`

## Data Storage

**Databases:**
- SQLite (local Zotero database, external to repo)
  - Connection: path-based (`--db-path` / auto-discovered Zotero data directory) in `scripts/build_zotero_context.py`
  - Client: Python `sqlite3` in `scripts/build_zotero_context.py`

**File Storage:**
- Local filesystem only for project artifacts (manuscripts, figures, sections) under `manuscripts/` and `templates/`
- External-local Zotero attachment storage read from `storage/` path in `scripts/build_zotero_context.py`

**Caching:**
- GitHub Actions dependency cache for MkDocs build (`actions/cache@v4` in `.github/workflows/ci.yml`)

## Authentication & Identity

**Auth Provider:**
- Custom/local environment based
  - Implementation: API keys and tokens are read from runtime environment (example: `ZOTERO_API_KEY` usage in `skills/aw-research/SKILL.md`), not committed to repository files

## Monitoring & Observability

**Error Tracking:**
- None detected (no Sentry/Datadog/NewRelic integration in repository code/config)

**Logs:**
- Script-level local logs to temp files (example: `/tmp/latex-live-preview.log` in `skills/latex-live-preview/scripts/start-preview.sh`)
- Compile diagnostics from LaTeX `.log`/`.blg` checked by `skills/latex-paper-en/scripts/compile-check.sh` and `skills/aw-finalize/SKILL.md`

## CI/CD & Deployment

**Hosting:**
- GitHub Pages via MkDocs deploy command `mkdocs gh-deploy --force` in `.github/workflows/ci.yml`

**CI Pipeline:**
- GitHub Actions workflow `.github/workflows/ci.yml` triggered on pushes to `main` and `develop`

## Environment Configuration

**Required env vars:**
- `ZOTERO_API_KEY` (only when using Zotero HTTP API fallback in `skills/aw-research/SKILL.md`)
- `PORT` (optional override for live preview server in `skills/latex-live-preview/SKILL.md` and `skills/latex-live-preview/scripts/start-preview.sh`)
- `PDF_DIR` (used by Python fallback server in `skills/latex-live-preview/scripts/start-preview.sh`)

**Secrets location:**
- Runtime shell environment and local developer settings (`.claude/settings.local.json` permissions allow runtime tool access; no secret values stored in repository)

## Webhooks & Callbacks

**Incoming:**
- None detected (no webhook listener endpoints or HTTP server callbacks in repository application code)

**Outgoing:**
- Git operations and gh-deploy push from CI to GitHub Pages (workflow in `.github/workflows/ci.yml`)
- Optional Zotero HTTP GET calls (`https://api.zotero.org/...`) documented in `skills/aw-research/SKILL.md`

---

*Integration audit: 2026-04-24*