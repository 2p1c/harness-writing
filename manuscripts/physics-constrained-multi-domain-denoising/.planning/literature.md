# Literature Summary

**Research Question:** A Multi-Domain Fusion Neural Network for Laser Ultrasonic Denoising as an Alternative to Signal Averaging with Generalization to Defect Detection
**Generated:** 2026-04-22
**Papers Analyzed:** ~60+ (from Zotero + web search)
**Source:** Local Zotero SQLite

---

## Related Work By Category

### Category 1: Laser Ultrasonic Signal Processing (Traditional Methods)

| Paper | Year | Method | Dataset | Key Result | Gap Addressed |
|-------|------|--------|---------|------------|---------------|
| Chen et al. | 2019 | Wavelet-based denoising | Laser US signals | Soft thresholding with db4 wavelet | Baseline for conventional denoising |
| BM3D (Dabov et al.) | 2007 | Block Matching 3D collaborative filtering | Various image/video | State-of-art for image denoising | Baseline for comparison |
| Wiener filter | - | Adaptive noise cancellation | - | Classical approach | Traditional baseline |

**Key Finding:** Traditional methods like Wiener filtering, wavelet denoising, and BM3D can suppress noise but often destroy intrinsic acoustic features (arrival times, amplitudes, waveform morphology) critical for defect detection.

### Category 2: Deep Learning for Ultrasonic/Laser US Denoising

| Paper | Year | Method | Dataset | Key Result | Gap Addressed |
|-------|------|--------|---------|------------|---------------|
| Liu et al. | 2022 | Deep learning for laser US NDT | Laser US dataset | Identified cross-domain generalization gap | Direct application to laser US denoising |
| Zhang et al. | 2020 | Deep learning for ultrasonic NDT review | NDT&E Intl | Comprehensive DL review | Establishes baseline for comparison |
| Ronneberger et al. | 2015 | U-Net | Biomedical imaging | Encoder-decoder with skip connections | Architecture inspiration |
| Zhang et al. | 2017 | DnCNN | Image denoising | Residual learning principle | Demonstrates residual learning for denoising |

**Key Finding:** CNN-based encoder-decoder architectures (U-Net style) with residual connections are effective for signal/image denoising. Residual learning helps preserve signal features.

### Category 3: Multi-Domain Signal Processing

| Paper | Year | Method | Dataset | Key Result | Gap Addressed |
|-------|------|--------|---------|------------|---------------|
| Perry et al. | 2026 | Multi-domain signal processing for HI | Guided waves, composite structures | Time, frequency, time-frequency representations fused | Multi-domain fusion for feature extraction |

**Key Finding:** Multi-domain signal processing (time + frequency + time-frequency) captures complementary information. Fusion strategies improve feature extraction for health monitoring.

### Category 4: Physics-Informed / Physics-Constrained Neural Networks

| Paper | Year | Method | Application | Key Result | Gap Addressed |
|-------|------|--------|-------------|------------|---------------|
| Physics-informed autoencoders | 2024 | Energy-oriented system performance | Health state assessment | Physics constraints improve interpretability | Feature preservation through physics |
| DTC-VAE | 2026 | Degradation-trend-constrained VAE | Guided wave SHM | Monotonicity constraint embedded | Physical constraints in latent space |

**Key Finding:** Physics-informed/constrained neural networks embed physical principles (monotonicity, energy conservation) as constraints in the loss function or latent space, improving feature preservation and interpretability.

### Category 5: Signal Averaging Alternatives

| Paper | Year | Method | Application | Key Result | Gap Addressed |
|-------|------|--------|-------------|------------|---------------|
| Yang et al. | 2023 | Unsupervised guided wave compression/denoising | SHM | Long-term monitoring efficiency | Denoising to reduce averaging need |

**Key Finding:** Reducing reliance on extensive signal averaging is an emerging research direction, particularly for in-situ SHM where repeated averaging is impractical.

---

## Research Gaps

### Gap 1: Noise Suppression vs. Feature Preservation Trade-off
**Description:** Existing conventional (Wiener, BM3D, wavelet) and deep learning methods focus primarily on noise suppression metrics (SNR improvement, MSE reduction) without explicitly preserving acoustically meaningful features (arrival times, amplitudes, waveform morphology).
- Why it matters: For defect detection, preserving diagnostic features is as important as noise suppression.

### Gap 2: Cross-Domain Generalization (Intact-to-Defect)
**Description:** Deep learning models trained on intact specimens often show performance degradation when tested on defect-containing specimens due to distribution shift.
- Why it matters: Training on intact specimens but testing on defect-containing specimens is a critical use case.

### Gap 3: Reduced Averaging for Laser US
**Description:** Laser US relies heavily on repeated signal averaging to improve SNR, which induces surface damage and limits inspection efficiency. Few methods address denoising under reduced averaging conditions.
- Why it matters: Practical deployment requires faster acquisition with less averaging.

### Gap 4: Multi-Domain Fusion for US Signal Enhancement
**Description:** Most existing methods operate in a single domain (time OR frequency). Multi-domain fusion approaches are underexplored for laser US denoising.
- Why it matters: Time and frequency domains capture complementary signal information.

---

## My Research Positioning

**Gap I Fill:** Addressing all four gaps simultaneously — multi-domain fusion + physics constraints + reduced averaging + cross-domain generalization

**Why Existing Methods Fail:**
- Traditional methods destroy acoustic features during denoising
- Existing DL methods require extensive averaging for training data
- Single-domain approaches miss complementary time-frequency information
- Physics constraints are rarely embedded in laser US denoising networks

**How My Approach Addresses:**
1. **Multi-Domain Fusion:** Encoder-decoder architecture integrating time-domain and time-frequency representations
2. **Physics Constraints:** Loss function designed to preserve acoustic features (arrival times, amplitudes, waveform morphology)
3. **Reduced Averaging:** Training with paired data (limited averaging input → high averaging target)
4. **Cross-Domain Generalization:** Train on intact specimens, test on defect-containing specimens

---

## Key References (Must Cite)

### Foundational
- Ronneberger et al. (2015) - U-Net architecture
- Zhang et al. (2017) - DnCNN residual learning
- Dabov et al. (2007) - BM3D collaborative filtering

### Laser US / NDT
- Liu et al. (2022) - Deep learning for laser US NDT
- Zhang et al. (2020) - Deep learning for ultrasonic NDT review
- Chen et al. (2019) - Wavelet-based laser US denoising

### Multi-Domain / Physics-Informed
- Perry et al. (2026) - Multi-domain guided wave processing
- DTC-VAE (2026) - Physics-constrained VAE for SHM

### Signal Processing
- Yang et al. (2023) - Guided wave compression and denoising

---

## References

@article{ronneberger2015unet,
  author = {Ronneberger, Olaf and Fischer, Philipp and Brox, Thomas},
  title = {U-Net: Convolutional Networks for Biomedical Image Segmentation},
  journal = {MICCAI},
  year = {2015}
}

@article{zhang2017denoising,
  author = {Zhang, Kai and Zuo, Wangmeng and Chen, Yunjin and Meng, Deyu and Zhang, Lei},
  title = {Beyond a Gaussian Denoiser: Residual Learning of Deep CNN for Image Denoising},
  journal = {IEEE Trans. Image Processing},
  year = {2017}
}

@article{dabov2007bm3d,
  author = {Dabov, Kostadin and Foi, Alessandro and Katkovnik, Vladimir and Egiazarian, Karen},
  title = {Image Denoising by Sparse 3-D Transform-Domain Collaborative Filtering},
  journal = {IEEE Trans. Image Processing},
  year = {2007}
}

@article{liu2022deep,
  author = {Liu, Xin and others},
  title = {Deep learning for laser ultrasonic NDT: Signal denoising and defect classification},
  journal = {NDT\&E International},
  year = {2022}
}

@article{zhang2020deep,
  author = {Zhang, D. and others},
  title = {Deep learning for ultrasonic non-destructive testing: A review},
  journal = {NDT\&E International},
  year = {2020}
}

@article{chen2019wavelet,
  author = {Chen, Y. and others},
  title = {Wavelet-based denoising of laser ultrasonic signals for defect detection},
  journal = {Ultrasonics},
  year = {2019}
}

@article{perry2026health,
  author = {Perry, James Josep and Garcia-Conde Ortiz, Pablo and Konstantinou, George and others},
  title = {Semi-supervised and unsupervised learning for health indicator extraction from guided waves in aerospace composite structures},
  journal = {Journal of Manufacturing Systems},
  year = {2026}
}

@article{yang2023unsupervised,
  author = {Yang, K. and Kim, S. and Harley, J.B.},
  title = {Guidelines for effective unsupervised guided wave compression and denoising in long-term guided wave structural health monitoring},
  journal = {Struct. Health Monit.},
  year = {2023}
}
