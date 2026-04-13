# Codebase Concerns

**Analysis Date:** 2026-04-12

## Missing/Incomplete Implementations

### Missing Script: check-prereqs.sh

**Area:** `skills/latex-live-preview/`
**Issue:** `SKILL.md` line 39 references `scripts/check-prereqs.sh` to verify prerequisites, but this script does not exist in the `scripts/` directory.
**Files:** `skills/latex-live-preview/SKILL.md:39`
**Impact:** Users following the SKILL.md instructions will encounter a missing file error. The prerequisite check cannot be performed as documented.
**Fix approach:** Create `scripts/check-prereqs.sh` to verify `latexmk` and `fswatch`/`inotifywait` availability and port 3000 availability.

### Outdated Documentation: pdf-live-server

**Area:** `skills/latex-live-preview/`
**Issue:** `SKILL.md` references `pdf-live-server` as the primary server for PDF serving, but the README states the preview server was rewritten to remove external dependencies (`pdf-live-server`/`fswatch`).
**Files:** `skills/latex-live-preview/SKILL.md:54`, `README.md:8`
**Impact:** Documentation mismatch. The SKILL.md instructs to use `pdf-live-server` which is no longer the primary implementation.
**Fix approach:** Update `SKILL.md` to reflect the new Node.js polling-based implementation. The `start-preview.sh` script uses `pdf-live-server` if available, otherwise falls back to Python http.server.

### Incomplete Makefile Target

**Area:** `Makefile`
**Issue:** Line 48 has a TODO comment: `"TODO: Add style checking tools"`
**Files:** `Makefile:48`
**Impact:** The `check-style` target is incomplete and does not perform actual style validation.
**Fix approach:** Implement style checking (e.g., add `latexindent` for LaTeX formatting or integrate a linter).

### No Test Coverage

**Area:** `package.json`
**Issue:** Test script is a no-op: `"test": "echo \"No tests configured\" && exit 0"`
**Files:** `package.json:8`
**Impact:** No automated verification that skills or scripts work correctly. Risk of regressions going undetected.
**Fix approach:** Add actual tests using an appropriate framework for the skill validation workflow.

### No CI/CD Pipeline

**Area:** Project-wide
**Issue:** No GitHub Actions or other CI configured
**Files:** No `.github/workflows/` directory
**Impact:** Broken builds or skill regressions are only caught manually.
**Fix approach:** Add GitHub Actions workflow to run basic checks on push/PR.

## Documentation Issues

### Wrong Path References in CLAUDE.md

**Area:** `CLAUDE.md`
**Issue:** References `.agents/skills/*/references/` but the actual directory is `skills/`
**Files:** `CLAUDE.md:16`, `CLAUDE.md:115`
**Impact:** AI assistant following CLAUDE.md instructions will look in the wrong directory for skill references.
**Fix approach:** Update path references from `.agents/skills/` to `skills/`.

### GitHub Path References in README

**Area:** `README.md`
**Issue:** Line 172 references `.agents/skills/zotero-context-injector/scripts/build_zotero_context.py` for troubleshooting. This path may not exist in all installations.
**Files:** `README.md:172`
**Impact:** Users troubleshooting Zotero issues may be directed to a non-existent path.
**Fix approach:** Use a path that works regardless of whether skills are installed via npm or locally.

## Dependency Issues

### Unmanaged Python Dependencies in skill-creator

**Area:** `skills/skill-creator/scripts/`
**Issue:** `run_loop.py` and `improve_description.py` import `anthropic` package but there is no `requirements.txt` or `pyproject.toml` to manage this dependency.
**Files:** `skills/skill-creator/scripts/run_loop.py:18`, `skills/skill-creator/scripts/improve_description.py:14`
**Impact:** The skill-creator evaluation loop requires `anthropic` SDK but this is not documented as a prerequisite.
**Fix approach:** Add a `requirements.txt` or document the dependency clearly in the SKILL.md.

### Node.js Only Documented but Python Scripts Exist

**Area:** Project-wide
**Issue:** `package.json` specifies `"engines": {"node": ">=18.0.0"}` but several skills contain Python scripts (`skill-creator`, `zotero-context-injector`) that are not Node.js.
**Files:** `package.json:27`, `skills/skill-creator/scripts/*.py`, `skills/zotero-context-injector/scripts/*.py`
**Impact:** Users expecting Node.js-only setup may be confused by Python script requirements.
**Fix approach:** Document Python dependency in README or install instructions.

## Path and Configuration Issues

### Hardcoded Temporary File Paths

**Area:** `skills/latex-live-preview/scripts/start-preview.sh`
**Issue:** Uses hardcoded `/tmp/` paths for log and PID files
**Files:** `skills/latex-live-preview/scripts/start-preview.sh:9`, `skills/latex-live-preview/scripts/start-preview.sh:111`
**Impact:** These paths may not work correctly in restricted environments (e.g., containers, some CI systems). PID file uses relative path from PROJECT_DIR but stores absolute `/tmp/` location.
**Fix approach:** Use environment variables or a configurable temp directory. Consider XDG base directory spec.

### Hardcoded User-Specific Paths in Settings

**Area:** `.claude/settings.local.json`
**Issue:** Lines 18-19 contain absolute paths with `/Users/zyt/` specific to the developer's environment
**Files:** `.claude/settings.local.json:18-19`
**Impact:** This file is gitignored but would break if used by another developer. However, this is expected behavior for local settings - not a critical issue.
**Fix approach:** This is actually correct behavior (local settings should be personal). Acknowledged as working as intended.

## Architecture/Design Concerns

### Dual Directory Structure Confusion

**Area:** Project structure
**Issue:** Both `skills/` and `.agents/skills/` directories exist. README says `.agents/skills/` is the "原本地位置（符号链接来源）" but the `.agents/skills/` directory is not a symlink - it's a regular directory with identical content.
**Files:** `skills/`, `.agents/skills/`, `README.md:164`
**Impact:** Confusion about which directory is the source of truth. Could lead to editing the wrong location.
**Fix approach:** Clarify the relationship between the two directories. If `.agents/skills/` is meant to be a symlink target, create it as such. If both are independent copies, document why.

### Live Preview Hardcoded Polling

**Area:** `skills/latex-live-preview/`
**Issue:** `pdf-live-server.js` (if it exists in `.agents/skills/`) uses 1000ms fixed polling interval with no backoff or adaptive timing.
**Files:** Potentially `.agents/skills/latex-live-preview/scripts/` (if it exists)
**Impact:** Could cause unnecessary CPU usage on large projects.
**Fix approach:** Implement adaptive polling or event-based file watching where available.

### No Input Validation in Scripts

**Area:** `scripts/install-skill-links.js`
**Issue:** Uses `process.argv` directly with minimal validation. Assumes directories exist.
**Files:** `scripts/install-skill-links.js`
**Impact:** Could fail silently or unexpectedly if environment is misconfigured.
**Fix approach:** Add proper input validation and error handling.

### Large skill-creator Scripts

**Area:** `skills/skill-creator/scripts/`
**Issue:** Six Python scripts totaling 1902 lines with complex dependencies. `run_loop.py` is 332 lines and `run_eval.py` is 310 lines.
**Files:** `skills/skill-creator/scripts/*.py`
**Impact:** High maintenance burden. These scripts implement an entire evaluation framework.
**Fix approach:** Consider extracting common utilities into shared modules. Some scripts could be split.

## Security Considerations

### No Security Issues Detected

**Area:** Project-wide
**Status:** No hardcoded secrets found in committed files. `.gitignore` correctly excludes `settings.local.json` which may contain personal configuration.

---

*Concerns audit: 2026-04-12*
