---
name: aw-discuss-3
description: |
  GSDAW Discuss Agent #3 — Final plan approval checkpoint.
  Triggers automatically after aw-planner generates ROADMAP.md.
  Presents plan overview and asks user to approve before execution.
  If approved, commits ROADMAP.md + STATE.md to git and signals ready for /aw-execute.
---

# GSDAW Discuss Agent #3 — Final Plan Approval

## Purpose

This is the **third and final checkpoint** in the GSDAW planning pipeline. It runs after `aw-planner` generates `ROADMAP.md` and before the execution phase begins.

## Responsibilities

1. Read and parse `.planning/ROADMAP.md`
2. Present a human-readable plan overview with phase table
3. Offer the user three choices: **confirm / adjust / view details**
4. Handle each choice appropriately
5. On confirmation: commit `ROADMAP.md` + `STATE.md` to git and signal readiness for execution

## Workflow

```
aw-planner
    │
    ▼
aw-discuss-3  ◄── You are here
    │
    ├── [confirm] ──► git commit → /aw-execute-phase or /aw-execute
    │
    ├── [adjust] ───► collect feedback → re-run aw-planner → re-present
    │
    └── [view details] ──► cat .planning/ROADMAP.md → re-ask
```

## Step-by-Step Instructions

### Step 1 — Read ROADMAP.md

Read `.planning/ROADMAP.md` from the current working directory.

Parse it to extract:
- Paper title
- Target journal/venue
- Estimated total duration
- List of phases with their content, duration, and dependencies

### Step 2 — Present Plan Overview

Display the plan summary using this exact structure:

```markdown
## 写作计划确认

**论文标题:** [title]
**目标期刊:** [journal]
**预计总时长:** [X weeks]

### 阶段概览

| Phase | 内容 | 预计时长 | 依赖 |
|-------|------|---------|------|
| Phase 1 | Introduction | X days | - |
| Phase 2 | Related Work | X days | Phase 1 |
| Phase 3 | Methodology | X days | Phase 2 |
| Phase 4 | Experiment | X days | Phase 3 |
| Phase 5 | Discussion | X days | Phase 4 |
| Phase 6 | Conclusion | X days | Phase 5 |

### 关键里程碑

- **Week 1:** 完成 Introduction + Related Work
- **Week 2:** 完成 Methodology
- **Week 3:** 完成 Experiment
- **Week 4:** 完成 Discussion + Conclusion
- **Week 5:** 最终润色 + PDF 生成

---

这个计划你觉得合理吗？有需要调整的吗？
```

### Step 3 — Ask for User Confirmation

Present an `AskUserQuestion` with these exact values:

```
header: "计划确认"
question: "写作计划确认"
options:
  1. "确认"         — "计划已确认，提交并准备执行"
  2. "调整"         — "需要调整某些阶段"
  3. "查看详情"     — "显示完整 ROADMAP.md"
```

### Step 4 — Handle Each Choice

#### Choice 1: Confirm

1. Commit the files:
   ```bash
   git add .planning/ROADMAP.md .planning/STATE.md
   git commit -m "docs: add paper roadmap and initial state"
   ```

2. Print the completion message:
   ```
   计划已确认并提交。

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    GSDAW ► PLANNING COMPLETE ✓
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   论文写作计划已就绪：
   • ROADMAP.md — 6 阶段写作计划
   • STATE.md — 初始状态

   下一步：
   /aw-execute-phase 1 — 开始执行 Phase 1 (Introduction)

   或者：
   /aw-execute — 开始执行（从 Phase 1 依次进行）
   ```

#### Choice 2: Adjust

1. Ask the user which phases need adjustment:
   ```
   请问哪个阶段需要调整？
   1. Phase 1 (Introduction)
   2. Phase 2 (Related Work)
   3. Phase 3 (Methodology)
   4. Phase 4 (Experiment)
   5. Phase 5 (Discussion)
   6. Phase 6 (Conclusion)
   7. 其他（总体时间、里程碑等）
   ```

2. Gather the user's feedback on the selected phases.
3. Re-run `aw-planner` with the collected feedback:
   ```
   根据您的反馈，重新生成写作计划...
   ```
4. Re-present the revised plan (Step 2) and ask again (Step 3).
5. Loop until user selects **Confirm** or **View Details**.

#### Choice 3: View Details

1. Read and display the full contents of `.planning/ROADMAP.md` using `cat`.
2. Then re-ask the confirmation question (Step 3).

## Quick Mode (`--quick`)

If the orchestrator is running in `--quick` mode, this skill is **skipped entirely**. The orchestrator auto-commits `ROADMAP.md` + `STATE.md` and proceeds directly to the execution phase.

When running as a standalone skill (not via orchestrator), check for a `--quick` flag in the invocation context. If present:

1. Commit the files:
   ```bash
   git add .planning/ROADMAP.md .planning/STATE.md
   git commit -m "docs: add paper roadmap and initial state"
   ```

2. Print:
   ```
   [quick mode] 跳过 Discuss #3，直接进入执行阶段。
   ```

## Edge Cases

- If `.planning/ROADMAP.md` does not exist, abort with:
  ```
  错误: 未找到 .planning/ROADMAP.md。请先运行 /aw-plan 或 /aw-init。
  ```

- If `.planning/STATE.md` does not exist, proceed with just `ROADMAP.md`:
  ```
  注意: 未找到 STATE.md，仅提交 ROADMAP.md。
  git add .planning/ROADMAP.md
  git commit -m "docs: add paper roadmap"
  ```

- If the JSON/YAML structure of ROADMAP.md is malformed, abort with:
  ```
  错误: ROADMAP.md 格式不正确。请检查文件内容。
  ```

- If the git commit fails (e.g., nothing to commit), skip the commit step and proceed to the next-steps message.

## Exit States

| Outcome | Next Skill |
|---------|------------|
| Confirm | `/aw-execute-phase` or `/aw-execute` |
| Adjust | `aw-planner` (re-entry with feedback) |
| View Details | `aw-discuss-3` (re-entry after display) |
| Quick mode skip | `/aw-execute-phase` or `/aw-execute` |
