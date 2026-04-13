---
description: |
  初始化 GSDAW 论文项目 (Initialize GSDAW paper project).
  自动检测是否有未完成的写作会话 → 询问 resume 或新建。
  触发 aw-questioner 收集研究简报，然后运行完整初始化流程。
  支持 --quick 跳过 Discuss checkpoint。

  注意：此命令作为编排入口，通过 sub-agent 分步执行各技能。
  不依赖 aw-orchestrator skill 的跨技能调用能力。
---

# /aw-init

触发 GSDAW 论文初始化流程（8 步编排）。

## 执行流程

```
/aw-init
    │
    ├── [0] 检测已有会话 → 有？询问 resume/new
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

## Step 0: 检测已有会话

**检测文件（按顺序）：**

```
if .planning/sessions/latest-session.md exists:
    → 检测到最近会话

elif .planning/STATE.md exists AND research-brief.json exists:
    → 检测到未完成的初始化状态

else:
    → 无已有会话，直接进入 Step 1
```

**如检测到已有会话 → 询问：**

```
═══════════════════════════════════════
  检测到未完成的写作会话
═══════════════════════════════════════

Project:  {project-slug}
Phase:    {N} — {phase-name}
Progress: {completion}%
Last:     {last-session-timestamp}

───────────────────────────────────────
  Options:

  1. 继续写作 — /aw-resume
     恢复上次会话，从中断处继续

  2. 重新开始 — /aw-init
     丢弃当前进度，全新初始化
     （原有文件将保留在 manuscripts/ 和 sections/）

  3. 仅查看状态 — /aw-resume --view
     查看会话总结，不执行写作

═══════════════════════════════════════
```

**选择处理：**
- 选 1：`/aw-resume` → 退出 init，执行 resume 流程
- 选 2：清除 `research-brief.json`（如存在），继续 Step 1
- 选 3：`/aw-resume --view` → 退出 init

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

> 注意：--quick 模式下如检测到已有会话，仍会询问 resume/new。
