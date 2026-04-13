---
description: |
  初始化 GSDAW 论文项目 (Initialize GSDAW paper project).
  Triggers aw-questioner to collect research brief, then runs the full
  initialization flow: Discuss → Research + Methodology → Discuss → Plan → Discuss.
  Supports --quick to skip Discuss checkpoints.

  注意：此命令作为编排入口，通过 sub-agent 分步执行各技能。
  不依赖 aw-orchestrator skill 的跨技能调用能力。
---

# /aw-init

触发 GSDAW 论文初始化流程（7 步编排）。

## 执行流程

```
/aw-init
    │
    ├── [1] aw-questioner        → .planning/research-brief.json
    ├── [2] aw-discuss-1        → 确认研究简报（quick mode 跳过）
    ├── [3] aw-research ─┐
    │                    ─┤ 并行 → .planning/literature.md
    └── [4] aw-methodology ─┘         + .planning/methodology.md
    ├── [5] aw-discuss-2        → 一致性检查（quick mode 跳过）
    ├── [6] aw-planner           → .planning/ROADMAP.md + .planning/STATE.md
    ├── [7] aw-discuss-3        → 最终确认（quick mode 跳过）
    │
    └── DONE → /aw-execute-phase 1 准备就绪
```

## Step 1: aw-questioner（必选）

使用 sub-agent 执行 `aw-questioner` skill：
- 检查 `.planning/research-brief.json` 是否存在（session reuse）
- 如存在：询问用户继续还是新建
- 如不存在：按 5 个类别深度提问，生成 Research Brief JSON

## Step 2: aw-discuss-1（quick mode 跳过）

- 读取 `research-brief.json`，展示格式化摘要
- 三个选项：确认 / 补充 / 重新开始
- 用户确认后进入下一步

## Step 3: aw-research + aw-methodology（并行）

- 同时启动两个 sub-agent
- 传递 `research-brief.json` 内容作为上下文
- 各自生成 `.planning/literature.md` 和 `.planning/methodology.md`

## Step 4: aw-discuss-2（quick mode 跳过）

- 读取 `literature.md` 和 `methodology.md`
- 做 4 点一致性检查
- 一致 → 进入下一步；冲突 → 询问用户处理方式

## Step 5: aw-planner

- 读取所有三个规划文档
- 生成 `.planning/ROADMAP.md`（按章节的粗粒度阶段计划）
- 生成 `.planning/STATE.md`（当前状态追踪）

## Step 6: aw-discuss-3（quick mode 跳过）

- 展示完整计划概览（7 阶段 + 时间线）
- 用户确认或调整

## Step 7: 完成

- 打印完成 banner
- 提示下一步：`/aw-execute-phase 1`

## Quick Mode（--quick flag）

跳过所有 3 个 Discuss checkpoint，直接：
1. Questioner（简化提问）→ 2. Research + Methodology 并行 → 3. Planner → 完成
