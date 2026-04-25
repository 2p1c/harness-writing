# Coding Conventions

**Analysis Date:** 2026-04-24

## Language Mix

This repository is a **skill framework** for academic paper writing, not a traditional software project. It contains:

- **JavaScript** (Node.js) — build scripts and automation
- **Python** — Zotero integration and skill evaluation scripts
- **Markdown/SKILL.md** — skill definitions with YAML frontmatter
- **LaTeX** — paper template and manuscript content

No TypeScript, no React, no heavy framework dependencies.

## Naming Patterns

**Files:**
- Command routes: `kebab-case.md` under `.claude/commands/`
  - Example: `.claude/commands/newpaper.md`, `.claude/commands/skill-create.md`
- Node scripts: `kebab-case.js` under `scripts/`
  - Example: `scripts/install-skill-links.js`
- Python utilities: `snake_case.py` under `scripts/`
  - Example: `scripts/build_zotero_context.py`
- Skill entrypoints: always `SKILL.md` (uppercase, no variant)
  - Example: `skills/aw-execute/SKILL.md`, `skills/superpowers/test-driven-development/SKILL.md`

**Functions:**
- JavaScript: `camelCase`
  - Example: `ensureDir`, `createSymlink` in `scripts/install-skill-links.js`
- Python: `snake_case`
  - Example: `_resolve_paths`, `_extract_pdf_text`, `_build_context_markdown`
- Private helpers in Python prefixed with `_`
  - Example: `_discover_zotero_data_dir`, `_stderr`

**Variables:**
- JavaScript constants: `UPPER_SNAKE_CASE` for config/paths
  - Example: `SKILLS_DIR`, `HOME_AGENTS_SKILLS_DIR`
- JavaScript locals: `camelCase`
  - Example: `skillPath`, `existing`, `commands`
- Python locals/params: `snake_case`
  - Example: `collection_ids`, `linked_attachment_base`, `query_terms`

**Types (Python):**
- Dataclasses for data models: `PascalCase`
  - Example: `CollectionNode` in `scripts/build_zotero_context.py`
- Type annotations use `typing` module generics (`Dict`, `List`, `Optional`, `Tuple`)
- Always `from __future__ import annotations` for forward references

## Code Style

**JavaScript:**
- CommonJS (require/module.exports), no ESM
- Semicolons at line ends
- Concise inline comments for non-obvious logic
- Example: `scripts/install-skill-links.js`

**Python:**
- PEP-like spacing, explicit type annotations on all function signatures
- Dataclasses for structured data (`@dataclasses.dataclass`)
- `if __name__ == "__main__": raise SystemExit(main())` guard pattern
- Example: `scripts/build_zotero_context.py`

**Markdown/SKILL files:**
- YAML frontmatter with `name` and `description` (required)
- `# Heading` for section titles
- Numbered workflow sections (`## Step 1`, `## Step 2`)
- Code blocks with language hints (```latex, ```bash, ```python, ```typescript)
- Tables for structured reference data
- Error handling tables: `| Situation | Action |`

**LaTeX:**
- Elsevier class: `\documentclass[review]{elsarticle}`
- Bibliography: `\bibliographystyle{elsarticle-num}`
- Citations: `\cite{key}`, `\citealp{key1,key2}`, `\citep{key}`
- Paragraph structure: `\paragraph{Title}\label{sec:section:label}`
- Tables: booktabs (`\toprule`, `\midrule`, `\bottomrule`)

## Formatting and Linting

**No enforced formatter/linter** for the repository itself:
- No `.eslintrc*`, `eslint.config.*`, `.prettierrc*`, `biome.json`
- No `.pylintrc`, `pyproject.toml` with Ruff/Black config
- `package.json` has only `postinstall` and placeholder `test` scripts

**Why:** This is a skill/documentation framework, not a deployed application. Code changes are reviewed manually through PRs rather than automated quality gates.

**Pre-commit responsibility:** Contributors should apply reasonable formatting (semicolons in JS, PEP 8 in Python) but no automated enforcement exists.

## Import Organization

**JavaScript:**
```javascript
const fs = require('fs');       // Node built-ins first
const path = require('path');
const os = require('os');
// local imports after
```

**Python:**
```python
from __future__ import annotations  // first

import argparse                   // stdlib
import dataclasses
import datetime as dt
import json
import re
import shutil
import sqlite3
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Set, Tuple

# third-party deferred to use-site
from pypdf import PdfReader  # type: ignore
```

## Error Handling

**JavaScript:**
- Fail fast with `process.exit(1)` for invalid preconditions
- Actionable error messages with context
- Example: `scripts/install-skill-links.js` exits if `skills/` not found

**Python:**
- Layered exception handling with specific types (`FileNotFoundError`, `ValueError`, `sqlite3.Error`)
- Numeric return codes in `main()`: `0` success, `1` general error, `2` usage/semantic error
- Helper output functions: `_stdout()` for normal, `_stderr()` for warnings/errors

**Skill workflows:**
- Explicit error tables in SKILL.md files
- Example from `skills/aw-execute/SKILL.md`:
  | Situation | Action |
  |-----------|--------|
  | ROADMAP.md missing | Abort with error, prompt to run `/aw-orchestrator` first |
  | Subagent fails | Retry, skip (leave placeholder), or abort |

## Logging

**No centralized logging library.** Three patterns:

1. **JavaScript console**: `console.log` for status, `console.error` for failures
   - Used in build scripts
2. **Python helpers**: `_stdout()`, `_stderr()` for output separation
   - Used in utility scripts
3. **Markdown status reports**: Quality gate reports, section completion summaries
   - Used in skill execution (e.g., `aw-review`, `aw-execute`)

## Comments

**When to comment:**
- Intent-level above workflow blocks
- Non-obvious branches (e.g., symlink-skip logic)
- Section headers in long scripts to delineate domains

**JSDoc:** Used for script-level documentation in JavaScript
```javascript
/**
 * postinstall script:
 * 1) Creates symlinks from skills/ to project .claude/skills/
 */
```

**Not used:**
- TSDoc (no TypeScript in codebase)
- Inline docstrings for every function (Python helpers are self-documenting)

## Function Design

**Size:** Small, composable helpers + compact entrypoints
- `main()` delegates to helpers; logic lives in focused functions
- Examples: `_resolve_paths()`, `_connect_readonly()`, `_extract_pdf_text()`

**Parameters:** Explicit, structured
- Pass context values (paths, limits, flags) rather than implicit globals
- Example: `_resolve_attachment_path(attachment_key, raw_path, storage_dir, linked_attachment_base)`

**Return values:**
- JavaScript: void for side-effects, boolean for control flow
- Python: typed tuples/dicts/lists for deterministic downstream processing
  - Example: `_resolve_paths(...) -> Tuple[Path, Path]`

## Module Design

**Exports:**
- Scripts are executable CLIs, not reusable libraries
- Python modules use `if __name__ == "__main__": raise SystemExit(main())` guard

**Barrel files:** Not used
- Content organization is directory-driven: `skills/<skill>/SKILL.md`
- No index files aggregating exports

## LaTeX Validation Conventions

**CLI-driven verification** (not test frameworks):
- `make quick` — single-pass LaTeX compile (no bibliography)
- `make paper` — full compile with bibtex (4-pass)
- `make check-refs` — grep citation patterns in .tex files

**Quality gates in skill workflows:**
- Phase/wave execution uses checkpoint decisions: `继续` (continue) / `修改` (modify) / `暂停` (pause)
- Citation verification via `aw-cite` skill
- Word count validation against ROADMAP targets

## Skill File Structure

Skills follow a consistent anatomy:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter: name, description (required)
│   ├── Markdown body: purpose, workflow, integration
│   └── Error handling, examples
├── scripts/ (optional)
├── references/ (optional)
├── agents/ (optional)
└── assets/ (optional)
```

**SKILL.md structure:**
1. YAML frontmatter with `name` and `description`
2. `# Skill Name` heading
3. `## Purpose` or `## Role` section
4. `## When to Trigger` section
5. Numbered workflow sections
6. Integration/exit points
7. Error handling tables

---

*Convention analysis: 2026-04-24*