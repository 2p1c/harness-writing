---
name: aw-wave-planner
description: |
  GSDAW Wave Planner Agent — groups ROADMAP tasks into execution waves.
  Triggers when user runs /aw-wave-planner or approves a ROADMAP (after aw-planner).
  Reads ROADMAP.md, literature.md, methodology.md, and research-brief.json.
  Builds a dependency graph, performs topological sort, groups tasks into waves.
  Checks intra-wave file conflicts (tasks modifying same section file are sequential within a wave).
  Output: .planning/wave-plan.md.
---

# GSDAW Wave Planner Agent

## Purpose

Group ROADMAP tasks into ordered execution waves for parallel writing. Reads the ROADMAP to extract tasks and their dependencies, builds a dependency graph, performs topological sorting to assign wave numbers, detects intra-wave file conflicts, and outputs a Wave Plan markdown file.

## When to Trigger

- User runs `/aw-wave-planner` explicitly
- User approves ROADMAP output from `aw-planner`
- Orchestrator chain calls this skill before `aw-execute`

## Step 1: Read Input Files

Read all four input files in parallel:

```
Read: .planning/ROADMAP.md
Read: .planning/literature.md
Read: .planning/methodology.md
Read: .planning/research-brief.json
```

**ROADMAP.md structure to parse:**

```markdown
## Phase N: {Phase Name}

**Word target**: {X} words
**Figure**: Fig. N — {description}

### Tasks

1. [ ] Write task name — description or file target
2. [ ] Write task name — depends on task X.Y
3. [ ] Write task name — {file}.tex
```

Each task line may contain:
- Task ID implicitly from order (e.g., "1.1", "1.2", "1.3" from first phase)
- Task name/description
- File target (e.g., `introduction.tex`, `methodology.tex`)
- Dependency hints (e.g., "depends on 1.1", "after 2.2")

**research-brief.json** provides:
- `metadata.project_slug` — project name
- `word_count_breakdown` — per-phase word targets
- `figure_allocation` — per-phase figures

**literature.md** and **methodology.md** are read for context but not parsed structurally — they are passed through as reference inputs for downstream writing agents.

## Step 2: Extract Phase and Task List

For each Phase in ROADMAP.md, extract:

| Field | Source | Example |
|-------|--------|---------|
| Phase number | Heading (`## Phase N`) | 1, 2, 3 |
| Phase name | Heading (`## Phase N: {Name}`) | Introduction |
| Word target | `**Word target**:` line | 1500 words |
| Figure | `**Figure**:` line | Fig. 1 — System schematic |
| Task ID | Order in task list | 1.1, 1.2, 1.3 |
| Task description | After `[ ]` marker | Write research background |
| Target file | Parsed from description or explicit | introduction.tex |
| Dependencies | Parsed from "depends on", "after", "needs" | 1.1, 1.2 |

**Dependency extraction rules:**

1. **Explicit dependency** — Task description contains "depends on X.Y", "after X.Y", "needs X.Y" → parse task IDs
2. **Implicit ordering** — Phase-internal tasks that logically follow (e.g., "Main Contributions" after "Research Background") → infer from task context
3. **Same-file tasks** — Multiple tasks targeting the same `.tex` file → flag for intra-wave conflict check
4. **Phase boundary** — Tasks in Phase N may depend on Phase N-1 outputs (no reverse dependencies)

**Parsing logic (apply in order):**

```
For each task line in ROADMAP.md:
  1. Strip leading "1. [ ] ", "2. [ ] ", etc.
  2. Extract target filename if ".tex" appears
  3. Search for dependency keywords: "depends on", "after", "needs", "requires"
  4. Parse numeric task IDs from dependency clause (e.g., "1.1", "2.3")
  5. If no explicit dependency but same target file as prior task → sequential dependency
```

**Output: Task List**

```json
{
  "phases": [
    {
      "number": 1,
      "name": "Introduction",
      "word_target": 1500,
      "figure": "Fig. 1 — Laser Ultrasound Acquisition System",
      "tasks": [
        {
          "id": "1.1",
          "description": "Write research background",
          "target_file": "introduction.tex",
          "dependencies": [],
          "wave": null
        },
        {
          "id": "1.2",
          "description": "Write problem definition",
          "target_file": "introduction.tex",
          "dependencies": ["1.1"],
          "wave": null
        }
      ]
    }
  ]
}
```

## Step 3: Build Dependency Graph

Construct a directed acyclic graph (DAG):

- **Nodes:** Each task (task ID)
- **Edges:** Dependency relationship (task → depends_on_task)

```
Task A → Task B  means  B depends on A  (A must complete before B)
```

**Graph construction rules:**

1. **Phase-internal edges:** If task T2 depends on T1 within the same phase, add edge T1 → T2
2. **Phase boundary edges:** If task in Phase N depends on Phase N-1 task, add edge PhaseN-1_task → PhaseN_task
3. **No backward edges:** Phase N cannot depend on Phase N+1 (enforce DAG invariant)
4. **Same-file edges:** If two tasks write the same `.tex` file, the later task implicitly depends on the earlier one

**Validate DAG:**

- Run cycle detection (Kahn's algorithm during topological sort)
- If cycle detected → report error with the cycle tasks, ask user to resolve
- A cycle in the ROADMAP is a planning error that must be fixed before wave planning

## Step 4: Topological Sort → Assign Wave Numbers

Perform Kahn's topological sort to order all tasks respecting dependencies.

**Wave assignment algorithm:**

```
Initialize:
  - in_degree[TASK] = number of tasks this task depends on
  - wave[TASK] = null
  - remaining = all tasks

Wave 1:
  - Start with tasks where in_degree == 0
  - Assign wave = 1 to all of them
  - These tasks have no dependencies on other tasks

For each subsequent wave:
  - After all tasks in wave W complete, tasks whose dependencies
    are fully satisfied (all in wave <= W) become available
  - Assign available tasks to wave W+1
  - Repeat until all tasks assigned
```

**Key properties:**
- Tasks in wave N are independent of each other (no edges between them)
- Tasks in wave N may depend on tasks in wave N-1, N-2, etc.
- Wave count is the length of the longest dependency chain

**Intra-wave conflict check (within the same wave):**

```
For each wave:
  Group tasks by target_file
  If multiple tasks in same wave write the same file:
    - Mark them as "sequential within wave"
    - Note in conflict report
    - All other independent tasks in that wave remain parallel
```

**Result: Wave Assignment**

```json
{
  "waves": [
    {
      "wave": 1,
      "tasks": ["1.1", "1.2", "1.4"]
    },
    {
      "wave": 2,
      "tasks": ["1.3"]
    }
  ],
  "conflicts": [
    {
      "wave": 1,
      "file": "introduction.tex",
      "sequential_pair": ["1.1", "1.2"],
      "reason": "Both write introduction.tex"
    }
  ]
}
```

## Step 5: Write Wave Plan Output

Write the complete wave plan to `.planning/wave-plan.md`.

**Output format:**

```markdown
# Wave Plan — Phase {N}: {Phase Name}

**Project:** {project_slug}
**Generated:** {ISO timestamp}
**Total Waves:** {count}

---

## Wave 1 — Parallel ({count} tasks)

| Task ID | Description | Target File | Dependencies | Execution |
|---------|-------------|-------------|--------------|-----------|
| 1.1 | Write research background | introduction.tex | — | parallel |
| 1.2 | Write problem definition | introduction.tex | 1.1 | sequential* |
| 1.4 | Write paper structure overview | introduction.tex | — | parallel |

*Sequential within wave due to same-file conflict.

### Execution Order (Wave 1)

1. **Task 1.1** — Research Background (`introduction.tex`) — parallel with 1.4
2. **Task 1.2** — Problem Definition (`introduction.tex`) — after 1.1 (sequential)
3. **Task 1.4** — Paper Structure Overview (`introduction.tex`) — parallel with 1.1

---

## Wave 2 — Parallel ({count} tasks)

| Task ID | Description | Target File | Dependencies | Execution |
|---------|-------------|-------------|--------------|-----------|
| 1.3 | Write main contributions | introduction.tex | 1.1, 1.2 | parallel |

### Execution Order (Wave 2)

1. **Task 1.3** — Main Contributions (`introduction.tex`) — depends on 1.1, 1.2

---

## Conflict Notes

**Intra-wave file conflicts detected:** 1
- Wave 1: Tasks 1.1 and 1.2 both target `introduction.tex` → sequential execution within wave
- Resolution: Tasks 1.1 and 1.2 will execute sequentially on the same worktree (no worktree isolation for same-file tasks)

**No cross-wave conflicts.**

---

## Full Wave Map

| Wave | Task ID | Description | File | Dependencies | Execution Mode |
|------|---------|-------------|------|--------------|----------------|
| 1 | 1.1 | Research Background | introduction.tex | — | parallel |
| 1 | 1.2 | Problem Definition | introduction.tex | 1.1 | sequential* |
| 1 | 1.4 | Paper Structure | introduction.tex | — | parallel |
| 2 | 1.3 | Main Contributions | introduction.tex | 1.1, 1.2 | parallel |

*sequential within wave due to same-file conflict.

---

## Next Steps

After wave plan is approved:
- Run `/aw-execute` to start wave execution
- Wave 1 tasks will be dispatched to parallel sub-agents (worktree-isolated where no file conflict)
- Sequential tasks within a wave will run on the main worktree
```

## Step 6: Validation and Error Handling

**Validation checks:**

| Check | Pass Condition | Failure Action |
|-------|----------------|----------------|
| All tasks have unique IDs | No duplicate task IDs | Report duplicate IDs |
| All dependencies resolvable | Dep targets exist as task IDs | Report missing dependency IDs |
| No cycles in DAG | Topological sort succeeds | Report cycle, block execution |
| Phase dependencies only forward | Phase N does not depend on Phase N+1 | Report invalid backward dependency |
| Target files are valid .tex | Each task has a .tex target | Warn but allow prose-only tasks |

**If validation fails:**

```
Wave Planning Blocked — {Error Type}

Error: {specific error}
Affected tasks: [list]

Please fix the ROADMAP.md and re-run /aw-wave-planner.
```

**If validation passes:**

```
Wave Planning Complete.

Project: laser-ultrasound-denoising
Phase: 1 (Introduction)
Total Waves: 3
Total Tasks: 8
Parallel Tasks: 5
Sequential Tasks: 3 (due to same-file conflicts)

Wave 1: 3 tasks (parallel — no file conflicts)
Wave 2: 3 tasks (parallel — 1 same-file pair)
Wave 3: 2 tasks (sequential — depends on all prior)

Output: .planning/wave-plan.md

Next: Review wave plan and run /aw-execute to begin writing.
```

## File Outputs

| File | Location | Created By |
|------|----------|------------|
| Wave Plan | `.planning/wave-plan.md` | aw-wave-planner |

## Integration

```
aw-planner → aw-wave-planner → aw-execute → aw-merge
```

- **Receives from:** `aw-planner` (ROADMAP approval)
- **Receives from:** `.planning/ROADMAP.md`, `.planning/literature.md`, `.planning/methodology.md`, `.planning/research-brief.json`
- **Outputs to:** `.planning/wave-plan.md`
- **Sends to:** `aw-execute` (wave plan as input)

## Usage Examples

- `/aw-wave-planner` — Run after ROADMAP approval
- (Auto-triggered by orchestrator chain before aw-execute)
- `/aw-wave-planner --phase 3` — Plan only Phase 3 (useful for partial re-planning)
