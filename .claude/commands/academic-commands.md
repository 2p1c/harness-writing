# Academic Writing Commands

Slash commands for academic paper writing workflow. These commands activate skills for the paper writing pipeline.

## Command Reference

### /outline
**Skill**: `paper-outline-generator`
**Purpose**: Generate structured paper outline from research topic

```bash
/outline <research topic>
```

**Examples**:
- `/outline 深度学习在医学图像诊断中的应用`
- `/outline 基于Transformer的代码生成研究`
- `/outline 面向智能制造的工业机器人视觉引导系统`

**What it does**:
1. Analyzes research topic
2. Generates IMRAD-based structure
3. Presents outline in markdown with checkboxes
4. User approves with "可以" / "generate" / "approve" → generates LaTeX files

---

### /write
**Skill**: `latex-paper-en`
**Purpose**: Write or continue a specific paper section

```bash
/write <section name or description>
```

**Examples**:
- `/write introduction for deep learning medical imaging paper`
- `/write methodology section about transformer architecture`
- `/write 撰写methodology章节`
- `/write results comparing baseline methods`

**What it does**:
1. Identifies section to write (introduction, methodology, etc.)
2. Generates LaTeX-formatted content following Elsevier guidelines
3. Includes proper citations, markup, and academic voice
4. Output ready for `/review`

**Tip**: Provide context (research goal, key methods, reference papers) for better output.

---

### /review
**Skill**: `academic-review`
**Purpose**: Adversarial dual-agent review of written text

```bash
/review [section name or paste text]
```

**Examples**:
- `/review` (reviews currently open/pasted text)
- `/review introduction draft`
- `/review 帮我审查一下methodology部分`
- `/review and polish the abstract`

**What it does**:
1. **Round 1**: Critic Agent identifies weaknesses (precision, citations, logic, register)
2. **Round 2**: Improver Agent refines text
3. **User decides**: Continue next round or accept current version
4. **Max 3 rounds** to prevent infinite loops
5. Escalates structural issues requiring author attention

**Output**:
- Critique report with severity ranking (BLOCKING/HIGH/MEDIUM/LOW)
- Improved text with changes highlighted
- List of escalated issues (structural problems needing more than polish)

---

### /newpaper
**Skill**: `research-paper-writer`
**Purpose**: Initialize a new paper project with Elsevier template

```bash
/newpaper <title>
```

**Examples**:
- `/newpaper 基于深度学习的医学影像诊断系统研究`
- `/newpaper 面向智能制造的工业机器人视觉引导技术`

**What it does**:
1. Creates project directory under `manuscripts/[slug]/`
2. Generates `project.yaml` with metadata (title, authors, target journal)
3. Copies Elsevier template structure
4. Prompts to run `/outline` for structure planning

---

### /status
**Skill**: `research-paper-writer`
**Purpose**: Show current paper project status

```bash
/status
```

**What it shows**:
| Section | Status | Notes |
|---------|--------|-------|
| Introduction | drafted | 1,234 words |
| Methodology | reviewed | ✓ 2 review rounds |
| Results | pending | - |
| ... | ... | ... |

**Status values**: `pending` | `drafted` | `reviewed` | `final`

---

### /cite
**Skill**: `literature-manager`
**Purpose**: Add citation to project's references.bib

```bash
/cite <author, year> or <title>
```

**Examples**:
- `/cite LeCun 2015`
- `/cite Vaswani 2017 attention`
- `/cite 帮我添加这篇论文的引用`

**What it does**:
1. Parses citation request
2. If user provides BibTeX → validates format and adds
3. If user asks for search → generates template with [TBD] placeholders
4. Reports citation key to use in `\cite{key}`

---

### /figure
**Skill**: `figure-integrator`
**Purpose**: Generate or integrate figure with proper formatting

```bash
/figure <description>
```

**Examples**:
- `/figure 生成系统架构图`
- `/figure 实验结果对比表格`

**What it does**:
1. Interprets figure description
2. Generates via PlantUML/Graphviz if tools available
3. Provides properly formatted LaTeX markup
4. Saves to `figures/` directory in project

**Fallback**: If PlantUML/Graphviz not installed, provides LaTeX/TikZ code or descriptive guidance.

---

### /compile
**Purpose**: Compile current paper project to PDF
**No skill required** (direct Makefile execution)

```bash
/compile
```

**What it does**:
1. Runs `make paper` in current project directory
2. Generates PDF output
3. Reports compilation errors if any

---

### /check-refs
**Purpose**: Validate citation references
**No skill required** (direct Makefile execution)

```bash
/check-refs
```

**What it does**:
1. Lists all `\cite{}` commands in .tex files
2. Cross-references with references.bib entries
3. Reports missing or unused citations

---

## Workflow Pipeline

```
/newpaper <title>
    │
    ▼ (user provides research topic)
/outline <topic>
    │
    ▼ (user approves with "可以" / "generate")
/write <section> (for each section, in recommended order)
    │
    ▼ (after each section is drafted)
/review (2-3 adversarial rounds, user decides when to stop)
    │
    ▼
/compile
    │
    ▼
PDF ready
```

### Recommended Writing Order

1. **Methodology** - You know what you did
2. **Results** - You have the data
3. **Introduction** - Now you understand the context
4. **Discussion** - You can interpret findings
5. **Conclusion** - Everything is clear
6. **Abstract** - Write last (summarizes everything)

## Quick Start

```bash
# 1. Initialize project
/newpaper 基于深度学习的医学影像诊断研究

# 2. Generate outline (if you want structure guidance)
/outline 基于深度学习的医学影像诊断研究

# 3. Write sections
/write introduction
/write methodology
# ... continue for each section

# 4. Review and polish
/review introduction
# ... repeat for each section

# 5. Compile to PDF
/compile
```

**Note**: `/outline` after `/newpaper` is optional. If you already have a clear research structure, go directly to `/write`.
