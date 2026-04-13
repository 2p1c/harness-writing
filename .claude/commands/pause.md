---
description: |
  保存写作进度，生成会话总结，更新 STATE.md，提交 git checkpoint。
  用于休息前保存状态，下次通过 /resume 恢复。
---

# /aw-pause

触发会话保存流程（5 步）。

## 执行流程

```
/aw-pause
    │
    ├── [1] 检测当前状态 → sections/*.tex, STATE.md, wave-plan.md
    ├── [2] 评估进度 → phase, wave, 完成度
    ├── [3] 生成会话总结 → .planning/sessions/{timestamp}-session.md
    ├── [4] 更新 STATE.md → phase/wave/completion
    ├── [5] Git checkpoint → git commit
    │
    └── DONE → 打印进度报告 + next action
```

## Step 1: 检测当前状态

读取以下文件判断当前进度：

```
sections/**/*.tex         → 已写的段落文件列表
STATE.md                  → 当前 phase、wave、status
wave-plan.md              → wave 执行计划
ROADMAP.md                → 全部任务和依赖
```

## Step 2: 评估进度

对 `sections/` 下每个章节目录：
- 计数 `.tex` 段落文件数量
- 提取 `\paragraph{}` 标题
- 计算估算字数（每段落约 100 词）

输出：
- 当前 phase 和 wave
- 本次完成的 tasks
- 剩余 tasks
- 总完成百分比

## Step 3: 生成会话总结

写入 `.planning/sessions/{timestamp}-session.md`：

```markdown
# Writing Session — {timestamp}

**Project**: {project-slug}
**Phase**: {N} — {phase-name}
**Wave**: {M} of {total-waves}
**Started**: {session-start-time}
**Ended**: {now}

---

## Accomplished This Session
...

## Decisions Made
...

## Blockers Encountered
...

## Pending Tasks
...

## Current Position
...

## Next Action
/aw-resume
→ Continue with Wave {M+1}: {task-list}
```

## Step 4: 更新 STATE.md

更新 `Current State` JSON：
```json
{
  "project": "{slug}",
  "phase": {N},
  "phase_name": "{phase-name}",
  "wave": {M},
  "status": "in_progress",
  "current_action": "/aw-resume",
  "last_session": "{timestamp}",
  "completion_pct": {X}
}
```

## Step 5: Git Checkpoint

```bash
git add -A
git commit -m "wip({slug}): Phase {N} Wave {M} — {session-summary}"
```

## 输出格式

```
═══════════════════════════════════════
  SESSION SAVED — {project-slug}
═══════════════════════════════════════

Phase:    {N} — {phase-name}
Wave:     {M}/{wave-count}
Progress: {completion}%
Git:      {commit-hash}

Next: /aw-resume → Wave {M+1}
═══════════════════════════════════════
```
