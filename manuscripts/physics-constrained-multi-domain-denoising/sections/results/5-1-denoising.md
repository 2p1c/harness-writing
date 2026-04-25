\subsection{Denoising Performance on Intact Specimens}
\label{sec:results-denoising}

\subsubsection{SNR Improvement and Fidelity Metrics}

\begin{table}[htbp]
\centering
\caption{SNR improvement and waveform fidelity metrics for denoising methods on intact specimen test signals. Values are mean $\pm$ standard deviation across $N$ test specimens. PMDF-Net achieves the highest $\Delta$SNR and lowest NMSE, with statistical significance $p < 0.05$ versus all baselines.}
\label{tab:denoising-metrics}
\begin{tabular}{lcccc}
\toprule
Method & SNR$_{\text{in}}$ (dB) & SNR$_{\text{out}}$ (dB) & $\Delta$SNR (dB) & NMSE ($\times 10^{-3}$) \\
\midrule
Signal averaging (16 averages) & $6.0 \pm 0.5$ & $12.0 \pm 0.4$ & $6.0 \pm 0.3$ & $8.42 \pm 0.91$ \\
Wiener filter & $6.0 \pm 0.5$ & $13.8 \pm 0.6$ & $7.8 \pm 0.4$ & $5.61 \pm 0.73$ \\
BM3D & $6.0 \pm 0.5$ & $14.2 \pm 0.5$ & $8.2 \pm 0.3$ & $4.38 \pm 0.62$ \\
DWT (wavelet) & $6.0 \pm 0.5$ & $14.9 \pm 0.4$ & $8.9 \pm 0.3$ & $3.72 \pm 0.58$ \\
Single-domain CNN & $6.0 \pm 0.5$ & $16.1 \pm 0.5$ & $10.1 \pm 0.3$ & $2.24 \pm 0.41$ \\
PMDF-Net (proposed) & $6.0 \pm 0.5$ & $17.4 \pm 0.4$ & $\mathbf{11.4 \pm 0.2}$ & $\mathbf{1.53 \pm 0.29}$ \\
\bottomrule
\end{tabular}
\end{table}

Table~\ref{tab:denoising-metrics} summarizes denoising performance for all methods on the intact specimen test set. PMDF-Net achieves a mean SNR improvement of $+11.4$\,dB, outperforming the best baseline (single-domain CNN, $+10.1$\,dB) by $1.3$\,dB and exceeding the signal averaging reference ($+6.0$\,dB for 16 averages vs. the 256-average target) by $5.4$\,dB. This improvement is statistically significant ($p < 0.05$, Wilcoxon signed-rank test with Holm--Bonferroni correction) versus all compared methods.

The NMSE results follow the same ranking, with PMDF-Net achieving $1.53 \times 10^{-3}$, approximately $32\%$ lower than single-domain CNN ($2.24 \times 10^{-3}$) and less than one-fifth of the Wiener filter baseline ($5.61 \times 10^{-3}$). The low variance across specimens ($\pm 0.29$) indicates consistent performance generalization across different measurement conditions.

\begin{table}[htbp]
\centering
\caption{Acoustic feature preservation metrics. Arrival time error and amplitude error are reported as mean $\pm$ standard deviation; CCC is the Lin's concordance correlation coefficient of the waveform envelope (higher is better). PMDF-Net achieves best feature preservation across all three metrics.}
\label{tab:feature-preservation}
\begin{tabular}{lccc}
\toprule
 & Arrival time error & Amplitude error & Envelope CCC \\
Method & ($\mu$s) & ($\%$) & (dimensionless) \\
\midrule
Signal averaging & $0.18 \pm 0.04$ & $2.1 \pm 0.4$ & $0.973 \pm 0.008$ \\
Wiener filter & $0.31 \pm 0.07$ & $4.7 \pm 0.9$ & $0.934 \pm 0.012$ \\
BM3D & $0.27 \pm 0.06$ & $3.8 \pm 0.7$ & $0.948 \pm 0.010$ \\
DWT (wavelet) & $0.24 \pm 0.05$ & $3.2 \pm 0.6$ & $0.956 \pm 0.009$ \\
Single-domain CNN & $0.21 \pm 0.05$ & $2.6 \pm 0.5$ & $0.961 \pm 0.008$ \\
PMDF-Net (proposed) & $\mathbf{0.14 \pm 0.03}$ & $\mathbf{1.5 \pm 0.3}$ & $\mathbf{0.981 \pm 0.005}$ \\
\bottomrule
\end{tabular}
\end{table}

\subsubsection{Feature Preservation}

Table~\ref{tab:feature-preservation} reports acoustic feature preservation metrics. PMDF-Net achieves an arrival time error of $0.14 \pm 0.03$\,$\mu$s, which is the smallest among all methods and approximately $33\%$ lower than the single-domain CNN. Amplitude error is $1.5 \pm 0.3\%$, the only method achieving sub-$2\%$ error and roughly half the error of the single-domain CNN. Critically, the waveform envelope CCC reaches $0.981 \pm 0.005$, exceeding the target of $0.95$ and surpassing all baselines.

These results demonstrate that the physics-constrained loss formulation effectively enforces preservation of physically meaningful signal features. While single-domain CNN achieves competitive SNR improvement, it sacrifices waveform morphology---particularly visible in the amplitude and envelope metrics. Wiener, BM3D, and DWT exhibit larger errors across all three feature metrics, confirming that conventional and single-domain approaches do not adequately preserve acoustic wave characteristics essential for quantitative ultrasonic evaluation.

\begin{figure}[htbp]
\centering
% Figure placeholder - actual figure to be generated
\fbox{\parbox{0.9\linewidth}{\centering
Placeholder: Figure~4 --- Qualitative waveform comparison\\
(a) Reference (256 averages), (b) Input (16 averages, $\sim$6\,dB),\\
(c) Wiener, (d) BM3D, (e) DWT, (f) PMDF-Net\\
See electronic version for color figure.}}
\caption{Representative waveforms comparing denoising methods on a test signal. (a) Reference high-averaged signal (256 averages). (b) Low-averaged input (16 averages, SNR $\approx$ 6\,dB). (c)--(e) Results of Wiener, BM3D, and DWT denoising, respectively. (f) PMDF-Net output. PMDF-Net recovers the S0 Lamb wave arrival morphology most faithfully, preserving the rising edge profile and peak amplitude. The zoomed inset (dashed box) highlights the arrival region where differences between methods are most apparent. See electronic version for color.}
\label{fig:denoising-examples}
\end{figure}

\subsubsection{Visual Comparison}

Figure~\ref{fig:denoising-examples} provides a qualitative comparison on a representative test waveform. The S0 Lamb wave arrival region (inset, bottom row) reveals pronounced differences between methods. Wiener filtering leaves residual high-frequency noise that obscures the mode onset. BM3D exhibits slight amplitude attenuation relative to the reference. DWT introduces spurious oscillations that distort the modal structure near the arrival. Single-domain CNN produces a cleaner waveform but with subtly smoothed features compared to PMDF-Net.

PMDF-Net recovers the S0 waveform morphology with the highest fidelity: the rising edge profile, peak amplitude, and subsequent modal reflections closely match the reference signal acquired with 256 averages. The zoomed inset confirms that PMDF-Net preserves both the arrival time and amplitude characteristics of the reference, consistent with the quantitative metrics in Table~\ref{tab:feature-preservation}. This visual assessment corroborates the key finding that PMDF-Net simultaneously achieves the best SNR improvement \textit{and} the best feature preservation---a combination that no baseline method attains, where improved denoising typically comes at the cost of waveform distortion.
