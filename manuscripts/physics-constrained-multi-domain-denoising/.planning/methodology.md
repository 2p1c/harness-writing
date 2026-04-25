# Methodology Design

**Generated:** 2026-04-22
**Based on:** research-brief.json (physics-constrained multi-domain fusion denoising)

---

## 1. Technical Pipeline

### 1.1 Method Overview

**Problem & Motivation:**
Laser ultrasonic testing offers non-contact inspection capability, but practical deployment suffers from low signal-to-noise ratio (SNR), signal inconsistency, and dependence on repeated signal averaging. While averaging improves SNR, it requires prolonged laser exposure that can induce surface damage and reduces inspection efficiency. Beyond noise suppression, preserving intrinsic acoustic features (arrival times, amplitudes, waveform morphology) is critical for reliable defect interpretation.

**High-Level Approach:**
This work proposes a Physics-constrained Multi-Domain Fusion Network (PMDF-Net) for laser ultrasonic signal denoising. The network processes signals through parallel time-domain and time-frequency branches within an encoder-decoder framework. Unlike previous approaches that require extensive averaging for training data, this method uses paired datasets where limited-averaging signals serve as inputs and high-averaging signals serve as reference targets, learning a mapping from low-quality to high-fidelity ultrasonic responses.

**Why This Works:**
Multi-domain fusion captures complementary information: time-domain features preserve precise arrival timing while time-frequency representations capture spectral content of acoustic events. Physics constraints in the loss function enforce acoustic feature preservation, ensuring that diagnostic waveform characteristics remain detectable after denoising.

### 1.2 Training Pipeline

```
Intact Aluminum Plate
       |
       ▼
Limited Averaging Acquisition (N shots) → Input
High Averaging Acquisition (M shots, M>>N) → Reference Target
       |
       ▼
Signal Preprocessing (normalization, windowing)
       |
       ▼
PMDF-Net Training (paired loss: time-domain + time-frequency)
       |
       ▼
Validation → Early stopping
       |
       ▼
Generalization Test on Defect Specimens
```

### 1.3 Inference Pipeline

```
Raw Signal (single-pulse or limited averaging)
       |
       ▼
Preprocessing (same as training)
       |
       ▼
PMDF-Net Inference (time-domain branch)
       |
       ▼
PMDF-Net Inference (time-frequency branch)
       |
       ▼
Domain Fusion → Final Denoised Output
```

---

## 2. Network Architecture

### 2.1 Architecture Overview

**Note:** Detailed network parameters (e.g., number of layers, channel dimensions) should be extracted from the Feishu document: https://jcnqxvnfi5o2.feishu.cn/wiki/MsAtwXP92iRSVFkdxqBcXGWfnGf

The architecture follows an encoder-decoder structure with two parallel branches:

```
Input Signal (1D)
       │
       ├──→ Time-Domain Encoder ─→ Bottleneck ─→ Time-Domain Decoder ──┐
       │                                                              │
       │                      (concatenation at each level)            │
       │                                                              ▼
       ├──→ Time-Frequency Encoder ─→ Bottleneck ─→ Time-Frequency Decoder ─┤
       │                                                              │
       ▼                                                              ▼
              Multi-Domain Fusion Module → Output (Denoised Signal)
```

### 2.2 Architecture Components

1. **Time-Domain Branch:**
   - **Purpose:** Process raw signal waveform to capture arrival times, amplitudes, and temporal morphology
   - **Technical Detail:** 1D convolutional layers with progressive downsampling/upsampling
   - **Justification:** Preserves precise timing information critical for defect localization

2. **Time-Frequency Branch:**
   - **Purpose:** Extract spectral features via Short-Time Fourier Transform (STFT) or Continuous Wavelet Transform (CWT)
   - **Technical Detail:** Parallel branch processing time-frequency representation
   - **Justification:** Captures frequency content of acoustic events; complementary to time-domain

3. **Encoder-Decoder with Skip Connections:**
   - **Purpose:** Multi-scale feature extraction with high-resolution detail preservation
   - **Technical Detail:** Skip connections at corresponding resolutions between encoder and decoder
   - **Justification:** Standard for U-Net style architectures; proven effective for signal denoising

4. **Multi-Domain Fusion Module:**
   - **Purpose:** Combine time-domain and time-frequency branch outputs
   - **Technical Detail:** Concatenation + learnable fusion weights
   - **Justification:** Late fusion allows each domain to learn independently before combining

5. **Physics-Constrained Loss Function:**
   - **Purpose:** Enforce acoustic feature preservation during training
   - **Technical Detail:** Combined loss: L = α·L_MSE + β·L_feature + γ·L_structure
   - **Justification:** MSE alone optimizes SNR but may destroy diagnostic features; physics constraints maintain waveform morphology

---

## 3. Experiment Design

### 3.1 Datasets

| Dataset | Description | Split | Justification |
|---------|-------------|-------|---------------|
| Intact Al training | Paired data from intact aluminum plates | 80/10/10 | Training: input (limited avg) → target (high avg) |
| Al-defect test | Aluminum specimens with known defects (FBH) | Held-out | Test generalization to defect detection |
| CFRP-defect test | CFRP laminates with delamination/fiber breakage | Held-out | Test cross-material generalization |

**Pairing Protocol:**
- Input: N-shot averaged signal (N = 1, 2, 4, or 8)
- Target: M-shot averaged signal (M ≥ 64, M >> N)
- Multiple SNR levels: -10 dB to +20 dB variation through natural measurement variability

### 3.2 Baseline Methods

| Baseline | Source | Justification |
|----------|--------|---------------|
| Signal averaging (N vs M shots) | Industry standard | Primary comparison — method we aim to replace |
| Wiener filter | Classical | Standard adaptive filtering |
| BM3D | Dabov et al. (2007) | State-of-art conventional denoising |
| DWT denoising | Chen et al. (2019) | Laser US-specific baseline |
| Single-domain CNN | Liu et al. (2022) | Deep learning baseline without multi-domain fusion |

### 3.3 Evaluation Metrics

| Metric | Definition | Why Selected |
|--------|------------|--------------|
| SNR improvement | ΔSNR = SNR_denoised - SNR_input | Primary denoising metric; directly comparable to averaging |
| Acoustic feature preservation index | Cross-correlation of arrival times, amplitude ratios | Physics-informed: ensures diagnostic features remain |
| Waveform similarity index | CCC (Lin's concordance correlation coefficient) | Measures morphology preservation independent of scale |
| Defect visibility enhancement | Qualitative assessment + quantitative F1 | End-use metric: defects must remain detectable |
| Inspection efficiency gain | Time reduction vs. full averaging | Practical metric: captures real-world benefit |

### 3.4 Ablation Studies

| Ablation | Expected Impact | Rationale |
|----------|-----------------|------------|
| Remove time-frequency branch | SNR similar, feature preservation ↓ | Single-domain misses spectral information |
| Remove physics constraints | SNR ↑, feature preservation ↓ | MSE optimizes noise removal at cost of features |
| Vary input averaging N | Performance degrades as N decreases | Trade-off: less averaging = harder denoising |
| Train on intact, test on defect | SNR degradation < 3 dB expected | Critical for practical deployment |

---

## 4. Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Cross-domain generalization gap (intact → defect) | High | High | Train with diverse defect scenarios; use physics constraints |
| Feature preservation vs. noise suppression trade-off | Medium | High | Monitor both SNR and CCC during training |
| Limited training data variety | Medium | Medium | Augmentation: SNR jitter, time-shift, amplitude scaling |
| Baseline implementation suboptimal | Low | Low | Use published code/parameters; grid-search if needed |

**Overall Risk Level:** Medium

---

## 5. Expected Results

### Main Metric Predictions

- **SNR improvement:** Target 8-12 dB over limited-averaging inputs
- **Efficiency gain:** Achieve comparable SNR to 64-shot averaging using only 4-shot inputs
- **Feature preservation CCC:** Target > 0.95 (vs. ~0.85 for MSE-only training)
- **Defect visibility:** Defect-related features remain detectable after denoising

### Potential Negative Results

- If cross-domain performance degrades significantly: Investigate noise characteristics difference between intact and defect specimens
- If feature preservation metric is low: Increase weight of physics constraint term in loss function

---

## 6. Figures Needed

| Figure | Title | Content |
|--------|-------|---------|
| Fig. 1 | Laser Ultrasonic Acquisition System | Pump-probe setup schematic |
| Fig. 2 | PMDF-Net Architecture | Encoder-decoder with dual branches |
| Fig. 3 | Training Results | Loss curves, SNR improvement over epochs |
| Fig. 4 | Denoising Examples | Before/after at different SNR levels |
| Fig. 5 | Defect Specimen Results | Denoised signals with defect features marked |
| Fig. 6 | SNR Improvement Comparison | Proposed vs. baselines |
| Fig. 7 | Feature Preservation Analysis | CCC, arrival time accuracy |
| Fig. 8 | Ablation Study | Effect of removing branches/constraints |

---

## 7. Key Innovations

1. **Multi-Domain Fusion Architecture** — Unlike single-domain methods, this approach simultaneously processes time-domain and time-frequency representations, capturing complementary acoustic information.

2. **Physics-Constrained Training** — Loss function includes terms for acoustic feature preservation (arrival time, amplitude, waveform morphology), ensuring denoised signals remain diagnostically useful.

3. **Reduced Averaging Training Protocol** — Training with limited-averaging → high-averaging pairs enables deployment in low-averaging scenarios, directly addressing the surface damage and efficiency limitations of conventional averaging.

4. **Cross-Domain Generalization Framework** — Train on intact specimens, test on defect-containing specimens to validate practical deployment capability.
