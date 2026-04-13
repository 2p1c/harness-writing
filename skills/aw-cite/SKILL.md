---
name: aw-cite
description: Scan all .tex files for citation keys, verify each exists in references.bib, auto-fix missing entries from .planning/literature.md, and report status.
triggers:
  - /aw-cite
  - aw-cite
  - citation verify
  - check references
---

# Citation Verifier — aw-cite

## Purpose

Scan all `.tex` files for `\cite{}`, `\citealp{}`, and `\citep{}` citation keys, verify each exists in `references.bib`, flag unused entries, auto-fix missing keys from `.planning/literature.md`, and emit a markdown report.

## Workflow

### Step 1 — Locate TeX files

Glob for all `.tex` files in the active paper project:

```
sections/**/*.tex  +  main.tex
```

Working directory: the active paper subdirectory under `manuscripts/`. If not inside a paper project, abort with a clear error.

### Step 2 — Extract citation keys

Scan every TeX file with a regex to collect all citation keys:

```
\\cite(?:alp)?(?:\[[^\]]*\])?\{([^}]+)\}
\\citep(?:\[[^\]]*\])?\{([^}]+)\}
```

Keys may be comma-separated inside a single brace group (e.g., `\cite{wiener1985,bm3d2007}`). Split on commas and trim whitespace. Collect every key with the source file path where it appears.

### Step 3 — Load references.bib

Parse `references.bib` to extract all entry keys. Match:

```
@...\s*\{\s*([^,]+)\s*, ...
```

Store the set of all defined keys.

### Step 4 — Compare and classify

For each cited key:
- **OK**: key exists in `references.bib`
- **MISSING**: key is cited but not in `references.bib` → collect

For each defined key in `references.bib`:
- **UNUSED**: key is defined but never cited → collect (warning only)

### Step 5 — Auto-fix missing keys

If any keys are MISSING:

1. Check if `.planning/literature.md` exists in the project root
2. If it exists, search its BibTeX section for any MISSING key
3. For each key found in literature.md, append the full `@...{key,...}` entry to `references.bib`
4. If a key cannot be found in literature.md, leave it as MISSING in the report

### Step 6 — Report

Output a markdown table:

```markdown
# Citation Report
**Checked:** N files, M total citations
**Status:** ✅ All resolved | ❌ N missing

| Key | Status | Found In |
|-----|--------|----------|
| wiener1985 | ✅ OK | methodology.tex |
| bm3d2007 | ❌ MISSING | experiment.tex |
| doveri2013 | ⚠️ UNUSED | (defined in references.bib, never cited) |
```

## Output Requirements

- Table columns: Key, Status, Found In (file or "(unused)")
- Status icons: ✅ OK, ❌ MISSING, ⚠️ UNUSED
- Group output: first OK entries, then MISSING, then UNUSED
- Summary line at top: total files checked, total citations, resolution status
- If all resolved: print "✅ All citations resolved"
- If any missing after auto-fix attempt: print "❌ N citation keys still unresolved — add them manually to references.bib"

## Error Handling

- No `.tex` files found → abort with "No TeX files found in sections/"
- No `references.bib` → abort with "references.bib not found"
- Cannot write to `references.bib` when auto-fixing → warn but continue; report still shows MISSING
- `.planning/literature.md` not found → skip auto-fix, report MISSING keys as-is

## Example

```
/aw-cite
```

```
# Citation Report
**Checked:** 6 files, 14 citations
**Status:** ❌ 2 missing

| Key | Status | Found In |
|-----|--------|----------|
| wiener1985 | ✅ OK | methodology.tex |
| bm3d2007 | ✅ OK | experiment.tex, results.tex |
| doveri2013 | ⚠️ UNUSED | (defined in references.bib, never cited) |
| smith2021 | ❌ MISSING | introduction.tex |
| jones2019 | ❌ MISSING | discussion.tex |

Auto-fix: 0 entries appended from .planning/literature.md (2 keys not found).
❌ 2 citation keys still unresolved — add them manually to references.bib.
```
