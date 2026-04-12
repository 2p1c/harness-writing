# Architecture

**Analysis Date:** 2026-04-12

## Pattern Overview

**Overall:** Skill Orchestration System with Pipeline Processing

This is not a traditional application but a **skill-based plugin system** for academic writing assistance. The architecture centers on composable skills that can be invoked via slash commands or natural language triggers, orchestrated through a central coordinator.

**Key Characteristics:**
- Skill composition via slash commands (`/write`, `/review`, `/newpaper`, etc.)
- Pipeline-based workflow where skills pass output to subsequent skills
- Human-in-the-loop decision points for review and approval
- Dual-agent critique pattern for adversarial text improvement
- Git-aware project management with paper-specific branches

## Layers

**Command Layer (.claude/commands/):**
- Purpose: Entry points that map user commands to skills
- Location: `.claude/commands/*.md`
- Contains: Command definitions with trigger phrases and skill invocation
- Depends on: Skills being registered
- Example: `write.md` invokes `latex-paper-en` skill

**Skill Layer (skills/):**
- Purpose: Reusable capabilities for specific tasks
- Location: `skills/[skill-name]/SKILL.md`
- Contains: Skill metadata, instructions, and integration patterns
- Depends on: Other skills (sometimes), external tools (LaTeX, Zotero)
- Example: `latex-paper-en` for writing sections, `academic-review` for critique

**Orchestration Layer (research-paper-writer):**
- Purpose: Coordinate multi-step workflows across skills
- Location: `skills/research-paper-writer/SKILL.md`
- Contains: Workflow state machine, phase transitions
- Depends on: paper-outline-generator, latex-paper-en, academic-review
- Used by: `/newpaper` command

**Agent Sub-Layer (agents/ within skills):**
- Purpose: Sub-agents for complex multi-agent workflows
- Location: `skills/[skill]/agents/*.md`
- Contains: Prompt templates for Critic, Improver, etc.
- Example: `skills/academic-review/agents/critic.md`, `skills/academic-review/agents/improver.md`

**Template Layer (templates/elsevier/):**
- Purpose: LaTeX template and paper skeleton
- Location: `templates/elsevier/`
- Contains: `main.tex`, `references.bib`, section templates in `sections/`
- Depends on: Elsevier LaTeX class

**Project Layer (manuscripts/):**
- Purpose: Active paper writing projects
- Location: `manuscripts/[paper-name]/`
- Contains: `project.yaml`, `main.tex`, `references.bib`, `sections/*.tex`
- Managed by: git branches for paper isolation

## Data Flow

**Primary Workflow (Paper Writing Pipeline):**

```
/newpaper <title>
    │
    ▼
[research-paper-writer orchestrator]
    │
    ▼
┌─────────────────────────────────────────────────┐
│  MATERIALS COLLECTION PHASE                     │
│  (zotero-context-injector if user agrees)       │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  OUTLINE PHASE                                  │
│  paper-outline-generator → IMRAD structure       │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  WRITING PHASE                                  │
│  latex-paper-en → LaTeX section content         │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  REVIEW PHASE (Human-in-the-loop)               │
│  academic-review (Critic → Improver loop)       │
│  Max 3 rounds, user approves each round         │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  COMPILATION PHASE                              │
│  Makefile: pdflatex → bibtex → pdflatex × 2      │
└─────────────────────────────────────────────────┘
```

**Command Dispatch Flow:**

```
User Input: "/write introduction"
    │
    ▼
.claude/commands/write.md
    │
    ▼
skills/latex-paper-en (invoked)
    │
    ▼
Output: LaTeX section content
```

**Academic Review Flow (Dual-Agent Loop):**

```
User Text
    │
    ▼
┌─────────────────┐
│  Critic Agent   │ ← Identifies issues (no solutions)
└────────┬────────┘
         │ JSON critique report
         ▼
┌─────────────────┐
│ Improver Agent  │ ← Refines text to fix issues
└────────┬────────┘
         │ JSON improved text + report
         ▼
      USER DECIDES (continue/stop/accept)
```

## Key Abstractions

**Skill:**
- Purpose: Encapsulates a reusable capability with trigger conditions
- Examples: `skills/latex-paper-en/SKILL.md`, `skills/academic-review/SKILL.md`
- Pattern: Frontmatter metadata (name, description, triggers) + markdown instructions

**Command:**
- Purpose: Maps slash commands to skill invocations
- Examples: `.claude/commands/write.md`, `.claude/commands/review.md`
- Pattern: Frontmatter description + skill invocation directive

**Orchestrator Skill:**
- Purpose: Coordinates multiple skills in a workflow
- Examples: `skills/research-paper-writer/SKILL.md`
- Pattern: Phase-based state machine with explicit transitions

**Sub-Agent:**
- Purpose: Specialized role within a multi-agent skill
- Examples: `skills/academic-review/agents/critic.md`, `skills/academic-review/agents/improver.md`
- Pattern: Structured prompt with input/output format specifications

**Project:**
- Purpose: Container for a single paper with metadata and content
- Location: `manuscripts/[paper-name]/`
- Contains: `project.yaml`, LaTeX files, references
- Pattern: YAML metadata + IMRAD section files

## Entry Points

**Slash Commands:**
- `.claude/commands/newpaper.md` - Triggers `research-paper-writer` skill
- `.claude/commands/outline.md` - Triggers `paper-outline-generator` skill
- `.claude/commands/write.md` - Triggers `latex-paper-en` skill
- `.claude/commands/review.md` - Triggers `academic-review` skill
- `.claude/commands/cite.md` - Triggers `literature-manager` skill
- `.claude/commands/figure.md` - Triggers `figure-integrator` skill
- `.claude/commands/preview.md` - Triggers `latex-live-preview` skill
- `.claude/commands/branch.md` - Triggers `git-flow-branch-creator` skill
- `.claude/commands/commit.md` - Triggers `git-commit` skill

**Natural Language Triggers:**
- "写论文", "开始写作论文" - Invokes `research-paper-writer`
- "大纲", "论文结构" - Invokes `paper-outline-generator`
- "撰写章节" - Invokes `latex-paper-en`
- "审查", "润色" - Invokes `academic-review`
- "创建新论文" - Invokes `paper-branch-by-title`
- "结束", "今天就写到这了" - Invokes `paper-session-checkpoint-commit`
- "我上次写到哪里了" - Invokes `paper-writing-progress-review`
- "Zotero", "文献库" - Invokes `zotero-context-injector`

## Error Handling

**Strategy:** Graceful degradation with user-facing error messages

**Patterns:**
- Missing external tools: Skill documents requirements (e.g., LaTeX, PlantUML) and provides troubleshooting in README
- Compilation failures: Makefile provides `check-refs` target to validate citations
- Zotero connection: Diagnostic script `build_zotero_context.py --list-collections`
- Review escalation: Structural/methodological issues flagged as "ESCALATION" for human resolution

## Cross-Cutting Concerns

**Logging:** N/A (no runtime logging - this is a template/repository, not an application)

**Validation:**
- Citation keys validated via `make check-refs`
- LaTeX compilation checked via `make quick`
- Skill schemas validated via `skill-creator/quick_validate.py`

**Authentication:** N/A (no user authentication - operates on local files)

**Git Integration:**
- Paper branches via `git-flow-branch-creator`
- Session commits via `git-commit` with file path tracking
- Progress review via commit history analysis

---

*Architecture analysis: 2026-04-12*
