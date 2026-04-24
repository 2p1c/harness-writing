# Testing Strategy

**Analysis Date:** 2026-04-24

## Overview

This repository is a **skill framework** for academic paper writing, not a traditional software project. It has **no automated test suite** in the conventional sense (no pytest, no Jest, no Playwright).

Testing is performed through:
1. **Compilation validation** — LaTeX build verification
2. **Citation checking** — pattern-based verification
3. **Manual quality gates** — human-reviewed checkpoints in the writing workflow
4. **Skill evaluation** — for skill-creation workflows only

## Build Validation (LaTeX)

**Framework:** `make` targets in `Makefile`

```bash
make quick          # Single-pass LaTeX compile (no bibliography)
make paper          # Full compile: pdflatex → bibtex → pdflatex → pdflatex
make check-refs     # Scan \cite{} patterns against references.bib
```

**What it tests:**
- LaTeX syntax validity
- Citation key resolution
- Cross-reference integrity (`\ref{}` targets exist)
- Bibliography compilation

**No automated test runner** — user runs `make` manually to verify changes.

## Citation Verification

**Skill:** `aw-cite` — scans all `.tex` files, verifies keys exist in `references.bib`

```bash
/aw-cite   # Triggers aw-cite skill
```

**Checks:**
- All `\cite{}`, `\citealp{}`, `\citep{}` keys exist in `references.bib`
- No unused entries in `references.bib` (warning only)
- Auto-fix missing keys from `.planning/literature.md` BibTeX section

**Output:** Markdown table with status per key (OK / MISSING / UNUSED)

## Manual Quality Gates (Writing Workflow)

The GSDAW writing pipeline uses **human-reviewed checkpoints**:

**Wave execution (`aw-execute`):**
- After each wave, `aw-review` presents a quality gate report:
  - LaTeX compile status
  - Word count vs. target (from ROADMAP)
  - Citation resolution status
  - Placeholder/TODO scan
- User responds: `继续` (continue) / `修改` (modify) / `暂停` (pause)

**Phase review (`aw-review`):**
- Section-by-section quality review
- Verifies: scientific accuracy, clarity, structure, citations
- Produces: markdown summary with recommendations

**No automated assertions** — quality is human-judged at these gates.

## Skill Evaluation (skill-creator)

The `skill-creator` skill has a **quantitative evaluation system** for skill development:

**Workflow:**
1. Write test prompts (eval cases) in `evals/evals.json`
2. Run with-skill and baseline (without-skill) subagents in parallel
3. Grade assertions programmatically or via grader subagent
4. Generate benchmark report (pass rate, timing, tokens)
5. Human reviews outputs via HTML viewer

**Assertion grading:**
- Grader subagent reads `agents/grader.md` and evaluates each assertion
- Results saved to `grading.json` per run
- Assertions use `passed: bool`, `text: str`, `evidence: str` fields

**Viewer:**
- `eval-viewer/generate_review.py` generates HTML review interface
- Runs a local HTTP server (default port 3117)
- Supports `--static` for headless environments (Cowork)

**Not applicable to main codebase** — this eval system is for skill development, not for testing LaTeX output or writing quality.

## Test File Organization

**No test directory** (`tests/`, `test/`, `__tests__/` do not exist)

**Evaluation workspace structure** (for skill-creator only):
```
<skill-workspace>/
├── iteration-1/
│   ├── eval-0-descriptive-name/
│   │   ├── with_skill/outputs/
│   │   ├── without_skill/outputs/
│   │   ├── eval_metadata.json
│   │   ├── grading.json
│   │   └── timing.json
│   └── benchmark.json
└── iteration-2/
    └── ...
```

## Coverage

**No coverage enforcement** — no pytest-cov, no coverage targets.

The `package.json` contains only a placeholder test:
```json
"test": "echo \"No tests configured\" && exit 0"
```

## What Is Tested (vs. What Is Not)

**Tested:**
- LaTeX compilation (manual `make` invocation)
- Citation key resolution (`aw-cite` skill)
- Skill description triggering (skill-creator eval system)
- Manual quality gates in writing workflow

**Not tested:**
- JavaScript script logic (linted manually)
- Python script logic (linted manually)
- Academic writing quality (human-reviewed)
- Paper content correctness (author responsibility)

## Integration with Common Rules

The global rules (`common/testing.md`) specify:
- **Minimum 80% coverage** for traditional software projects
- **TDD workflow** for features and bug fixes

These do not apply here because:
1. This is a framework/toolkit, not a production application
2. The output artifact (academic papers) cannot be unit-tested programmatically
3. Quality is verified through compilation and human review

For skill-development work, the `skill-creator` skill provides its own testing methodology (eval-based, human-in-the-loop).

---

*Testing analysis: 2026-04-24*