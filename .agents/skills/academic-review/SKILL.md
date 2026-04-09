---
name: academic-review
description: Adversarial academic text review with dual-agent critique loop. Triggers when user requests "review", "审查", "polish", or uses /review command. Uses Critic Agent to identify weaknesses, then Improver Agent to refine text. Iterates 2-3 rounds until convergence.
---

# Academic Review - Adversarial Dual-Agent Loop

## Purpose

Improve academic writing through systematic adversarial critique. A Critic Agent identifies weaknesses without providing solutions; an Improver Agent refines the text based on critique. This loop repeats until stable.

## Workflow (Human-in-the-Loop)

```
User Text Input
      │
      ▼
┌─────────────────┐
│  Critic Agent   │  ← Identifies issues (no solutions)
│  (质疑者)        │
└────────┬────────┘
         │ Critique Report
         ▼
┌─────────────────┐
│ Improver Agent  │  ← Refines text to fix issues
│  (改进者)       │
└────────┬────────┘
         │ Improved Text + Report
         ▼
      ┌─────────────┐
      │ USER DECIDES │  ← Human approves or requests more rounds
      └─────────────┘
            │
      ┌─────┴─────┐
      │Continue?  │
      └───────────┘
         │Yes      │No (stop)
         ▼           ▼
    Next Round    Final Text
    (max 3)
```

**Human Decision Points:**
- After each round, user sees critique report + improved text
- User decides whether to: continue to next round, accept current version, or abort
- Maximum 3 rounds to prevent infinite loops

## When to Trigger

- User types `/review`
- User says "审查", "润色", "polish"
- User asks to improve academic writing quality
- After completing a section draft

## When NOT to Trigger

- **Early brainstorming phase**: Use `/planner` or `paper-outline-generator` instead
- **Already reviewed text**: Do not re-review text that has already passed 3 review rounds
- **Non-academic text**: If input is clearly code, logs, or non-academic content, ask user to confirm before proceeding
- **Structural redesign needed**: If text has severe organizational issues, recommend `/planner` first

## Input Validation

Before running the review loop:
1. Check if input appears to be academic text (sections, paragraphs, citations)
2. If input is ambiguous, ask: "This appears to be [type]. Continue with academic review, or provide the section to review?"
3. If text is very short (<50 words), note that limited feedback is possible

## Critic Agent Instructions

The Critic Agent evaluates text and produces a structured critique:

### Checklist
1. **Precision** - Are claims stated precisely?
   - Flag: vague language ("significant", "many", "good", "various")
   - Flag: undefined technical terms without context

2. **Support** - Are claims backed by evidence?
   - Flag: assertions without citation
   - Flag: logical leaps without justification

3. **Logic Flow** - Do ideas connect logically?
   - Flag: abrupt transitions
   - Flag: missing logical connectors
   - Flag: structural issues (e.g., results before method)

4. **Completeness** - Is anything critical missing?
   - Flag: undefined abbreviations
   - Flag: missing necessary context
   - Flag: incomplete arguments

5. **Academic Register** - Is tone consistent and appropriate?
   - Flag: colloquialisms or informal language
   - Flag: inconsistent hedging
   - Flag: over-claiming or under-claiming

### Output Format (Critic)
```json
{
  "critique": [
    {
      "issue": "Vague quantification",
      "location": "Paragraph 2, sentence 3",
      "text": "\"showed significant improvement\"",
      "problem": "What makes it significant? Undefined without context or metrics."
    }
  ],
  "summary": "Main weaknesses identified: (1) vague quantification, (2) missing citations..."
}
```

## Improver Agent Instructions

The Improver Agent refines text based on critique:

### Guidelines
- Address ALL identified issues
- Replace vague language with specific alternatives
- Add citations where claims lack support
- Strengthen transitions
- Maintain author's voice
- Flag any changes that alter meaning

### Output Format (Improver)
```json
{
  "improvements": [
    {
      "original": "showed significant improvement",
      "revised": "improved by 23.5% (p<0.01, n=100)",
      "reason": "Quantified improvement and added statistical evidence"
    }
  ],
  "revised_text": "Full revised text here..."
}
```

## Iteration Control

1. **Round 1**: Initial critique + improvement
2. **Round 2**: New critique of improved text + additional refinement
3. **Round 3**: Final critique + last refinement

**Stopping Conditions** (measurable):
- **Issue reduction > 50%**: If Critic identifies 50%+ fewer issues in Round 2 vs Round 1, and Round 3 shows further reduction, stop
- **Stable text reached**: If improved text differs from previous by <5 words (word-level diff), stop
- **Max rounds reached**: After Round 3, stop regardless of issue count
- **User decision**: User can stop at any round by accepting current version

**Escalation Path**: If Critic identifies **structural/methodological issues** beyond surface text polish (e.g., logical flaws, missing sections, unsupported claims that need new research), flag these as "ESCALATION" and recommend:
- `/planner` to redesign the section structure
- The original author to address the gap before continuing review

## Final Output

```markdown
## Academic Review Complete

**Rounds**: 2/3
**Issues Found**: 5
**Issues Resolved**: 5

### Key Changes
1. Added quantitative metrics to vague claims
2. Added 3 missing citations
3. Strengthened transition between paragraphs 3-4
4. Replaced 2 colloquial phrases with academic alternatives

### Escalated Issues (requires author attention)
- [List structural/methodological issues that need more than polish]

### Revised Text
[Full revised text with changes highlighted]

---
## Original vs Final (summary)
[Side-by-side comparison for major changes]
```

## Usage Examples

- `/review my introduction draft`
- `/review 帮我审查一下methodology部分`
- `/review and polish the abstract`
