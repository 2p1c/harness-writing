\subsection{Evaluation Metrics}
\label{sec:metrics}

Performance is assessed across three aspects: denoising fidelity, acoustic feature preservation, and defect detection capability. All metrics are computed per specimen and reported as mean $\pm$ standard deviation across the test set, with statistical significance assessed at $p < 0.05$.

\textbf{Denoising fidelity.} The primary metric is SNR improvement:
\begin{equation}
\Delta\text{SNR} = \text{SNR}_{\text{out}} - \text{SNR}_{\text{in}},
\end{equation}
where $\text{SNR}_{\text{in}}$ and $\text{SNR}_{\text{out}}$ are computed from the input--reference and denoised--reference signal pairs, respectively. Additionally, mean squared error (MSE) and normalized MSE (NMSE $= \| \hat{y} - y \|_2^2 / \| y \|_2^2$) quantify deviation from the high-averaging reference. Waveform similarity is evaluated using Lin's concordance correlation coefficient (CCC):
\begin{equation}
\text{CCC} = \frac{2\rho\sigma_{\hat{y}}\sigma_{y}}{\sigma_{\hat{y}}^2 + \sigma_{y}^2 + (\mu_{\hat{y}} - \mu_{y})^2},
\end{equation}
where $\mu$ and $\sigma$ denote mean and standard deviation, and $\rho$ is the Pearson correlation coefficient between the denoised output $\hat{y}$ and the reference $y$.

\textbf{Feature preservation.} Time-of-arrival (TOA) error is measured in samples as the argmax shift of the cross-correlation between $\hat{y}$ and $y$, converted to microseconds using the sampling period. Amplitude error is the relative peak error $|A_{\text{peak}}^{\hat{y}} - A_{\text{peak}}^{y}| / A_{\text{peak}}^{y} \times 100\%$, where peak amplitude is taken as the maximum absolute value within the gated waveform window. Waveform envelope similarity is evaluated as CCC computed on the Hilbert envelope of each signal, capturing morphology preservation independent of phase shifts.

\textbf{Defect detection.} For defect presence classification, F1-score is reported as the harmonic mean of precision and recall. Probability of detection (POD) curves are constructed by plotting detection probability versus known defect size (depth and diameter for flat-bottom holes), with the $50\%$ detection threshold reported as the minimum detectable defect size. Receiver operating characteristic (ROC) area under curve (AUC) quantifies the discriminative ability across all operating points.

\textbf{Statistical analysis.} Given the limited number of test specimens, statistical significance is assessed using the Wilcoxon signed-rank test (paired, two-sided) across specimens, with Holm--Bonferroni correction applied for multiple comparisons. A result is deemed significant when $p < 0.05$.
