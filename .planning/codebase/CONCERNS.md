# Codebase Concerns

**Analysis Date:** 2026-04-24

## Priority Recommendations (Most Urgent First)

1. **Fix laser-ultrasound-denoising manuscript title**: Contains profane placeholder text in `main.tex:27`. Evidence: `nihaoNeural fucktest aaaaaaa Network-Based Denoising...`. This blocks clean compilation.
2. **Resolve planning state drift**: SUMMARY.md claims phase 08 completed but VERIFICATION.md shows 4/9 must-haves verified with gaps in methodology-zh.tex, results-zh.tex, discussion-zh.tex, conclusion-zh.tex.
3. **Stop false-success quality gates**: `npm test` always succeeds with no-op; `make check-style` is TODO.
4. **Repair mkdocs.yml metadata**: Site identity is "Awesome Code" / anomalyco/awesome-code - unrelated to this repository.

## Tech Debt

**Release/install contract has policy drift (High):**
- Issue: `.gitignore:62-65` excludes `package.json`, `.npmignore`, and `scripts/` while these define release behavior and `package.json:7` references `scripts/install-skill-links.js`.
- Files: `.gitignore:62-65`, `package.json:7`, `scripts/install-skill-links.js` (now tracked, but policy conflicts remain)
- Impact: Local git workflows can miss changes to release-critical files.
- Fix approach: Remove release-critical files from `.gitignore`; keep ignores only for generated artifacts.

**Template and workflow expectations are misaligned (High):**
- Issue: `aw-finalize` requires sections like `related-work.tex` and `experiment.tex`, but `manuscripts/laser-ultrasound-denoising/main.tex` only wires 5 core sections (missing related_work and experiment).
- Files: `skills/aw-finalize/SKILL.md:82-92`, `manuscripts/laser-ultrasound-denoising/main.tex:58-62`
- Impact: Finalization checks produce false failures on laser-ultrasound-denoising.
- Fix approach: Update template to include all required sections, or parameterize required sections by project profile.

**Manual quality checks have placeholder implementation (Medium):**
- Issue: `check-style` target is explicitly TODO in Makefile.
- Files: `Makefile:46-49`
- Impact: No automated style/lint gate for LaTeX and skill docs.
- Fix approach: Add `latexindent`, markdown linting, spell/style checks; fail CI on violations.

## Known Bugs

**Manuscript title contains profane placeholder text (High):**
- Symptoms: Title includes test/profane text in frontmatter.
- Files: `manuscripts/laser-ultrasound-denoising/main.tex:27`
- Trigger: Running `make paper` or preparing submission directly from current manuscript.
- Workaround: Manual title rewrite before every compile/review cycle.

**Translation phase has incomplete outputs (High):**
- Symptoms: Phase 08 SUMMARY.md claims all requirements completed, but VERIFICATION.md shows 4/9 must-haves verified.
- Files: `.planning/phases/08-bilingual-chinese-translation/08-01-SUMMARY.md:47`, `.planning/phases/08-bilingual-chinese-translation/08-01-VERIFICATION.md:4-5`
- Gaps: methodology-zh.tex, results-zh.tex, discussion-zh.tex, conclusion-zh.tex contain template placeholders.
- Workaround: Re-run translation for incomplete sections or acknowledge partial completion.

**Finalization abstract path check is inconsistent with template layout (Medium):**
- Issue: `aw-finalize` checks `abstract.tex` at root, while template uses `sections/abstract.tex` with `\input{sections/abstract}`.
- Files: `skills/aw-finalize/SKILL.md:74-78`, `manuscripts/physics-constrained-multi-domain-denoising/main.tex:42`
- Trigger: Running `/aw-finalize` on current manuscript structure.
- Workaround: Ensure abstract is wired correctly or patch skill logic.

## Security Considerations

**Over-privileged CI workflow with unconditional deploy (Medium, Operational risk):**
- Risk: Workflow has `permissions: contents: write` and runs `mkdocs gh-deploy --force` on every push to `main`/`develop`.
- Files: `.github/workflows/ci.yml:7-8`, `.github/workflows/ci.yml:30`
- Current mitigation: Deployment scoped to branch push events.
- Recommendations: Use least-privilege token scopes, require protected branch checks, gate deploy jobs behind explicit release conditions.

**Cache path uses non-ASCII tilde character (Low):**
- Risk: `～/.cache` (full-width tilde) likely not matching expected home cache path, causing cache misses.
- Files: `.github/workflows/ci.yml:26`
- Recommendations: Replace with standard `~/.cache` and verify cache hit metrics.

**No secret leak indicators in scanned tracked docs (Low):**
- Risk: None detected in reviewed markdown/yaml/tex files.
- Files: `README.md`, `CLAUDE.md`, `.planning/*`, `manuscripts/*`
- Recommendations: Add secret scanning in CI to keep this guarantee enforceable.

## Performance Bottlenecks

**CI job does deployment work on every push without validation stage (Medium):**
- Problem: Workflow runs install + `mkdocs gh-deploy --force` directly; no earlier fast-fail quality stage.
- Files: `.github/workflows/ci.yml:21-30`
- Cause: Pipeline is deploy-first, not validate-first.
- Improvement path: Split into `lint/test/validate` job + gated `deploy` job.

## Fragile Areas

**Planning truth sources conflict (High, Process fragility):**
- Files: `.planning/STATE.md`, `.planning/phases/08-bilingual-chinese-translation/08-01-SUMMARY.md`, `.planning/phases/08-bilingual-chinese-translation/08-01-VERIFICATION.md`
- Why fragile: Status and completion assertions disagree (SUMMARY claims completed, VERIFICATION reports 4/9 gaps).
- Safe modification: Treat verification artifacts as source of truth and derive summary/state from them automatically.
- Test coverage: No automated consistency checks detected for planning artifacts.

**Manuscript tracking policy conflicts with active workflow (High, Process fragility):**
- Files: `.gitignore:13-15`, `manuscripts/laser-ultrasound-denoising/*`, `manuscripts/physics-constrained-multi-domain-denoising/*`
- Why fragile: `.gitignore` excludes `manuscripts/*` with exceptions, but manuscripts are central outputs and actively tracked.
- Safe modification: Review and clarify manuscript ignore policy; ensure active project is not inadvertently ignored.
- Test coverage: No guard to detect newly ignored/untracked manuscript deliverables.

## Scaling Limits

**Two manuscripts with divergent states (Medium):**
- Current capacity: `manuscripts/laser-ultrasound-denoising` (stale, profane title, incomplete Chinese translation) and `manuscripts/physics-constrained-multi-domain-denoising` (active).
- Limit: Stale manuscript may confuse contributors or contaminate automated workflows.
- Scaling path: Archive stale manuscript or establish clear project lifecycle policy.

## Dependencies at Risk

**Documentation/deploy metadata appears copied from unrelated project (High, Documentation risk):**
- Risk: `mkdocs.yml` uses site identity "Awesome Code" and URL `https://github.com/anomalyco/awesome-code` - not matching this repository purpose.
- Files: `mkdocs.yml:1-4`, `mkdocs.yml:15-19`
- Impact: Published docs can mislead users and damage trust in release artifacts.
- Migration plan: Replace with repo-accurate metadata/nav and add docs smoke test in CI.

**Skill path conventions are inconsistent across docs (Medium):**
- Risk: Mixed references to `skills/...` and `.agents/skills/...` in documentation.
- Files: `README.md`, `CLAUDE.md`, `skills/zotero-context-injector/SKILL.md`
- Impact: Users can follow non-portable paths and fail setup.
- Migration plan: Define one canonical runtime path contract and lint docs for forbidden path patterns.

## Missing Critical Features

**No enforceable test suite for package/skills behavior (High):**
- Problem: `npm test` always succeeds without testing anything.
- Blocks: Safe refactoring of `skills/*`, confidence in release candidates.
- Files: `package.json:8`

**No quality gate for manuscript placeholder/profanity content (High):**
- Problem: Profane title and placeholder text can pass through to compiled PDF.
- Blocks: Reliable submission readiness and professional outputs.
- Files: `manuscripts/laser-ultrasound-denoising/main.tex:27`

**No automated cross-file consistency checks for planning system (Medium):**
- Problem: `.planning` artifacts can contradict each other without detection.
- Blocks: Trustworthy orchestration decisions for later phases.
- Files: `.planning/STATE.md`, `.planning/phases/*/*-SUMMARY.md`, `.planning/phases/*/*-VERIFICATION.md`

## Test Coverage Gaps

**Install path and postinstall behavior untested (High):**
- What's not tested: Whether `npm install -g @2p1c/harness-writing` executes setup successfully with published file list.
- Files: `package.json`, `.gitignore`, `scripts/install-skill-links.js`
- Risk: Broken installation in fresh environments.
- Priority: High

**Manuscript content quality untested (High):**
- What's not tested: Profane/placeholder content in manuscripts, citation completeness, LaTeX compilation health.
- Files: `manuscripts/laser-ultrasound-denoising/main.tex:27`, `manuscripts/physics-constrained-multi-domain-denoising/references.bib`
- Risk: Submission-ready documents may contain inappropriate content.
- Priority: High

**Documentation integrity untested (Medium):**
- What's not tested: Whether docs config and referenced paths map to real repo assets.
- Files: `mkdocs.yml`, `README.md`, `CLAUDE.md`
- Risk: Broken onboarding and incorrect operational guidance.
- Priority: Medium

---

*Concerns audit: 2026-04-24*
