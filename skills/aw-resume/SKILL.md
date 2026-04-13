# aw-resume — Resume Writing Session

## Purpose

Restore writing session from checkpoint. Load last session summary, verify context health, confirm next action.

## When to Use

After `/aw-pause` or when starting a new Claude Code session on an existing paper project.

## Process

### 1. Find Last Session Summary

```bash
ls -t .planning/sessions/ | head -1
```

If no session files exist → prompt to start fresh with `/aw-init`.

### 2. Load Session State

```
Read: .planning/sessions/{latest-session}.md  → last session summary
Read: .planning/STATE.md                       → current phase/wave/status
Read: .planning/wave-plan.md                   → wave execution plan
Read: .planning/ROADMAP.md                     → all tasks and dependencies
Read: .planning/research-brief.json            → project context
```

### 3. Verify Context Health

Check each file exists and is readable:
- `research-brief.json` — project definition
- `literature.md` — related work
- `methodology.md` — technical content
- `STATE.md` — current progress
- `wave-plan.md` — wave execution state
- `ROADMAP.md` — task roadmap

### 4. Display Resume Briefing

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
  ✓ Completed Wave {M}: merged {files} → {chapter}.tex

Decisions Made:
  • {decision-1}
  • {decision-2}

Blockers:
  • {blocker or "None"}

───────────────────────────────────────
  NEXT ACTION
───────────────────────────────────────

Wave {M+1} — {tasks}:
  {task-id}: {description} (depends on {deps})
  {task-id}: {description}

Continue with:
  /aw-execute --wave {M+1}

───────────────────────────────────────
  CONTEXT HEALTH
───────────────────────────────────────

  research-brief.json  ✅
  literature.md        ✅
  methodology.md       ✅
  STATE.md             ✅
  wave-plan.md         ✅
  ROADMAP.md           ✅

═══════════════════════════════════════
```

### 5. Offer Options

Ask user to choose:

```
Options:
  1. 继续 — Resume Wave {M+1} immediately
  2. 查看 — Show full session summary
  3. 跳过 — Jump to specific wave/phase
  4. 终止 — Mark phase as paused (no more writing)
```

**Option 1 (继续):**
→ Run `/aw-execute` with current wave from STATE.md

**Option 2 (查看):**
→ Print full session summary, then show options

**Option 3 (跳过):**
→ Ask which wave/phase → update STATE.md → jump

**Option 4 (终止):**
→ Update STATE.md status to `paused` → print final status

### 6. Context Loading for Resume

Before spawning subagents, verify context is loaded:

```
Read: research-brief.json (full)
Read: literature.md (full)
Read: methodology.md (full)
Read: sections/{chapter}/**/*.tex (current paragraph files)
```

If any file is missing → warn and offer to regenerate from session summary.

## Quality Checks

- [ ] Session summary found and readable
- [ ] All 6 context files present
- [ ] STATE.md phase/wave accurate
- [ ] User confirmed next action

## Error Handling

| Condition | Action |
|-----------|--------|
| No session files | Prompt: `/aw-init` or start fresh |
| Context file missing | Warn + offer regenerate from summary |
| STATE.md missing | Rebuild from ROADMAP.md defaults |
| wave-plan.md missing | Run `/aw-wave-planner` to regenerate |

## Output

```
skills/aw-resume/
```

No files written — reads only. Updates STATE.md only if user selects "跳过" or "终止".
