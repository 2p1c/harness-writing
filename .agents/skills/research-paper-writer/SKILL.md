---
name: research-paper-writer
description: End-to-end research paper writing orchestration. Triggers when user says "write paper", "help me with my paper", "start a new paper project", or uses /newpaper command. Orchestrates the complete workflow: outline → section writing → review → revision → final compilation.
---

# Research Paper Writer

## Purpose

Orchestrate the complete research paper writing workflow from topic to submission-ready manuscript. Coordinates between outline generation, section writing, adversarial review, and compilation.

## Workflow Orchestration

```
                    ┌──────────────────┐
                    │  Project Init    │
                    │  /newpaper       │
                    └────────┬─────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────┐
│           OUTLINE PHASE                          │
│  /outline <topic> → Generate IMRAD structure   │
│  User approves outline                           │
│  → Generate LaTeX section files                 │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│           WRITING PHASE                          │
│  /write <section> for each section              │
│  Order: Introduction → Methodology →            │
│         Results → Discussion → Conclusion        │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│           REVIEW PHASE                           │
│  /review each completed section                  │
│  2-3 rounds of adversarial critique             │
│  User approves revised text                      │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│           COMPILATION PHASE                      │
│  /compile → Generate PDF                         │
│  /check-refs → Validate citations               │
└─────────────────────────────────────────────────┘
```

## Project Initialization

When user initiates `/newpaper`:

1. **Create project structure**:
   ```
   projects/[paper-slug]/
   ├── project.yaml       # Metadata
   ├── outline.md        # Generated outline
   ├── main.tex          # Main document
   ├── references.bib    # Bibliography
   └── sections/
       ├── abstract.tex
       ├── introduction.tex
       ├── methodology.tex
       ├── results.tex
       ├── discussion.tex
       └── conclusion.tex
   ```

2. **Collect metadata**:
   - Paper title
   - Authors and affiliations
   - Target journal
   - Research domain/field

3. **Set project context**:
   - Create project.yaml with metadata
   - Inform user of project location
   - Prompt for next step (usually `/outline`)

## Section Writing Order

Follow this order for logical flow:

1. **Abstract** (after other sections are drafted, summary comes last)
2. **Introduction** (sets context for everything else)
3. **Methodology** (describes approach)
4. **Results** (presents findings)
5. **Discussion** (interprets results)
6. **Conclusion** (summarizes contributions)

## Integration with Other Skills

### Input/Output with paper-outline-generator
- **Receives**: Approved outline with section checkpoints
- **Produces**: Section content that matches outline requirements

### Input/Output with latex-paper-en
- **Receives**: Section name/key points from outline
- **Produces**: LaTeX-formatted content with proper markup

### Input/Output with academic-review
- **Receives**: Written section text
- **Produces**: Improved text after adversarial review
- **Feedback loop**: Review → revision → re-review if needed

## Progress Tracking

Track completion in `project.yaml`:
```yaml
project:
  title: "Paper Title"
  status: in_progress
  sections:
    abstract: pending      # pending | drafted | reviewed | final
    introduction: pending
    methodology: pending
    results: pending
    discussion: pending
    conclusion: pending
```

## Common Commands

```bash
/newpaper <title>     # Initialize new project
/outline <topic>      # Generate outline
/write introduction   # Write a section
/review              # Review current text
/compile             # Generate PDF
/check-refs          # Validate citations
/status              # Show project status
```

## Usage Examples

- `/newpaper 基于深度学习的医学影像诊断系统研究`
- `/help me write my paper about computer vision`
- `/start a new paper on reinforcement learning`
