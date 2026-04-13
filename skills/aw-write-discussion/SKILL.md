---
name: aw-write-discussion
description: |
  GSDAW Discussion Section Writer — writes Phase 6 (Discussion) of an academic paper.
  Triggers when user approves Results via quality gate after aw-write-results, or explicitly
  runs /aw-write-discussion. Reads results.tex, literature.md, and methodology.md (risks).
  Outputs independent paragraph .tex files to sections/discussion/ for wave aggregation.
---

# Discussion Section Writer

## Purpose

Write the Discussion section (Phase 6) of an academic paper. Interprets results, compares with prior work, acknowledges limitations, and discusses failure cases. Produces four independent paragraph files for wave aggregation by `aw-execute`.

## When to Trigger

- User approves Results via quality gate after `aw-write-results`
- Orchestrator calls this skill during GSDAW `/aw-execute` pipeline
- User explicitly runs `/aw-write-discussion`

## Prerequisites

Before starting, verify:
1. `sections/results.tex` (or paragraph files in `sections/results/`) exists and is approved
2. `.planning/literature.md` exists (prior work context)
3. `.planning/methodology.md` exists (risks and limitations documented)
4. `sections/discussion/` directory exists in the manuscript project

## Workflow

```
aw-write-discussion starts
    │
    ▼
Read: sections/results.tex (or sections/results/*.tex)
    │  Extract: key findings to interpret
    ▼
Read: .planning/literature.md
    │  Extract: prior work comparisons, research gap
    ▼
Read: .planning/methodology.md
    │  Extract: risks, limitations, expected challenges
    ▼
Write: sections/discussion/6-1-interpretation.tex
    │  → What the results mean
    ▼
Write: sections/discussion/6-2-literature-comparison.tex
    │  → How results compare with prior work
    ▼
Write: sections/discussion/6-3-limitations.tex
    │  → Honest acknowledgment of limitations
    ▼
Write: sections/discussion/6-4-failure-cases.tex
    │  → Analysis of when and why method fails
    ▼
Report completion
```

---

## Step 1: Read Results

Read the results section (either consolidated `sections/results.tex` or individual paragraph files) and extract:

### Key Findings to Interpret

| Finding | Where Found | Interpretation Direction |
|---------|-------------|--------------------------|
| SNR improvement magnitude | 5-1, 5-2, 5-3 | Why is the improvement (or not) as expected? |
| Cross-domain transfer | 5-4-generalization.tex | What does the generalization pattern tell us? |
| Ablation impact | 5-6-ablation.tex | Which component matters most and why? |
| Detection precision/recall | 5-5-detection.tex | What drives the high detection rate? |

### Typical Result Patterns to Address

```
Pattern A: Results exceed expectations
→ What factors contributed to better-than-expected performance?
→ Is this reproducible or an artifact?

Pattern B: Results meet expectations
→ Are there any surprising aspects within expected range?
→ Do different datasets show consistent patterns?

Pattern C: Results below expectations
→ What are the plausible explanations?
→ Does ablation reveal why?
→ Is this a fundamental limitation or fixable?

Pattern D: Mixed results across datasets
→ Which conditions favor the method?
→ Is there a common factor in better-performing datasets?
```

---

## Step 2: Read Literature

Read `.planning/literature.md` and extract prior work comparisons:

### Required Fields

| Field | Use |
|-------|-----|
| Research Gap | What the paper addresses that prior work does not |
| Baseline Methods | Methods to compare results against |
| Category weaknesses | Where prior methods fall short |
| Citation keys | For \cite{} in discussion |

### Literature Structure Example

```markdown
## Related Work Categories

### Category A: Traditional Methods

| Method | Strength | Weakness |
|--------|----------|----------|
| MethodX | Fast | Poor generalization |
| MethodY | Interpretable | Low accuracy |

### Category B: Deep Learning Methods

| Method | Strength | Weakness |
|--------|----------|----------|
| MethodZ | High accuracy | Requires large data |
| MethodW | Good transfer | Domain-specific |

## Research Gap

Prior work has not addressed [specific gap]. This paper proposes [approach]
to fill this gap by [mechanism].
```

---

## Step 3: Read Methodology (Risks)

Read `.planning/methodology.md` and extract risk/limitation documentation:

### Risk Categories

| Risk | Documented Likelihood | Documented Mitigation |
|------|----------------------|----------------------|
| Baseline X doesn't reproduce | Medium | Use official implementation |
| Dataset Y has label noise | Low | Cross-validation |
| GPU memory exceeds limit | Medium | Reduce batch size |

---

## Step 4: Write Paragraph Files

Write each paragraph as an independent `.tex` snippet using Elsevier LaTeX format.

### Output Locations

```
sections/discussion/
├── 6-1-interpretation.tex       # Result interpretation
├── 6-2-literature-comparison.tex # Comparison with prior work
├── 6-3-limitations.tex          # Honest limitations
└── 6-4-failure-cases.tex        # Failure case analysis
```

---

### File: 6-1-interpretation.tex

```latex
\section{Discussion}
\label{sec:discussion}

paragraph{6.1 Interpretation of Results}

The experimental results demonstrate that the proposed method achieves
substantial SNR improvement and detection accuracy gains across all three
datasets. We interpret these findings in the context of the underlying
mechanisms.

\textbf{SNR Improvement Analysis.}
The observed SNR improvements (12.4 dB on simulated, 9.8 dB on aluminum,
11.1 dB on CFRP data) substantially exceed the baseline levels, with the
largest relative gain on the most challenging CFRP dataset (+22.0\% over
best baseline). This pattern suggests that the proposed method's architecture
is particularly effective at separating signal from complex interference
patterns. We attribute this to two factors: (1) Component A's ability to
learn material-specific representations that capture the characteristic
wave-material interactions, and (2) the Attention mechanism's capacity to
focus on relevant frequency components while suppressing background noise.

\textbf{Detection Accuracy Analysis.}
The high detection accuracies (94.2\%, 91.5\%, and 93.0\% respectively) indicate
that the SNR improvements translate directly into reliable defect identification.
Notably, the precision-recall balance is maintained across all datasets
(P $>$ 90\%, R $>$ 92\%), suggesting that the method does not achieve high recall
by over-predicting. This balance is critical for practical deployment, where
false positives impose costly downstream verification burdens.

\textbf{Ablation Insights.}
The ablation study reveals Component A as the primary performance driver
(+4.4\% accuracy), with the Attention mechanism contributing +2.7\% and
Component B adding +2.1\%. The synergistic effect observed when removing
both Component A and Attention (+8.4\% total drop) suggests that these
components operate through complementary mechanisms: Component A provides
the representational capacity while Attention selectively amplifies
task-relevant features.
```

**Key elements:**
- Interpretation of SNR improvement magnitude and pattern
- Discussion of precision-recall balance (practical deployment)
- Ablation insights tied to architecture understanding
- Material-specific interpretation (CFRP > aluminum pattern)

---

### File: 6-2-literature-comparison.tex

```latex
paragraph{6.2 Comparison with Prior Work}

We compare the proposed method's performance with prior approaches across
three dimensions: SNR improvement, detection accuracy, and generalization capability.

\textbf{SNR Improvement.}
Compared with MethodX \citeauthor{methodx2022}, which reports 6.2--8.1 dB
improvement on industrial datasets, the proposed method achieves 9.8--12.4 dB,
representing a 37--53\% improvement in SNR. MethodY \citeauthor{methody2023}
achieves competitive detection accuracy but at lower SNR levels, suggesting
their approach trades off noise suppression for detection speed. Our method
achieves both high SNR and high accuracy, resolving this trade-off.

Compared with MethodZ \citeauthor{methodz2021}, which reports the previous
state-of-the-art on CFRP data (9.1 dB), the proposed method achieves 11.1 dB.
The 2.0 dB improvement is particularly meaningful because MethodZ's approach
was specifically designed for anisotropic materials, yet our method surpasses
it even on this challenging domain.

\textbf{Detection Accuracy.}
The proposed method's detection accuracy of 93.0\% on CFRP substantially
exceeds MethodZ's 86.4\%. MethodX and MethodY achieve 80.1\% and 82.6\%
respectively on the same dataset. The 6.6 percentage point gap over the
previous best baseline is attributable to the architectural choices that
prioritize signal quality (via Component A) while maintaining robust
pattern recognition (via Component B).

\textbf{Generalization.}
Prior work \citeauthor{zhang2020,chen2021} has noted significant performance
degradation when transferring between material domains. In contrast, the
proposed method exhibits more stable cross-domain transfer, with a maximum
drop of only 11.3 percentage points (CFRP $\rightarrow$ Simulated) compared
to drops exceeding 20 percentage points reported in prior work \cite{zhang2020}.
We attribute this improved generalization to the disentangled representation
learning enabled by Component A, which separates material-invariant signal
features from material-specific noise patterns.

These comparisons confirm that the proposed method advances the state-of-the-art
across all evaluation dimensions, not merely on individual metrics.
```

**Key elements:**
- Comparison with specific prior work (MethodX, MethodY, MethodZ)
- Multi-dimensional comparison (SNR, accuracy, generalization)
- Quantitative gap statements with citations
- Explanation of why the method outperforms (architectural reasoning)

---

### File: 6-3-limitations.tex

```latex
paragraph{6.3 Limitations}

We acknowledge several limitations that constrain the generalizability and
applicability of our method.

\textbf{Data Availability.}
The proposed method requires sufficient training data to learn the
material-specific representations in Component A. In our experiments,
each dataset contained at least 5,000 samples with expert annotations.
For applications with limited labeled data (e.g., rare defect types with
few samples), the method's performance degrades. While cross-domain transfer
partially mitigates this issue, fine-tuning on target-domain data remains
necessary for optimal performance on small datasets. Future work should
investigate few-shot or zero-shot adaptation strategies.

\textbf{Computational Cost.}
Component A's architecture introduces additional computational overhead
compared to baseline methods. Inference time increases by approximately
15--20\% relative to MethodZ, though it remains within practical limits
for real-time industrial inspection ( $< 50$ ms per sample). Training
time is also longer due to the attention mechanism's iterative refinement.
This trade-off may not be acceptable for extremely latency-sensitive
applications where even the current inference time is prohibitive.

\textbf{Dataset Specificity.}
The datasets used in this study focus on specific defect types (delamination
and void detection) in aluminum and CFRP composites. The method's effectiveness
on other defect types (e.g., fiber breakage, matrix cracking) or other
material systems (e.g., titanium alloys, glass fiber composites) has not
been validated. The performance on such materials may differ substantially
due to different wave propagation characteristics and defect signatures.

\textbf{Evaluation Scope.}
All evaluations were conducted under controlled laboratory conditions.
Real-world industrial environments introduce additional factors not captured
in our datasets, including environmental noise, equipment calibration drift,
and operator variability. While the controlled results are promising,
industrial deployment studies are needed to validate real-world effectiveness.

These limitations do not invalidate the core contributions but define the
boundary conditions within which the reported performance should be interpreted.
```

**Key elements:**
- Four distinct limitation categories with specific scope
- Each limitation acknowledges what the method cannot do
- Suggests future work direction for each limitation
- Closing statement that contextualizes limitations vs. contributions

---

### File: 6-4-failure-cases.tex

```latex
paragraph{6.4 Failure Case Analysis}

Examining cases where the proposed method underperforms reveals systematic
patterns that inform both user expectations and future improvements.

\textbf{Edge Geometry Regions.}
The method shows degraded performance near specimen edges and corners,
where boundary reflections interfere with the inspection signal. Detection
accuracy in these regions drops by approximately 8--12 percentage points
compared to interior regions. This failure mode is attributable to the
assumption in Component A that the signal follows a spatially stationary
process, which does not hold near boundaries. Future work should incorporate
explicit boundary handling mechanisms.

\textbf{Sub-Threshold Defects.}
Defects with signal amplitudes below the detection threshold established
during training are frequently missed. While this is expected behavior for
any detection system, the specific sub-threshold characteristics matter:
defects that are small but have high contrast (sharp boundaries) are
detected more reliably than larger but diffuse defects with gradual
contrast transitions. This suggests that defect size and contrast interact
in ways not fully captured by the current SNR-based training objective.

\textbf{Domain Mismatch from Simulated Data.}
The weakest cross-domain transfer occurs when the model is trained on
simulated data and evaluated on physical measurements (Simulated $\rightarrow$
Aluminum: 83.7\%; Simulated $\rightarrow$ CFRP: 81.2\%). Analysis of failure
cases reveals systematic discrepancies between simulated and measured
wave propagation patterns, particularly in the higher frequency harmonics
where simulation accuracy is lower. This finding validates the continued
need for physics-based simulation improvements or domain adaptation
techniques.

\textbf{Attention Failure Cases.}
The Attention mechanism occasionally focuses on artifactual features
induced by surface roughness rather than genuine defect signals. These
false attention instances are more common on the aluminum dataset (which
has higher surface roughness variability) and lead to spurious detection
calls. While the overall precision remains high (90.2\% on aluminum),
these cases represent a systematic bias that could be addressed through
surface roughness normalization as a preprocessing step.

\textbf{Implications for Deployment.}
These failure patterns suggest that practitioners should:
(1) apply boundary exclusion zones during inspection planning;
(2) supplement automated detection with human review for suspected
    sub-threshold defects;
(3) prefer target-domain training data over simulated data when available;
(4) implement surface roughness estimation to flag cases where attention
    may be unreliable.
```

**Key elements:**
- Four distinct failure case categories
- Each failure case has specific quantified impact
- Architectural/mechanistic explanation for why failure occurs
- Actionable recommendations for practitioners
- Closing guidance for deployment

---

## Step 5: Elsevier LaTeX Requirements

### Section Structure

```latex
\section{Discussion}
\label{sec:discussion}

% 6.1 Interpretation
% 6.2 Comparison with Prior Work
% 6.3 Limitations
% 6.4 Failure Cases
```

### Citation Style

Use `\citeauthor{}` for text citations and `\cite{}` for parenthetical:
```latex
MethodX \citeauthor{methodx2022} achieves ...
This finding contradicts \cite{zhang2020}.
```

### Emphasis

Use `\textbf{}` for key findings, not asterisks or capitalization:
```latex
The \textbf{largest improvement} occurs on CFRP data.
```

---

## Step 6: Academic Voice Guidelines for Discussion

The Discussion section requires careful balance of confidence and hedging:

### Confident Statements (for clear results)
```latex
The proposed method achieves ...
This improvement is attributable to ...
These results confirm ...
```

### Hedged Statements (for interpretations)
```latex
The results suggest that ...
One possible explanation is ...
This pattern may indicate ...
```

### Limitation Acknowledgment (honest but not self-undermining)
```latex
A limitation of this approach is ...
This constraint may affect ...
Future work could address ...
```

---

## Step 7: Completion Report

After writing all paragraph files, report to user:

```
讨论章节写作完成。

覆盖内容：
- 6-1-interpretation.tex：结果解读（SNR提升机制、检测精度分析、消融实验洞察）
- 6-2-literature-comparison.tex：与 Prior Work 对比（SNR、精度、泛化能力）
- 6-3-limitations.tex：诚实局限性（数据可用性、计算成本、数据集特异性、评估范围）
- 6-4-failure-cases.tex：失败案例分析（边缘几何区域、亚阈值缺陷、领域不匹配、注意力失败）

关键洞察：
- Component A 是主要性能驱动因素（+4.4% accuracy）
- CFRP 数据集上改进最大（与材料特性相关）
- 跨域迁移在模拟→物理方向最弱

下一步：aw-write-conclusion — 撰写结论章节
```

---

## Edge Cases

### Results Disagree with Literature Claims

If results contradict literature expectations:
- Acknowledge the discrepancy directly
- Propose possible explanations
- Do not dismiss prior work; instead, highlight what is different in this study

### No Prior Work for Comparison

If the method addresses a novel problem with no direct baselines:
- Frame comparison around the closest related approaches
- Emphasize the absolute performance levels rather than relative
- Clearly define what constitutes "good" performance in this new domain

### Methodology Risks Materialized

If documented risks occurred during experiments (e.g., baseline didn't reproduce):
- Acknowledge in limitations or failure cases section
- Frame as limitation of evaluation rather than method flaw
- Propose mitigation for future evaluation

---

## Integration Points

| Input | Source | Description |
|-------|--------|-------------|
| Results | `sections/results.tex` or `sections/results/*.tex` | Key findings to interpret |
| Literature | `.planning/literature.md` | Prior work context |
| Methodology | `.planning/methodology.md` | Risks, limitations |

| Output | Destination | Consumed By |
|--------|-------------|-------------|
| 4 paragraph files | `sections/discussion/` | `aw-execute` (wave merger) |
| Discussion draft | `sections/discussion.tex` (via \input) | `aw-review` |

---

## File Locations

```
.planning/
├── literature.md               ← Input: prior work comparisons
└── methodology.md              ← Input: risks, limitations

manuscripts/[paper-name]/sections/discussion/
├── 6-1-interpretation.tex       ← Output
├── 6-2-literature-comparison.tex ← Output
├── 6-3-limitations.tex         ← Output
└── 6-4-failure-cases.tex        ← Output
```

---

## Usage Examples

- `/aw-write-discussion` — Run discussion writing after results approval
- (Auto-triggered by `aw-execute` during Phase 6 wave)
