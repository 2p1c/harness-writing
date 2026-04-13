---
name: paper-branch-by-title
description: 'Use when the user starts a new paper, asks to create a new paper while already on another paper branch, mentions creating a dedicated paper branch, or inputs "/paper-branch". This skill must reuse git-flow-branch-creator and create a title-based branch name so each paper is isolated on its own branch.'
---

# Paper Branch By Title

## Purpose

Create one dedicated git branch per paper title, so different papers are managed independently.

## Trigger Phrases

- "创建新论文"
- "新开一篇论文"
- "在这个仓库再写一篇新论文"
- "new paper"
- "create branch for this paper"

## Required Reuse

Always invoke `git-flow-branch-creator` first, then enforce title-based naming.

## Workflow

1. Ask for paper title if missing.
2. Run `git-flow-branch-creator` to reuse its branch-type analysis and base-branch choice.
3. Build branch slug from paper title:
- lowercase
- replace spaces and separators with `-`
- keep letters, digits, CJK, and `-`
- collapse repeated `-`
- trim leading/trailing `-`
4. Create branch name:
- `feature/paper-<title-slug>`
5. If branch exists, append numeric suffix:
- `feature/paper-<title-slug>-2`, `-3`, ...
6. Create and switch branch, then report:
- paper title
- final branch name
- source branch

## Example

Title: `Laser Ultrasonic Debonding Detection Survey`

Branch:

`feature/paper-laser-ultrasonic-debonding-detection-survey`
