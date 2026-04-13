---
name: aw-finalize
description: Final Compile & Check — Compile the complete paper with make paper, verify all references/citations resolve, check word count, and update STATE.md to "ready for submission". Trigger: /aw-finalize
---

# Skill: aw-finalize

**Purpose:** Final compilation and quality check for a complete academic paper manuscript.

**Trigger:** `/aw-finalize` — execute after all sections, tables, figures, and abstract are complete.

**Working directory:** `manuscripts/{slug}/` (slug = paper project directory name)

---

## Step-by-Step Workflow

### Step 1: Change to Manuscript Directory

```bash
cd manuscripts/{slug}
```

If no slug is provided, infer from the current working directory or prompt the user.

### Step 2: Clean and Compile

```bash
make clean
make paper
```

Capture the exit code of `make paper`.

### Step 3: Parse main.log for Errors

Read the contents of `main.log` (generated during compilation). Extract and display the first 5 lines of any error messages found.

### Step 4: Check Undefined References

```bash
grep "Undefined reference" main.log
```

List any unresolved `\ref` keys found in the log.

### Step 5: Check Unresolved Citations

```bash
grep "Citation" main.blg
```

List any unresolved `\cite` keys found in the bibliography log.

### Step 6: Count Words

Count words from the compiled manuscript. Preferred method:

```bash
# Count words in all .tex section files
wc -w sections/*.tex
```

Alternative if PDF is available:
```bash
# Extract text from PDF and count
pdftotext manuscript.pdf - | wc -w
```

Target range: 7000–8500 words. Note any deviation.

### Step 7: Verify Abstract

```bash
test -f abstract.tex && test -s abstract.tex
```

Check that `abstract.tex` exists and has non-zero content.

### Step 8: Verify All 7 Sections Present

Check that all required sections exist:

```bash
test -f sections/introduction.tex
test -f sections/related-work.tex
test -f sections/methodology.tex
test -f sections/experiment.tex
test -f sections/results.tex
test -f sections/discussion.tex
test -f sections/conclusion.tex
```

List any missing sections.

### Step 9: Update STATE.md

If all checks pass, update `STATE.md` in the project root to mark phase status as "ready for submission".

```bash
# Update STATE.md phase status
# Look for a phase/status field and update it
```

If checks fail, update STATE.md to note remaining issues.

---

## Checklist

| Check | Method | If Fail |
|-------|--------|---------|
| `make paper` exit code | `bash $?` | Show first 5 error lines from `.log` |
| No Undefined reference | `grep "Undefined reference" main.log` | List missing `\ref` keys |
| No unresolved citations | `grep "Citation" main.blg` | List missing `\cite` keys |
| Word count 7000–8500 | `wc -w sections/*.tex` or PDF extract | Note deviation from target |
| Abstract present | `test -f abstract.tex` | Warn that abstract is missing |
| All 7 sections | `test -f sections/{section}.tex` | List missing sections |

---

## Output Report

Generate and display the following markdown report at the end:

```markdown
# Final Check Report

**Compile:** ✅ No errors | ❌ Failed
**Errors:** (if any, first 5 lines from .log)
**Undefined refs:** (if any)
**Unresolved citations:** (if any)
**Word count:** N / 8000 (target)
**Abstract:** ✅ Present | ❌ Missing
**Sections:** ✅ All 7 present | ❌ Missing: [list]

**Status:** Ready for submission | N issues found
```

---

## Exit Criteria

- `make paper` exits with code 0
- Zero undefined references
- Zero unresolved citations
- Word count within 7000–8500 range
- Abstract file exists and is non-empty
- All 7 required sections present

If all criteria are met: update STATE.md to `"ready for submission"`.

If any criterion fails: report the failures clearly and leave STATE.md unchanged.
