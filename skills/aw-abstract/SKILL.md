---
name: aw-abstract
description: Synthesize all section drafts into a structured 250-word abstract (Background, Objective, Method, Results, Conclusion). Triggers when user says "/aw-abstract", "write abstract", "摘要", or called at end of Phase 2 before aw-finalize. Reads all section drafts, research-brief.json, and methodology.md to produce IMRAD-structured abstract.
---

# Abstract Writer for Academic Papers

## Purpose

Synthesize all completed section drafts into a well-structured abstract of 250 words (range: 225-275) following IMRAD format: Background, Objective, Method, Results, Conclusion. The abstract must be self-contained and readable without the full paper.

## When to Trigger

- User invokes `/aw-abstract`
- User says "write abstract", "摘要", "generate abstract"
- Called automatically at end of Phase 2 (before aw-finalize)
- After all major sections (introduction, methodology, results, discussion, conclusion) have drafts

## IMRAD Abstract Structure (250 words total)

| Section | Word Count | Purpose |
|---------|------------|---------|
| Background | 40 words | Problem context + motivation |
| Objective | 20 words | Paper aim + research question |
| Method | 80 words | U-Net architecture, loss function, dataset |
| Results | 80 words | SNR improvement, CCC metric, generalization |
| Conclusion | 30 words | Significance + impact |
| **Total** | **250 words** | |

## Workflow

```
All Section Drafts (sections/*.tex)
         │
         ▼
┌─────────────────────────┐
│  Read: All Sections     │
│  - introduction.tex     │
│  - methodology.tex      │
│  - results.tex          │
│  - discussion.tex       │
│  - conclusion.tex       │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Read: Supporting Docs  │
│  - research-brief.json  │ → hypothesis, novelty
│  - methodology.md      │ → key technical claims, metrics
│  - project.yaml        │ → paper title, authors
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Draft Abstract         │
│  (IMRAD structure)      │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Quality Checks         │
│  - Word count (250±10%) │
│  - Acronyms defined     │
│  - No \cite{}           │
│  - No \ref{}            │
│  - Self-contained       │
│  - Active voice         │
└───────────┬─────────────┘
            │
      ┌─────┴─────┐
      │  Pass?    │
      └─────┬─────┘
       Yes / \ No
        /     \
       ▼       ▼
  ┌──────── ┌──────────┐
  │ Output  │ Revise   │
  │ abstract│ abstract │
  └──────── └──────────┘
            │
            ▼
     sections/abstract.tex
```

## Step-by-Step Procedure

### Step 1: Read All Section Drafts

Read all available section drafts in order:

1. **introduction.tex** — Extract the research problem, motivation, and gap
2. **methodology.tex** — Extract technical approach, architecture, dataset info
3. **results.tex** — Extract key quantitative findings and metrics
4. **discussion.tex** — Extract implications and significance
5. **conclusion.tex** — Extract summary and contributions

Also read:
- **research-brief.json** — Research hypothesis, novelty claims, key contributions
- **methodology.md** — Key technical claims, evaluation metrics, dataset details
- **project.yaml** — Paper title, authors, journal/target

### Step 2: Extract Key Information

For each section, extract and note:

**From Introduction:**
- The problem being addressed
- Gap in existing research
- Main research question or objective

**From Methodology:**
- Architecture: "U-Net with..." (encoder-decoder structure, skip connections)
- Loss function: "mixed loss combining..."
- Dataset: name, size, characteristics
- Key technical details for replication

**From Results:**
- SNR improvement (dB)
- CCC (concordance correlation coefficient)
- Statistical significance (p-values)
- Comparison with baselines
- Generalization performance

**From Discussion/Conclusion:**
- Main contributions
- Practical implications
- Limitations

### Step 3: Draft Abstract by Section

Write each section following the word count targets:

**Background (40 words):**
```
Current deep learning methods for [task] often suffer from [problem].
Despite advances in [area], challenges remain in [specific gap].
This necessitates new approaches that [what is needed].
```

**Objective (20 words):**
```
This paper aims to develop a [method] that [what it does] to address [problem].
We validate our approach on [dataset] using [metrics].
```

**Method (80 words):**
```
We propose [method name], a [architecture] designed for [task].
The model employs [key technical features: encoder-decoder structure, skip connections, mixed loss function].
Training uses [optimizer] with [learning rate] on [dataset: size, characteristics].
Evaluation follows [standard protocol] using [metrics: SNR, CCC, accuracy].
```

**Results (80 words):**
```
Experiments on [dataset] demonstrate [metric] improvement of [value] compared to [baseline].
Our method achieves [metric] of [value], outperforming state-of-the-art by [percentage].
Statistical analysis confirms significance (p<0.05, n=[samples]).
The approach shows strong generalization across [conditions], validating its practical applicability.
```

**Conclusion (30 words):**
```
We contribute [method] that advances [task] with [key result].
This work provides a practical solution for [application area],
paving the way for [future direction].
```

### Step 4: Quality Checks

After drafting, perform each check:

| Check | Requirement | If Failed |
|-------|-------------|-----------|
| Word count | 250 ± 10% (225-275 words) | Revise to fit target |
| Acronyms defined | All acronyms defined on first use | Add full term before acronym |
| No \cite{} | Abstract must not contain citations | Remove or paraphrase |
| No \ref{} | Abstract must not reference figures/tables | Remove or inline the reference |
| Self-contained | Readable without reading the paper | Rewrite to be standalone |
| Active voice | Use active voice where possible | Rewrite passive sentences |

**Self-contained check:**
- Does the abstract explain WHAT was done, HOW it was done, and WHY it matters?
- Can a reader understand the paper's contribution from the abstract alone?
- Are all technical terms either common knowledge or defined?

### Step 5: Output Final Abstract

Write to `manuscripts/{slug}/sections/abstract.tex`:

```latex
\begin{abstract}
% [Background - 40 words]
Current deep learning methods for medical image segmentation often suffer from poor generalization under domain shift. Despite advances in convolutional architectures, challenges remain in preserving fine-grained details while maintaining robustness across datasets. This necessitates new approaches that explicitly model domain-invariant features.

% [Objective - 20 words]
This paper aims to develop a U-Net variant with mixed loss training that addresses the domain generalization problem in medical imaging. We validate our approach on the MM-WHS dataset using SNR and CCC metrics.

% [Method - 80 words]
We propose GSD-UNet, an encoder-decoder network with domain-adaptive attention mechanisms designed for cross-site cardiac MR image segmentation. The model employs a mixed loss combining Dice and focal loss, with additional domain discriminator regularization. Training uses Adam optimizer with learning rate 1e-4 on 200 annotated subjects from multiple sites. Evaluation follows five-fold cross-validation using Signal-to-Noise Ratio (SNR) and Concordance Correlation Coefficient (CCC) metrics.

% [Results - 80 words]
Experiments on the MM-WHS dataset demonstrate SNR improvement of 4.7 dB compared to baseline U-Net. Our method achieves CCC of 0.92, outperforming state-of-the-art methods by 8.3\%. Statistical analysis confirms significance (p<0.01, n=200). The approach shows strong generalization across four external validation sites, with CCC dropping less than 5\%, validating its practical applicability in multi-center studies.

% [Conclusion - 30 words]
We contribute GSD-UNet that advances cardiac MR segmentation with improved domain generalization. This work provides a practical solution for multi-center clinical deployment, paving the way for real-time diagnostic assistance.

\PACS{PACS code}
\keywords{domain adaptation; medical image segmentation; U-Net; cardiac MRI; deep learning}
\end{abstract}
```

## Abstract Quality Checklist

- [ ] Word count is 250 ± 10% (225-275 words)
- [ ] All acronyms defined on first use (SNR, CCC, etc.)
- [ ] No \cite{} commands present
- [ ] No \ref{} commands present
- [ ] No figure/table references that require reading the paper
- [ ] Abstract is self-contained and understandable alone
- [ ] Active voice used where possible
- [ ] Each IMRAD section has appropriate word count
- [ ] Key quantitative results are included (metrics, percentages)
- [ ] \PACS and \keywords fields are populated
- [ ] LaTeX compiles without errors

## Common Errors to Avoid

1. **Including citations** — The abstract must stand alone. Remove all \cite{}.
2. **Cross-references** — Don't write "as shown in Fig. 1" — describe the finding instead.
3. **Vague claims** — Include specific metrics: "improved by 4.7 dB" not just "significantly improved".
4. **Background too long** — The problem statement should be concise; save space for results.
5. **Methods too detailed** — Focus on what makes your approach novel, not every parameter.
6. **No results** — This is the most common abstract failure. Include specific numbers.
7. **Conclusions over claims** — Don't overstate; be precise about what was demonstrated.

## Acronym Handling

Define all acronyms on first use in the abstract:

| Acronym | Full Term | When to Define |
|---------|-----------|----------------|
| SNR | Signal-to-Noise Ratio | Method or Results section |
| CCC | Concordance Correlation Coefficient | Method or Results section |
| MRI | Magnetic Resonance Imaging | Background |
| CT | Computed Tomography | Background |
| U-Net | U-Net (architecture name, not expanded) | Method |
| CNN | Convolutional Neural Network | Background |
| Dice | Dice similarity coefficient | Method |
| IoU | Intersection over Union | Method |

## Trigger Variations

- `/aw-abstract` — Full abstract generation
- `/aw-abstract draft` — Generate draft only, no quality checks
- `/aw-abstract check` — Check existing abstract quality
- `/aw-abstract revise` — Revise existing abstract based on feedback

## Error Handling

| Error | Response |
|-------|----------|
| Section files missing | List which sections are missing; generate abstract from available content |
| research-brief.json not found | Proceed without hypothesis/novelty; note this in output |
| methodology.md not found | Extract method details from methodology.tex |
| Word count far off (>300 or <200) | Show breakdown by section; suggest specific revisions |
| Contains citations | Remove all \cite{} and rewrite affected sentences |
| Not self-contained | Identify unclear references; rewrite to inline the information |
