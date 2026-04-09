---
name: paper-outline-generator
description: Generate structured paper outlines from research topics. Triggers when user says "outline", "框架", "大纲", "目录", "论文结构", "章节安排", "plan a paper", "开始写论文", or uses /outline command. Analyzes research topic and produces IMRAD-based paper structure with section-level key points. Does NOT conflict with latex-paper-en (which focuses on writing, not structure planning).
---

# Paper Outline Generator

## Purpose

Generate comprehensive paper outlines following academic IMRAD structure based on research topic analysis.

## Workflow

1. **Analyze Input**: Parse user's research topic, field, and target journal
2. **Generate Structure**: Create IMRAD sections with sub-points
3. **Present Outline**: Show structured markdown for user review
4. **Refine**: Adjust based on user feedback

## IMRAD Structure

### Standard Sections

```
1. Introduction
   - 1.1 Background (2-3 paragraphs establishing context)
   - 1.2 Literature review (prior work and gaps)
   - 1.3 Research questions / objectives
   - 1.4 Paper contributions
   - 1.5 Paper structure overview

2. Methodology
   - 2.1 Research design
   - 2.2 Data collection / experimental setup
   - 2.3 Data analysis methods
   - 2.4 Validity and reliability

3. Results
   - 3.1 Descriptive statistics / initial findings
   - 3.2 Main results with supporting data
   - 3.3 Secondary findings
   - 3.4 Statistical significance

4. Discussion
   - 4.1 Interpretation of main results
   - 4.2 Comparison with prior work
   - 4.3 Implications and significance
   - 4.4 Limitations
   - 4.5 Future work

5. Conclusion
   - 5.1 Summary of contributions
   - 5.2 Practical implications
   - 5.3 Concluding remarks
```

### Variations by Paper Type

Choose structure based on your research:

**Empirical Research (IMRAD)**
- Standard IMRAD structure
- Emphasis on methodology and results

**Engineering/Technical Paper**
- Introduction → Related Work → Proposed Method → Experiments → Discussion → Conclusion
- "Related Work" can be merged into Introduction for short papers

**Literature Review / Survey**
- Introduction → Search Methodology → Thematic Analysis → Findings → Discussion → Conclusion
- Consider PRISMA flow diagram if systematic review

**Applied Research**
- Introduction → Methodology (with strong practical focus) → Results → Discussion (emphasize implications)
- Add "Practical Implications" subsection in Discussion

### Handling Complex Papers

**Multi-Research Question Paper**:
- State all RQs in Introduction
- Each RQ may need its own methodology subsection
- Results section may need separate subsections per RQ

**Mixed Methods (Quantitative + Qualitative)**:
- Methodology should have two clear parts: Quantitative phase, Qualitative phase
- Results should present each method's findings before integration

## Output Format

```markdown
## Paper Outline: [Topic]

**Research Type**: [IMRAD/Technical Review/Applied]
**Target Journal**: [If specified]

### 1. Introduction
- [ ] **1.1 Background** - [key points to cover]
- [ ] **1.2 Literature Gaps** - [identified gaps]
- [ ] **1.3 Research Questions** - [questions this paper addresses]
- [ ] **1.4 Contributions** - [paper's novel contributions]

### 2. Methodology
- [ ] **2.1 [Research Design]** - [design type]
- [ ] **2.2 [Data Collection]** - [how data was obtained]
- [ ] **2.3 [Analysis]** - [methods used]

... (continue for all sections)
```

## Key Principles

- Each section should have 2-4 sub-points maximum
- Sub-points describe WHAT to cover, not HOW to write
- Include "checkpoints" for user to verify content direction
- After outline approval, offer to generate LaTeX section files

## LaTeX File Generation (After Approval)

When user approves the outline, offer to generate:

1. **Project structure**:
   ```
   projects/[paper-name]/
   ├── project.yaml       # Metadata (title, authors, journal)
   ├── outline.md        # This outline
   ├── main.tex         # Main document (linked to template)
   ├── references.bib    # Empty bibliography
   └── sections/
       ├── abstract.tex
       ├── introduction.tex
       ├── methodology.tex
       ├── results.tex
       ├── discussion.tex
       └── conclusion.tex
   ```

2. **Generated from outline**:
   - Each section `.tex` file contains section title + bullet points from outline as comments
   - `main.tex` includes all sections in correct order
   - Placeholder for user to fill in actual content

## Integration

### Workflow Pipeline
```
paper-outline-generator → latex-paper-en → academic-review
```

- **Input**: Research topic, research questions, target journal
- **Output**: Approved outline + generated LaTeX structure
- **Next step**: Use `/write [section]` with latex-paper-en to write content

## Usage Examples

- `/outline 深度学习在医学图像诊断中的应用`
- `/outline 面向智能制造的工业机器人视觉引导系统`
- `/outline 基于Transformer的代码生成研究`
