# Research Paper Writing Workflow Guide

A step-by-step guide for writing a complete academic paper.

---

## Phase 1: Project Initialization

### Step 1.1: Define Your Paper

Before starting, clarify:
- **Topic**: What is your research about?
- **Research type**: Empirical study, technical implementation, literature review, or case study?
- **Target journal**: What journal do you aim to submit to? (Check author guidelines)
- **Word limit**: Does the journal have page or word limits?

### Step 1.2: Set Up Project

```bash
/newpaper <your paper title>
```

This creates:
- Project directory under `projects/`
- Template structure with LaTeX files
- `project.yaml` for metadata

### Step 1.3: Import Literature Context (Optional but Recommended)

Before outline generation, ask whether to enable Zotero import:

- "是否启用 `zotero-context-injector`？"

If yes, generate a context pack from a specific Zotero collection and query, then treat it as input material for `/outline` and `/write`.

---

## Phase 2: Outline Generation

### Step 2.1: Generate Outline

```bash
/outline <your research topic>
```

Example:
```
/outline 基于深度学习的医学影像诊断准确性提升研究
```

### Step 2.2: Review and Refine

The system generates an IMRAD outline. Review:
- [ ] Are all key points covered?
- [ ] Is the structure appropriate for your research type?
- [ ] Are there any sections that need expansion or compression?

### Step 2.3: Approve and Generate Files

Once satisfied, approve the outline. The system:
- Creates LaTeX section files
- Populates `sections/` directory
- Sets up `main.tex` to include all sections

---

## Phase 3: Section Writing

### Writing Order

Write sections in this order for logical development:

1. **Methodology** (you know what you did)
2. **Results** (you have the data)
3. **Introduction** (you now understand the context)
4. **Discussion** (you can interpret against findings)
5. **Conclusion** (everything is clear)
6. **Abstract** (you can summarize everything)

### Writing Each Section

```bash
/write introduction
/write methodology
```

Guidelines for each section are in `latex-paper-en/SKILL.md`.

### Section Checkpoints

After writing each section:
- [ ] Does it match the outline's key points?
- [ ] Is the LaTeX markup correct?
- [ ] Are citations properly formatted?

---

## Phase 4: Adversarial Review

### Step 4.1: Review Each Section

```bash
/review introduction
/review methodology
# etc.
```

### Step 4.2: Interpret Review Results

Review produces:
1. **Critique report** - Lists issues by severity (BLOCKING, HIGH, MEDIUM, LOW)
2. **Improved text** - Addresses identified issues
3. **Escalation items** - Structural issues requiring author attention

### Step 4.3: Decide on Iterations

After each round:
- **Continue**: If significant issues remain
- **Accept**: If text is satisfactory

Maximum 3 review rounds per section.

### Step 4.4: Handle Escalations

If review flags escalate issues (structural/methodological):
1. Address the escalated issue manually
2. Re-review if needed
3. Continue with next section

---

## Phase 5: Compilation

### Step 5.1: Compile Draft

```bash
/compile
```

This runs `make paper` to generate PDF.

### Step 5.2: Check Citations

```bash
/check-refs
```

Verify:
- All `\cite{}` commands have corresponding entries
- No missing or duplicate references

### Step 5.3: Address Compilation Errors

Common issues:
- "Undefined reference" → Run compile twice
- "Missing figure" → Check file path
- "Citation undefined" → Check .bib file

### Step 5.4: Review Final PDF

Read the PDF and check:
- [ ] All sections present and in correct order
- [ ] Figures and tables render correctly
- [ ] Citations appear numbered
- [ ] Page limits not exceeded

---

## Phase 6: Submission Preparation

### Step 6.1: Final Checks

Before submission:
- [ ] Follow journal author guidelines exactly
- [ ] Format references per journal style
- [ ] Prepare supplementary materials if needed
- [ ] Complete conflict of interest statement
- [ ] Gather all author information

### Step 6.2: Export if Needed

If journal requires Word:
```bash
make word
```

### Step 6.3: Archive Project

Keep a copy of:
- Final LaTeX source
- PDF output
- All figure files
- References (.bib)

---

## Timeline Template

For a typical 8000-word paper:

| Phase | Time | Activities |
|-------|------|------------|
| Initialization | 0.5 day | Set up project, define scope |
| Outline | 1 day | Generate outline, get feedback |
| Methodology | 2 days | Write methodology section |
| Results | 2 days | Present findings |
| Introduction | 1 day | Context and motivation |
| Discussion | 1.5 days | Interpretation |
| Conclusion | 0.5 day | Summary |
| Review | 3 days | 2-3 rounds per section |
| Revision | 2 days | Address feedback |
| Polish | 1 day | Final language check |
| Compile | 0.5 day | Final PDF, submit |

---

## Troubleshooting

### Writer's Block
- Use `/outline` to break into smaller sections
- Focus on methodology (concrete, factual)
- Write abstract last

### Structure Issues
- If outline doesn't fit your content, revise outline first
- Don't force content into wrong structure

### Review Feedback Too Harsh
- Remember: critique is on text, not you
- BLOCKING issues must be fixed
- LOW issues are optional

### Compilation Fails
1. Run `/compile` twice (resolves most reference issues)
2. Check `/check-refs` for citation problems
3. Verify all figures are in correct location
