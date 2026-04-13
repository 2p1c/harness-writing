# GSDAW — Get Shit Done Academic Writing

**Spec-driven academic paper writing framework.** Chain AI agents through a proven pipeline: question → research → methodology → plan → write → cite → figure → abstract → compile.

---

## Install (one command)

```bash
npm install -g @2p1c/harness-writing
```

Restart your Claude Code session after install. All skills auto-discover.

---

## Start

```
/aw-init
```

回答 5 类问题（研究问题、研究思路、方法论、约束条件、参考资料）→ 生成研究简报。

---

## Full Pipeline

```
/aw-init              → Research Brief
       ↓
/aw-execute          → Write all sections (wave-parallel)
       ↓
/aw-cite             → Verify citations
       ↓
/aw-table            → Build tables (provide CSV)
/aw-figure           → Generate figures (PlantUML + matplotlib)
       ↓
/aw-abstract         → Write 250-word abstract
       ↓
/aw-finalize         → make paper — verify & ready
```

---

## Phase Notes

### `/aw-init`
- Deep questioning across 5 categories before writing starts
- Auto-detects prior Research Brief — ask to reuse or start fresh
- `--quick` flag: skip Discuss checkpoints, go straight to research

### `/aw-execute`
- Reads ROADMAP → groups tasks into dependency-ordered waves
- Wave 1: tasks with no dependencies → parallel
- Wave 2+: tasks depending on prior waves → sequential per wave
- After each wave: quality gate checkpoint (continue / modify / pause)
- Manual compile: run `make paper` yourself when ready

### `/aw-cite`
- Scans all `\cite{}` keys against `references.bib`
- Auto-fixes missing entries from `literature.md`
- Run after any section edit that adds citations

### `/aw-table`
- Asks for CSV data per table (dataset, baseline, ablation, results)
- If no CSV yet → leaves `\placeholder{tab:name}` in section
- Auto-inserts `\input{tables/{name}}` at correct location

### `/aw-figure`
- Pipeline diagrams → PlantUML `.tex`
- Result plots → Python matplotlib `.pdf`
- If data unavailable → `\placeholder{fig:name}`
- Auto-inserts `\input{figures/fig-name}` at correct location

### `/aw-abstract`
- Reads all section drafts
- Synthesizes 250-word IMRAD abstract (Background→Objective→Method→Results→Conclusion)
- No citations in abstract
- Run after all sections complete

### `/aw-finalize`
- `make paper` — full compile
- Checks: undefined refs, unresolved citations, word count, abstract present
- Updates STATE.md to "ready for submission"

---

## Writing Order

Methodology → Results → Introduction → Discussion → Conclusion → Abstract

---

## All Commands

| Command | Phase | Description |
|---------|-------|-------------|
| `/aw-init` | Init | Start new paper — questioner → brief |
| `/aw-execute` | Phase 2 | Execute wave plan — write all sections |
| `/aw-cite` | Phase 3 | Verify citations resolve |
| `/aw-table` | Phase 3 | Build tables from CSV |
| `/aw-figure` | Phase 3 | Generate figures |
| `/aw-abstract` | Phase 3 | Write abstract |
| `/aw-finalize` | Phase 3 | Compile & verify |
| `/aw-review` | Any | Section quality review |
| `/aw-wave-planner` | Manual | Re-plan waves from ROADMAP |

---

## Workflow Quick Ref

```
/aw-init
    │
    ├── aw-questioner → research-brief.json
    ├── aw-discuss-1 → confirm brief
    ├── [research + methodology] → literature.md + methodology.md (parallel)
    ├── aw-discuss-2 → consistency check
    ├── aw-planner → ROADMAP.md + STATE.md
    └── aw-discuss-3 → approve plan

/aw-execute
    │
    ├── aw-wave-planner → wave-plan.md
    ├── Wave 1 (parallel) → aw-write-*
    ├── aw-review → quality gate
    ├── Wave 2 (parallel) → aw-write-*
    ├── ...
    └── phase merge → sections/{chapter}.tex

/aw-cite → /aw-table → /aw-figure → /aw-abstract → /aw-finalize
```

---

## Setup

**LaTeX (required):**
```bash
# macOS
brew install --cask mactex

# Linux
sudo apt install texlive-latex-base latexmk
```

**markitdown (PDF extraction, optional):**
```bash
conda install -c conda-forge markitdown
```

---

## Project Structure

```
manuscripts/
└── {paper-slug}/
    ├── project.yaml
    ├── references.bib
    ├── main.tex
    └── sections/
        ├── intro/
        │   ├── 1-1-background.tex
        │   └── ...
        ├── related-work/
        ├── methodology/
        ├── experiment/
        ├── results/
        ├── discussion/
        ├── conclusion/
        └── tables/
```

Paragraph files (`sections/{chapter}/{task-id}.tex`) are individual units — one per paragraph, merged by wave executor into chapter `.tex` files.

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `Undefined reference` in log | Run `/aw-cite` to find missing keys |
| Citation `[?]` | `make clean && make paper` |
| `elsarticle.cls not found` | `tlmgr install elsarticle` |
| `/aw-init` skill not found | Restart Claude Code after npm install |
| markitdown not found | `conda install -c conda-forge markitdown` |

---

## Skills Count

23 skills across 3 phases.

| Phase | Skills |
|-------|--------|
| Phase 1 — Orchestration | aw-questioner, aw-discuss-1/2/3, aw-research, aw-methodology, aw-planner, aw-orchestrator |
| Phase 2 — Execution | aw-wave-planner, aw-execute, aw-review, aw-write-intro, aw-write-related, aw-write-methodology, aw-write-experiment, aw-write-results, aw-write-discussion, aw-write-conclusion |
| Phase 3 — Polish | aw-cite, aw-table, aw-figure, aw-abstract, aw-finalize |

---

## License

MIT
