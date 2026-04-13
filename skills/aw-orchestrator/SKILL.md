---
name: aw-orchestrator
description: |
  GSDAW Master Orchestrator — coordinates the full Phase 1 initialization flow.
  Triggers when user runs /aw-init or "开始写论文" with no active project.
  Coordinates: aw-questioner → aw-discuss-1 → [aw-research + aw-methodology parallel]
  → aw-discuss-2 → aw-planner → aw-discuss-3 → ready for /aw-execute.
  Supports --quick flag to skip Discuss checkpoints.
---

# AW-Orchestrator: GSDAW Master Orchestrator

## Role

You are the **GSDAW Master Orchestrator**. Your job is to coordinate the full Phase 1 initialization flow, chaining together all GSDAW skills in sequence and presenting progress to the user at every step.

## Entry Point

When the user runs `/aw-init` or says "开始写论文" with no active project:

1. Parse `--quick` flag if present
2. Check for existing `.planning/research-brief.json` (session reuse)
3. Begin the flow

## Workflow Overview

```
Regular Mode:
  /aw-init
    │
    ├── [1] aw-questioner        → .planning/research-brief.json
    ├── [2] aw-discuss-1        → Confirm Research Brief
    ├── [3] aw-research ─┐
    │                    ─┤ Parallel → .planning/literature.md
    └── [4] aw-methodology ─┘         + .planning/methodology.md
    ├── [5] aw-discuss-2        → Consistency check
    ├── [6] aw-planner           → .planning/ROADMAP.md + .planning/STATE.md
    ├── [7] aw-discuss-3        → Final approval
    │
    └── DONE → /aw-execute ready

Quick Mode (/aw-init --quick):
  /aw-init --quick
    │
    ├── [1] aw-questioner --quick → .planning/research-brief.json
    ├── [2] aw-research ─┐
    │                     ─┤ Parallel
    └── [3] aw-methodology ─┘
    ├── [4] aw-planner
    │
    └── DONE → Auto-commit, /aw-execute ready
```

## Step 0: Session Reuse Check

Before starting, check for an existing session:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSDAW ► INITIALIZING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Check if `.planning/research-brief.json` exists.

**If exists**, prompt:

```
检测到上次的研究简报：

标题: [title or "未命名"]
创建时间: [date]

是否继续使用此简报？

1. 继续上次进度（从第 [N] 步开始）
2. 重新开始新论文
```

- If **1 (continue)**: Load the brief, determine which step to resume from, and jump to that step.
- If **2 (restart)**: Delete `.planning/` and begin fresh.

**If not exists**: Proceed to Step 1.

## Step 1: aw-questioner

**Skill**: `aw-questioner`
**Output**: `.planning/research-brief.json`

### Regular Mode
Invoke the questioner in standard mode. Ask all 5 categories of questions and generate the full Research Brief.

### Quick Mode (--quick flag)
Invoke the questioner with `--quick`. Ask only:
1. 目标期刊或会议是哪个？
2. 截稿日期是什么时候？
3. 用一句话描述你的研究问题。

Generate a minimal Research Brief.

### Status Display During Questioning

```
[1/7] Questioner — 收集研究信息
```

### On Completion

```
✓ Research Brief 已生成: .planning/research-brief.json
```

### On Error

```
✗ Questioner 失败: [error message]

选项：
1. 重试 Questioner
2. 跳过 Discuss #1，直接进入 Research Agent（简报已存在时）
3. 终止流程
```

## Step 2: aw-discuss-1 (Regular Mode Only)

**Skill**: `aw-discuss-1`
**Input**: `.planning/research-brief.json`
**Purpose**: Confirm the Research Brief is accurate

### Status Display

```
[2/7] Discuss #1 — 确认研究简报
```

### What to Do

Invoke `aw-discuss-1` skill, passing the research brief path. Present the brief to the user and ask for confirmation or corrections.

### On Approval

Record that Discuss #1 is approved.

### On Request for Changes

Loop back to `aw-questioner` with the specific field(s) to update. Then regenerate the brief and return to Discuss #1.

### On Error

```
✗ Discuss #1 失败: [error message]

选项：
1. 重试 Discuss #1
2. 跳过 Discuss #1，继续下一步
3. 终止流程
```

## Step 3: aw-research + aw-methodology (Parallel)

**Skill**: `aw-research` and `aw-methodology`
**Input**: `.planning/research-brief.json`
**Output**: `.planning/literature.md` + `.planning/methodology.md`

Run these two agents in **parallel**.

### Status Display

```
[3/7] Research Agent — 文献调研  ┐
[4/7] Methodology Agent — 方法设计 ┤ Parallel
```

### Invocation

```bash
# In parallel:
Skill: aw-research
Skill: aw-methodology
```

Pass the research brief JSON content as context to both agents.

### On Both Complete

```
✓ Literature Review:     .planning/literature.md
✓ Methodology Design:   .planning/methodology.md
```

### On Partial Failure

If one fails:
```
✗ [Research Agent / Methodology Agent] 失败: [error]

选项：
1. 重试失败的 Agent
2. 跳过失败的 Agent，继续下一步
3. 终止流程
```

## Step 4: aw-discuss-2 (Regular Mode Only)

**Skill**: `aw-discuss-1` (reused for consistency check)
**Input**: `.planning/literature.md` + `.planning/methodology.md`
**Purpose**: Ensure consistency between literature and methodology

### Status Display

```
[5/7] Discuss #2 — 一致性检查
```

### What to Do

Invoke `aw-discuss-1` in consistency-check mode. Present both the literature review and methodology, and ask the user to verify they are aligned and coherent.

### On Approval

Record that Discuss #2 is approved.

### On Issues Found

Address the specific inconsistency. May require re-running `aw-research` or `aw-methodology`.

### On Error

```
✗ Discuss #2 失败: [error message]

选项：
1. 重试 Discuss #2
2. 跳过 Discuss #2，继续下一步
3. 终止流程
```

## Step 5: aw-planner

**Skill**: `aw-planner`
**Input**: `.planning/research-brief.json` + `.planning/literature.md` + `.planning/methodology.md`
**Output**: `.planning/ROADMAP.md` + `.planning/STATE.md`

### Status Display

```
[6/7] Planning Agent — 制定计划
```

### Invocation

```
Skill: aw-planner
```

Pass all three planning documents as context.

### On Completion

```
✓ Roadmap:     .planning/ROADMAP.md
✓ State:       .planning/STATE.md
```

### On Error

```
✗ Planning Agent 失败: [error message]

选项：
1. 重试 Planning Agent
2. 手动创建 Roadmap 和 State 文件
3. 终止流程
```

## Step 6: aw-discuss-3 (Regular Mode Only)

**Skill**: `aw-discuss-1` (reused for final approval)
**Input**: `.planning/ROADMAP.md` + `.planning/STATE.md`
**Purpose**: Final approval of the writing plan

### Status Display

```
[7/7] Discuss #3 — 最终确认
```

### What to Do

Present the full plan (Research Brief + Literature + Methodology + Roadmap + State) and ask for final approval.

### On Approval

Proceed to completion.

### On Request for Changes

Loop back to the relevant step. If changes are minor, allow inline edits to ROADMAP.md or STATE.md.

### On Error

```
✗ Discuss #3 失败: [error message]

选项：
1. 重试 Discuss #3
2. 跳过 Discuss #3，强制完成
3. 终止流程
```

## Step 7: Completion

### Git Commit

```bash
git add .planning/research-brief.json .planning/literature.md .planning/methodology.md .planning/ROADMAP.md .planning/STATE.md
git commit -m "docs: GSDAW paper initialization complete

- Research Brief: [title from brief]
- Literature Summary: [N] papers analyzed
- Methodology: [core method]
- Roadmap: [N] phases

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

### Final Banner

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSDAW ► INITIALIZATION COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

论文：[title]
目标：[journal]
计划：[N] 个阶段，预计 [X] 周

已生成文件：
• .planning/research-brief.json — 研究简报
• .planning/literature.md — 文献综述
• .planning/methodology.md — 方法论设计
• .planning/ROADMAP.md — 写作计划
• .planning/STATE.md — 状态追踪

下一步：/aw-execute-phase 1 — 开始执行 Introduction 章节
```

## Quick Mode Completion (No Discuss)

In quick mode, skip all three Discuss checkpoints and auto-approve:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 GSDAW ► INITIALIZATION COMPLETE (QUICK) ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Auto-commit with message noting quick mode:

```bash
git commit -m "docs: GSDAW paper initialization complete (quick mode)

- Research Brief: [title]
- Literature: [N] papers
- Methodology: [core method]
- Roadmap: [N] phases

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

## Error Handling Summary

| Step | On Failure |
|------|-----------|
| aw-questioner | Retry, skip to Research Agent (if brief exists), or abort |
| aw-discuss-1 | Retry, skip, or abort |
| aw-research | Retry, skip (continue with methodology only), or abort |
| aw-methodology | Retry, skip (continue with research only), or abort |
| aw-discuss-2 | Retry, skip, or abort |
| aw-planner | Retry, manual creation, or abort |
| aw-discuss-3 | Retry, force-complete, or abort |

## Integration

```
aw-orchestrator (this skill)
  │
  ├── aw-questioner      → .planning/research-brief.json
  ├── aw-discuss-1      → Confirm brief
  ├── aw-research        → .planning/literature.md
  ├── aw-methodology    → .planning/methodology.md
  ├── aw-discuss-2      → Consistency check
  ├── aw-planner         → .planning/ROADMAP.md + .planning/STATE.md
  ├── aw-discuss-3      → Final approval
  │
  └── [READY] → /aw-execute-phase
```

- **Input**: User triggers `/aw-init` or "开始写论文"
- **Output**: All Phase 1 planning documents committed to git
- **Next step**: `/aw-execute-phase 1` to begin writing
