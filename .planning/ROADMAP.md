# ROADMAP — Laser Ultrasound Denoising Paper

**Project**: U-Net Based Denoising of Laser Ultrasound Signals for NDT
**Target Journal**: Ultrasonics / NDT&E International (Elsevier)
**Total Target**: 8000 words main text + up to 12 figures

---

## Phase 1: Introduction

**Word target**: 1500 words
**Figure**: Fig. 1 — Laser Ultrasound Acquisition System schematic

### Tasks

1. [ ] Write problem statement: laser ultrasound NDT advantages and noise challenge
2. [ ] Write motivation: why conventional DSP methods are insufficient for low-SNR scenarios
3. [ ] Write research question and hypothesis (from research-brief.json)
4. [ ] Write novelty/contributions list (4 claims from research-brief.json)
5. [ ] Write paper outline roadmap sentence
6. [ ] Write Phase 1 — Introduction section in `sections/introduction.tex`

### Success Criteria
- [ ] Research question clearly stated
- [ ] 4 novelty claims explicitly enumerated
- [ ] Hypothesis stated as testable claim
- [ ] Structure of remaining sections previewed
- [ ] Fig. 1 schematic drafted (acquisition setup, DAQ chain, laser specs)

---

## Phase 2: Related Work

**Word target**: ~1200 words
**Figures**: Table 1 (method comparison matrix) optional

### Tasks

1. [ ] Write Section 2 — Related Work header
2. [ ] Write 2.1 — Laser Ultrasonic NDT Fundamentals (Kou 2021, Luo 2026)
3. [ ] Write 2.2 — Deep Learning for Ultrasonic NDT (Zhang 2020, Liu 2022)
4. [ ] Write 2.3 — CNN Architectures for Signal Denoising (DnCNN, residual learning)
5. [ ] Write 2.4 — Conventional Denoising Baselines (Wiener, DWT, BM3D, sparse coding)
6. [ ] Write gap synthesis paragraph transitioning to methodology
7. [ ] Build references.bib entries for all cited works

### Success Criteria
- [ ] All 7 key references cited with correct journal/volume/page
- [ ] Research gaps explicitly identified (cross-domain generalization, signal preservation trade-off)
- [ ] Clear positioning: this work is about denoising, not defect detection
- [ ] BM3D identified as primary conventional baseline

---

## Phase 3: Methodology

**Word target**: 2500 words
**Figures**: Fig. 2 — Network architecture diagram; Fig. 3 — Training pipeline

### Tasks

1. [ ] Write Section 3 — Methodology
2. [ ] Write 3.1 — Dataset Description
   - [ ] FEM simulation: COMSOL, 10,000+ pairs, Al 2024-T3 (60%) + CFRP (40%)
   - [ ] SNR range: -10 dB to +20 dB; defect types: FBH, SDH, delamination, fiber breakage
   - [ ] Validation: 1,000 held-out pairs (stratified)
3. [ ] Write 3.2 — Signal Preprocessing
   - [ ] 100 MHz sampling, Hanning window, min-max normalization to [-1,+1]
   - [ ] AWGN injection at target SNR, 512-sample windows with 256-sample overlap
   - [ ] Frequency bandpass: 0.1-20 MHz
4. [ ] Write 3.3 — Network Architecture (U-Net encoder-decoder)
   - [ ] Table with layer dimensions (Enc1-4, Bottleneck, Dec4-1, Output)
   - [ ] Residual skip connections, attention gating, He_normal init, Tanh output
   - [ ] Parameter count summary
5. [ ] Write 3.4 — Loss Function
   - [ ] L_total = 0.5*L_MSE + 0.3*L_CCC + 0.2*L_SSIM with formulas
   - [ ] Ablation variants: MSE-only, MSE+CCC, Full mixed loss
6. [ ] Write 3.5 — Training Scheme
   - [ ] Adam optimizer, lr=1e-4 with cosine annealing, batch_size=64, epochs=200+
   - [ ] Early stopping on validation loss, dropout 0.1-0.3, weight decay 1e-5
   - [ ] 5-seed averaging (seeds: 42, 123, 456, 789, 1024)
7. [ ] Write 3.6 — Inference Pipeline
   - [ ] Sliding window (512-sample, 64-sample stride), overlap-add reconstruction
8. [ ] Write 3.7 — Baseline Methods (with configurations from methodology.md Table)
9. [ ] Write 3.8 — Evaluation Metrics
   - [ ] SNR improvement, MSE, CCC, WSI, F1-score at -5 dB, POD curves

### Success Criteria
- [ ] Network architecture reproducible from description
- [ ] Loss function weights justified (signal preservation over pure SNR)
- [ ] All hyperparameters specified (no missing values)
- [ ] Fig. 2 diagram shows encoder-decoder with skip connections and attention gates
- [ ] Fig. 3 flowchart shows full training pipeline

---

## Phase 4: Experiment

**Word target**: ~800 words
**Figures**: Fig. 4 — Simulated denoising examples; Fig. 7 SNR comparison

### Tasks

1. [ ] Write experimental setup description
2. [ ] Write test set descriptions (Sim-test, Al-exp, CFRP-exp with signal counts and SNR ranges)
3. [ ] Confirm all 5 baseline methods implemented with tuned parameters
4. [ ] Write statistical analysis protocol
   - [ ] 5-seed mean and std reported
   - [ ] Paired Wilcoxon signed-rank test (p < 0.05)
   - [ ] Bonferroni correction for 5 comparisons
   - [ ] 95% CI via bootstrap (1000 iterations)
5. [ ] Write ablation study protocol (A1-A6 from methodology.md)
6. [ ] Generate or describe generation of Fig. 4 simulated denoising examples

### Success Criteria
- [ ] All test sets described with exact signal counts and SNR distributions
- [ ] Statistical significance protocol complete (test type, correction, CI method)
- [ ] Ablation matrix A1-A6 fully specified before experiments run
- [ ] Fig. 4 ready (noisy/clean/denoised triplets at -5, 0, +10 dB)

---

## Phase 5: Results

**Word target**: 2000 words
**Figures**: Fig. 5 (Al experimental), Fig. 6 (CFRP experimental), Fig. 7 (SNR comparison), Fig. 8 (generalization), Fig. 9 (F1/POD), Fig. 12 (summary table)

### Tasks

1. [ ] Write Section 4 — Results
2. [ ] Write 4.1 — Simulated Test Set Performance
   - [ ] SNR improvement per method across SNR levels (-10 to +20 dB)
   - [ ] MSE to clean reference
   - [ ] CCC and WSI preservation metrics
3. [ ] Write 4.2 — Experimental Aluminum Specimen
   - [ ] Denoised A-scans with annotated FBH defect echoes (depths: 3, 5, 8 mm)
   - [ ] Comparison vs. BM3D overlaid
4. [ ] Write 4.3 — Experimental CFRP Specimen
   - [ ] Denoised A-scans with delamination and fiber breakage markers
   - [ ] Anisotropic wave propagation effects visible
5. [ ] Write 4.4 — Cross-Domain Generalization
   - [ ] Sim-to-Al vs. Sim-to-CFRP performance gap
   - [ ] 3 dB degradation threshold analysis
6. [ ] Write 4.5 — Defect Detection Performance
   - [ ] F1-score vs. SNR curves (Fig. 9a)
   - [ ] POD curves with 95% CI for Al and CFRP (Fig. 9b)
7. [ ] Write 4.6 — Ablation Study Results
   - [ ] Grouped bar charts: SNR improvement vs. ablation variant A1-A6
   - [ ] CCC comparison across ablation variants
8. [ ] Write Fig. 12 — Summary table of all quantitative results

### Success Criteria
- [ ] All 6 test conditions reported with mean +/- std over 5 seeds
- [ ] Statistical significance vs. all 5 baselines clearly marked
- [ ] Generalization gap quantified in dB for both experimental materials
- [ ] F1-score at -5 dB reported (target: > 0.82)
- [ ] POD slope reported (target: > 2.5 dB^-1)

---

## Phase 6: Discussion

**Word target**: 1500 words
**Figures**: Fig. 10 (ablation detail), Fig. 11 (failure case analysis)

### Tasks

1. [ ] Write Section 5 — Discussion
2. [ ] Write 5.1 — Interpretation of Main Results
   - [ ] Why U-Net outperforms conventional methods (feature learning vs. hand-crafted filters)
   - [ ] Role of mixed loss in preserving waveform morphology vs. MSE-only
3. [ ] Write 5.2 — Cross-Domain Generalization Analysis
   - [ ] Sim-to-CFRP gap larger than Sim-to-Al explained (anisotropic heterogeneity)
   - [ ] Colored/structured noise in experimental data vs. AWGN assumption
   - [ ] Potential domain adaptation strategies (future work)
4. [ ] Write 5.3 — Loss Function Trade-offs
   - [ ] MSE-only tends to over-smooth; mixed loss maintains arrival times and amplitudes
   - [ ] CCC term ensures morphology preservation independent of scale
   - [ ] SSIM term prevents excessive local smoothing of defect echoes
5. [ ] Write 5.4 — Ablation Insights
   - [ ] Architecture depth: 4-level optimal; 3-level underfits; 5-level overfits
   - [ ] Attention gates: +1-2 dB on experimental data, more on CFRP
   - [ ] Uniform SNR distribution preferred over fixed +10 dB
6. [ ] Write 5.5 — Limitations
   - [ ] AWGN noise model limitation and implications
   - [ ] Sim-to-real gap from FEM plasma effects, surface roughness, coupling variability
   - [ ] Material specificity: degraded performance outside Al/CFRP training distribution
   - [ ] Black-box interpretability challenges
7. [ ] Write 5.6 — Failure Cases (Fig. 11)
   - [ ] Over-smoothing at very low SNR (-10 dB)
   - [ ] Edge artifacts from Hanning windowing
   - [ ] CFRP anisotropic mode conversion misinterpreted as noise

### Success Criteria
- [ ] All hypotheses addressed with evidence from results
- [ ] Limitations acknowledged honestly (not dismissed)
- [ ] Failure cases documented with specific examples
- [ ] Future work directions grounded in specific gaps identified

---

## Phase 7: Conclusion

**Word target**: 500 words
**Figures**: None (or condensed summary figure)

### Tasks

1. [ ] Write Section 6 — Conclusion
2. [ ] Write 6.1 — Summary of Contributions
   - [ ] Restate problem: DL-based laser US denoising for NDT
   - [ ] Method: U-Net with mixed loss (MSE+CCC+SSIM)
   - [ ] Key results: SNR improvement, waveform preservation, generalization behavior
3. [ ] Write 6.2 — Key Findings
   - [ ] Quantitative summary (SNR: 10-14 dB improvement; CCC: >0.96)
   - [ ] Generalization: < 3 dB Al, < 4 dB CFRP degradation
   - [ ] Ablation: mixed loss critical for defect-feature preservation
4. [ ] Write 6.3 — Limitations and Future Work
   - [ ] Address noise model generalization, domain adaptation, materials outside training
   - [ ] Interpretability improvements via attention visualization
5. [ ] Write Abstract (250 words) — written last, placed at top
6. [ ] Final references pass — verify all 7 key refs and any additional citations

### Success Criteria
- [ ] Abstract reads as standalone 250-word summary
- [ ] All novelty claims addressed in conclusion
- [ ] Limitations not buried — explicitly stated
- [ ] Future work specific (not generic "more research needed")

---

## Supplementary Materials

- [ ] GitHub repository with trained model weights and inference code
- [ ] Additional denoising examples at extreme SNR levels
- [ ] Sensitivity analysis tables (noise type variation, window size ablation)
- [ ] Full hyperparameter tables for all baseline methods
- [ ] Attention gate activation visualizations for interpretability
