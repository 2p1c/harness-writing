---
name: research-paper-writer
description: 'End-to-end research paper writing orchestration. Triggers when user says "写论文", "开始写作论文", "write paper", "help me with my paper", "start a new paper project", or uses /newpaper command. **MANDATORY: Collect research materials before generating outline.** Orchestrates the complete workflow: materials → outline → section writing → review → revision → final compilation.'
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
│       MATERIALS COLLECTION (MANDATORY)           │
│  Request research data, literature, notes       │
│  User provides all relevant materials          │
│  → Proceed only after materials received       │
└─────────────────────┬───────────────────────────┘
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

When user initiates `/newpaper` or says "开始写作[topic]的论文":

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

3. **Collect research materials** (MANDATORY step — do NOT skip to outline):
   - Ask this consent question before moving on:
     - "是否启用 `zotero-context-injector`？我可以读取你指定 Zotero collection 下的 PDF 并生成写作上下文包。"
   - If user agrees, invoke `zotero-context-injector` to import Zotero materials first.
   - Ask user to provide all relevant materials such as:
     - Experimental data, simulation results, or measurement records
     - Existing literature, references, or reading notes
     - Drafts, outlines, or previous versions
     - Problem descriptions, research questions, or hypothesis statements
     - Any supplementary materials (images, tables, figures)
   - If user has NOT yet gathered materials, **prompt them to do so first** before proceeding
   - If user provides partial materials, acknowledge what was received and ask if there is more

4. **Set project context**:
   - Create project.yaml with metadata
   - Store collected materials in the project directory
   - Inform user of project location
   - Proceed to outline generation only after materials are collected

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
