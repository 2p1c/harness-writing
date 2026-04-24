# ROADMAP — Physics-Constrained Multi-Domain Fusion Denoising Paper

**Project**: physics-constrained-multi-domain-denoising
**Target Journal**: Measurement (Elsevier)
**Total Target**: ~8000 words main text + up to 8 figures

---

## Phase 1: Introduction

**Word target**: 1500 words
**Figures**: Fig. 1 — Laser Ultrasonic Acquisition System schematic

### Tasks

1. [ ] Write problem statement: laser ultrasound advantages and noise/averaging challenges
2. [ ] Write motivation: why signal averaging is insufficient (surface damage, efficiency limits)
3. [ ] Write research question: multi-domain fusion denoising under reduced averaging
4. [ ] Write novelty/contributions list
5. [ ] Write paper outline roadmap sentence
6. [ ] Write Phase 1 — Introduction section in `sections/intro/`

### Success Criteria
- [ ] Research question clearly stated
- [ ] Novelty claims explicitly enumerated
- [ ] Structure of remaining sections previewed
- [ ] Fig. 1 schematic drafted

---

## Phase 2: Related Work

**Word target**: ~1200 words

### Tasks

1. [ ] Write Section 2 — Related Work header
2. [ ] Write 2.1 — Laser Ultrasonic NDT Fundamentals
3. [ ] Write 2.2 — Deep Learning for Ultrasonic/LU Denoising
4. [ ] Write 2.3 — Multi-Domain Signal Processing
5. [ ] Write 2.4 — Physics-Informed Neural Networks
6. [ ] Write 2.5 — Conventional Denoising Baselines
7. [ ] Write gap synthesis paragraph transitioning to methodology
8. [ ] Build references.bib entries for all cited works

### Success Criteria
- [ ] All key references cited
- [ ] Research gaps explicitly identified
- [ ] Clear positioning of this work vs. existing methods

---

## Phase 3: Methodology

**Word target**: 2500 words
**Figures**: Fig. 2 — PMDF-Net Architecture; Fig. 3 — Training pipeline

### Tasks

1. [ ] Write Section 3 — Methodology
2. [ ] Write 3.1 — Dataset Description (paired data: limited avg → high avg)
3. [ ] Write 3.2 — Signal Preprocessing
4. [ ] Write 3.3 — Network Architecture (PMDF-Net)
   - Time-domain branch
   - Time-frequency branch
   - Encoder-decoder structure
   - Multi-domain fusion module
5. [ ] Write 3.4 — Physics-Constrained Loss Function
6. [ ] Write 3.5 — Training Scheme
7. [ ] Write 3.6 — Inference Pipeline
8. [ ] Write 3.7 — Baseline Methods
9. [ ] Write 3.8 — Evaluation Metrics

### Success Criteria
- [ ] Network architecture reproducible from description
- [ ] Loss function weights justified
- [ ] All hyperparameters specified
- [ ] Fig. 2 shows dual-branch encoder-decoder architecture

---

## Phase 4: Experiment

**Word target**: ~800 words
**Figures**: Fig. 4 — Denoising examples; Fig. 5 — SNR comparison

### Tasks

1. [ ] Write experimental setup description
2. [ ] Describe test sets (intact training → defect testing)
3. [ ] Confirm baseline implementations
4. [ ] Write statistical analysis protocol
5. [ ] Write ablation study protocol
6. [ ] Generate or describe Fig. 4

### Success Criteria
- [ ] All test conditions described
- [ ] Statistical significance protocol complete
- [ ] Ablation matrix fully specified

---

## Phase 5: Results

**Word target**: 2000 words
**Figures**: Fig. 6 (Al results), Fig. 7 (CFRP results), Fig. 8 (generalization), Fig. 9 (defect detection)

### Tasks

1. [ ] Write Section 4 — Results
2. [ ] Write 4.1 — Denoising Performance (SNR improvement, feature preservation)
3. [ ] Write 4.2 — Experimental Results on Defect Specimens
4. [ ] Write 4.3 — Cross-Domain Generalization Analysis
5. [ ] Write 4.4 — Defect Detection Enhancement
6. [ ] Write 4.5 — Ablation Study Results

### Success Criteria
- [ ] All metrics reported with statistical significance
- [ ] Generalization gap quantified
- [ ] Defect detection improvement demonstrated

---

## Phase 6: Discussion

**Word target**: 1500 words
**Figures**: Fig. 10 (ablation detail)

### Tasks

1. [ ] Write Section 5 — Discussion
2. [ ] Write 5.1 — Interpretation of Main Results
3. [ ] Write 5.2 — Multi-Domain Fusion Benefits
4. [ ] Write 5.3 — Physics Constraints Analysis
5. [ ] Write 5.4 — Reduced Averaging Impact
6. [ ] Write 5.5 — Limitations
7. [ ] Write 5.6 — Future Work

### Success Criteria
- [ ] All hypotheses addressed
- [ ] Limitations acknowledged
- [ ] Future work specific

---

## Phase 7: Conclusion

**Word target**: 500 words

### Tasks

1. [ ] Write Section 6 — Conclusion
2. [ ] Write 6.1 — Summary of Contributions
3. [ ] Write 6.2 — Key Findings
4. [ ] Write 6.3 — Limitations and Future Work
5. [ ] Write Abstract (250 words)
6. [ ] Final references pass

### Success Criteria
- [ ] Abstract reads as standalone 250-word summary
- [ ] All novelty claims addressed
- [ ] Limitations explicitly stated

---

## Supplementary Materials

- [ ] Trained model weights and inference code
- [ ] Additional denoising examples
- [ ] Network structure detail from Feishu document
