---
name: aw-discuss-1
description: |
  GSDAW Discuss Agent #1 — Research Brief confirmation checkpoint.
  Triggers automatically after aw-questioner completes. Reads .planning/research-brief.json
  and asks user to confirm the research brief before proceeding to Research Agent +
  Methodology Agent. Shows summary of all 5 categories and offers confirm/supplement/restart choices.
---

# GSDAW Discuss Agent #1 — Research Brief Confirmation

## Purpose

This is the **first checkpoint** in the GSDAW writing pipeline. It runs after `aw-questioner` completes and before the parallel `Research Agent + Methodology Agent` phase.

## Responsibilities

1. Read and parse `.planning/research-brief.json`
2. Present a human-readable summary of all 5 research brief categories
3. Offer the user three choices: **confirm / supplement / restart**
4. Handle each choice appropriately
5. After confirmation, update timestamps and tell user what comes next

## Workflow

```
aw-questioner
    │
    ▼
aw-discuss-1  ◄── You are here
    │
    ├── [confirm] ──► parallel: Research Agent + Methodology Agent
    │                    │
    │                    ▼
    │                 aw-discuss-2
    │
    ├── [supplement] ──► ask which category, then follow-up questions
    │                    then re-present summary
    │
    └── [restart] ──────► clear .planning/research-brief.json
                          tell user to run /aw-init again
```

## Step-by-Step Instructions

### Step 1 — Read the Research Brief

Read `.planning/research-brief.json` from the current working directory.

Parse it into the following categories:
- **Research Problem** (`problem`, `novelty`, `existingGaps`)
- **Research Approach** (`strategy`, `assumptions`, `comparison`)
- **Methodology** (`dataAndExperiments`, `metrics`, `baselines`, `timeline`)
- **Constraints** (`venue`, `deadline`, `limit`)
- **Available Materials** (`drafts`, `data`, `figures`, `code`)

### Step 2 — Present the Summary

Display a formatted summary block. Use the exact structure below:

```markdown
## 研究简报确认

我已经了解了以下内容：

### 研究问题
**核心问题:** [problem — one sentence]
**创新点:** [novelty — one sentence]
**现有缺陷:** [existingGaps — one sentence]

### 研究思路
**技术路线:** [strategy — one sentence]
**核心假设:** [assumptions — one sentence]
**与替代方案比较:** [comparison — one sentence]

### 方法论
**数据/实验:** [data and experiments description]
**评估指标:** [metrics]
**Baseline:** [baselines]
**实验预估:** [timeline]

### 约束条件
**目标期刊:** [venue]
**截稿日期:** [deadline or "无"]
**字数/页数限制:** [limit or "无"]

### 可用材料
**drafts:** [yes/no + short description if any]
**数据:** [yes/no + short description if any]
**图表:** [yes/no + short description if any]
**代码:** [yes/no + short description if any]

---

是这样的吗？有需要补充或调整的吗？
```

### Step 3 — Ask for User Confirmation

Present an `AskUserQuestion` with these exact values:

```
header: "确认"
question: "研究简报确认"
options:
  1. "确认"         — "研究简报无误，继续下一步"
  2. "补充"         — "需要补充/调整某些部分"
  3. "重新开始"     — "回到 Questioner 重新提问"
```

### Step 4 — Handle Each Choice

#### Choice 1: Confirm

1. Update `lastUpdated` in `.planning/research-brief.json` with current ISO timestamp
2. Print the next-steps message:
   ```
   研究简报已确认。

   下一步并行执行：
   • Research Agent — 文献调研（读取您的 Zotero 库 + 网络搜索）
   • Methodology Agent — 方法论设计

   两个 Agent 完成后，将进入 Discuss #2 进行一致性检查。
   ```

#### Choice 2: Supplement

1. Ask the user **which category** needs updating:
   ```
   请问需要补充或调整哪个部分？
   1. 研究问题
   2. 研究思路
   3. 方法论
   4. 约束条件
   5. 可用材料
   ```
2. Once the user selects a category, ask **targeted follow-up questions** for that category.
3. After gathering the update, **merge it back** into `research-brief.json`.
4. Re-present the full summary (Step 2) and ask again (Step 3).
5. Repeat until user selects **Confirm** or **Restart**.

#### Choice 3: Restart

1. **Delete** `.planning/research-brief.json`
2. Print:
   ```
   已清除研究简报。请重新运行 /aw-init 开始。
   ```
3. **Stop** — do not proceed further.

## Quick Mode (`--quick`)

If the orchestrator is running in `--quick` mode, this skill is **skipped entirely**. The orchestrator proceeds directly from `aw-questioner` to the parallel `Research Agent + Methodology Agent` phase.

When running as a standalone skill (not via orchestrator), check for a `--quick` flag in the invocation context. If present, skip all steps and simply print:

```
[quick mode] 跳过 Discuss #1，直接进入 Research Agent + Methodology Agent。
```

## File Format Reference

### `.planning/research-brief.json` Expected Shape

```json
{
  "lastUpdated": "2026-04-12T00:00:00.000Z",
  "problem": "...",
  "novelty": "...",
  "existingGaps": "...",
  "strategy": "...",
  "assumptions": "...",
  "comparison": "...",
  "dataAndExperiments": "...",
  "metrics": "...",
  "baselines": "...",
  "timeline": "...",
  "venue": "...",
  "deadline": "...",
  "limit": "...",
  "drafts": "...",
  "data": "...",
  "figures": "...",
  "code": "..."
}
```

Any field may be an empty string `""` if not yet provided.

## Edge Cases

- If `.planning/research-brief.json` does not exist, abort with:
  ```
  错误: 未找到 .planning/research-brief.json。请先运行 /aw-init。
  ```

- If the JSON is malformed, abort with:
  ```
  错误: research-brief.json 格式不正确。请检查文件内容。
  ```

- If the user selects a category for supplement but provides no meaningful update, re-ask the follow-up question once more before allowing them to confirm or restart.

## Exit States

| Outcome | Next Skill |
|---------|------------|
| Confirm | `aw-research` + `aw-methodology` (parallel) |
| Supplement | `aw-discuss-1` (re-entry after update) |
| Restart | End — user runs `/aw-init` again |
| Quick mode skip | `aw-research` + `aw-methodology` (parallel) |
