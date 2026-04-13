# aw-pause — Save Writing Session

## Purpose

Save complete writing session state for seamless resume. Update STATE.md, generate session summary, commit git checkpoint.

## When to Use

Before ending a Claude Code session while mid-paper. Captures:
- Current phase and wave execution state
- What was accomplished this session
- Decisions made and blockers encountered
- Pending tasks and next action

## Process

### 1. Detect Current State

```
Glob: sections/**/*.tex                    → list written paragraph files
Read: .planning/STATE.md                   → current phase, status
Read: .planning/wave-plan.md               → current wave, pending tasks
Read: .planning/ROADMAP.md                 → all tasks per phase
Read: .planning/research-brief.json        → project context
```

### 2. Assess Progress

For each section directory in `sections/`:
- Count `.tex` paragraph files written
- Extract `\paragraph{}` titles
- Compute approximate word count (100 words per paragraph)

Determine:
- Current phase number and name
- Current wave number
- Tasks completed this session
- Tasks remaining in current wave
- Total completion percentage

### 3. Generate Session Summary

Write `.planning/sessions/{timestamp}-session.md`:

```markdown
# Writing Session — {timestamp}

**Project**: {project-slug}
**Phase**: {N} — {phase-name}
**Wave**: {M} of {total-waves}
**Started**: {session-start-time}
**Ended**: {now}

---

## Accomplished This Session

- {task-id} — {paragraph-title}: wrote {paragraph-count} paragraphs, ~{words} words
- {task-id} — {paragraph-title}: ...
- Completed Wave {M}: merged {paragraph-files} → {chapter}.tex

## Decisions Made

- {decision}: {rationale}
- {decision}: {rationale}

## Blockers Encountered

- {blocker-description}
- None

## Pending Tasks

### Current Wave (Wave {M+1})
- {task-id}: {description} — depends on {deps}

### Future Waves
- Wave {M+2}: {tasks}
- Phase {N+1}: {pending-phase-name}

## Current Position

- Phase {N}/{total-phases} ({phase-name})
- Wave {M}/{wave-count}
- {completion}% complete ({completed-tasks}/{total-tasks} tasks)

## Next Action

```
/aw-resume
```
→ Continue with Wave {M+1}: {task-list}

---

## Context Health

| File | Status |
|------|--------|
| research-brief.json | ✅ present |
| literature.md | ✅ present |
| methodology.md | ✅ present |
| STATE.md | ✅ present |
| wave-plan.md | ✅ present |
| ROADMAP.md | ✅ present |

## Git Status

Last commit: {last-commit-hash} ({last-commit-message})
```

### 4. Update STATE.md

```markdown
## Current State

```json
{
  "project": "{slug}",
  "phase": {N},
  "phase_name": "{phase-name}",
  "wave": {M},
  "status": "in_progress",
  "current_action": "/aw-resume",
  "last_session": "{timestamp}",
  "completion_pct": {X},
  "pending_phases": [{N, N+1, ...}],
  "completed_phases": [{0, 1, ..., N-1}]
}
```
```

### 5. Git Checkpoint

```bash
git add -A
git commit -m "wip({slug}): Phase {N} Wave {M} — {session-summary}"
```

### 6. Cleanup Temp Files

- Remove `.planning/.zotero-temp.*`
- Remove any `*.bak`, `*.tmp` in project root
- Remove `sections/**/*.log`, `sections/**/*.aux` (LaTeX artifacts)

### 7. Report

```
=== Session Saved ===

Project:  {slug}
Phase:    {N} — {phase-name}
Wave:     {M}/{wave-count} ({tasks-done} tasks done)
Progress: {completion}%

Next: /aw-resume → Wave {M+1}: {task-list}

Git:     {commit-hash}
```

## Quality Checks

- [ ] STATE.md updated with accurate phase/wave/completion
- [ ] Session summary written to `.planning/sessions/`
- [ ] Git commit created
- [ ] Temp files cleaned
- [ ] Next action printed clearly

## Output

```
skills/aw-pause/
```

Writes:
- `.planning/sessions/{timestamp}-session.md` — session summary
- Updates `.planning/STATE.md` — current progress state
