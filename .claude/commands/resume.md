---
description: |
  恢复写作会话 — 加载上次会话总结，验证上下文完整性，确认下一步行动。
  从 /aw-pause 保存的 checkpoint 恢复。
---

# /aw-resume

触发会话恢复流程（6 步）。

## 执行流程

```
/aw-resume
    │
    ├── [1] 查找上次会话总结 → .planning/sessions/
    ├── [2] 加载状态 → STATE.md, wave-plan.md, ROADMAP.md
    ├── [3] 验证上下文健康 → 6 个关键文件检查
    ├── [4] 显示 Resume Briefing → 汇总报告
    ├── [5] 用户选择行动 → 继续/查看/跳过/终止
    │
    └── → 执行所选行动
```

## Step 1: 查找会话总结

```bash
ls -t .planning/sessions/ | head -1
```

无会话文件 → 提示：
```
No session found. Start fresh with /aw-init or /aw-execute.
```

## Step 2: 加载状态

```
Read: .planning/sessions/{latest-session}.md
Read: .planning/STATE.md
Read: .planning/wave-plan.md
Read: .planning/ROADMAP.md
Read: .planning/research-brief.json
```

## Step 3: 验证上下文

| 文件 | 检查 |
|------|------|
| research-brief.json | 存在 + 可读 |
| literature.md | 存在 + 可读 |
| methodology.md | 存在 + 可读 |
| STATE.md | 存在 + 可读 |
| wave-plan.md | 存在 + 可读 |
| ROADMAP.md | 存在 + 可读 |

任一缺失 → 警告 + 提供从 session summary 重建的选项。

## Step 4: 显示 Resume Briefing

```
═══════════════════════════════════════
  RESUME BRIEFING — {project-slug}
═══════════════════════════════════════

Last Session: {timestamp}
Phase:        {N} — {phase-name}
Wave:         {M}/{wave-count} ({tasks-done} tasks completed)
Progress:     {completion}%
Status:       {status}

───────────────────────────────────────
  LAST SESSION SUMMARY
───────────────────────────────────────

Accomplished:
  ✓ {task-1} — {paragraph-title}
  ✓ {task-2} — {paragraph-title}

Decisions Made:
  • {decision-1}
  • {decision-2}

Blockers:
  • {blocker or "None"}

───────────────────────────────────────
  NEXT ACTION
───────────────────────────────────────

Wave {M+1} — {tasks}:
  {task-id}: {description}

Continue with:
  /aw-execute --wave {M+1}

═══════════════════════════════════════
```

## Step 5: 用户选择

```
Options:
  1. 继续 — Resume Wave {M+1} immediately
  2. 查看 — Show full session summary
  3. 跳过 — Jump to specific wave/phase
  4. 终止 — Mark phase as paused (no more writing)
```

**1 (继续):** → `aw-execute` 从当前 wave 继续

**2 (查看):** → 打印完整 session summary，再显示选项

**3 (跳过):** → 询问目标 wave/phase → 更新 STATE.md → 跳转

**4 (终止):** → 更新 STATE.md status 为 `paused` → 打印最终状态

## Step 6: 上下文预加载

继续前验证：
```
Read: research-brief.json (full)
Read: literature.md (full)
Read: methodology.md (full)
Read: sections/{chapter}/*.tex (当前段落文件)
```

任一缺失 → 警告并提供重建选项。
