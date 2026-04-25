\subsection{Cross-Domain Generalization}
\label{sec:results-generalization}

A critical practical concern for deployment in real nondestructive evaluation scenarios is whether a model trained on intact specimens can generalize to specimens containing defects. Unlike conventional signal averaging, which preserves all features indiscriminately, neural networks may learn dataset-specific artifacts that do not transfer across specimen conditions. We evaluated cross-domain generalization by training PMDF-Net exclusively on signals acquired from the intact aluminum plate and subsequently testing on signals from the defect-containing specimen without any fine-tuning.

\textbf{Intact-to-defect generalization gap.} Table~\ref{tab:generalization-gap} reports denoising performance on the defect test set for models trained only on intact data. PMDF-Net achieved a mean $\Delta$SNR of \placeholder{12.3}\,dB on defect specimens, representing a drop of \placeholder{1.4}\,dB relative to its intact test set performance. In contrast, a single-domain CNN baseline exhibited a substantially larger degradation, with $\Delta$SNR falling from \placeholder{10.8}\,dB on intact specimens to \placeholder{6.2}\,dB on defect specimens ($\Delta$ = \placeholder{4.6}\,dB). These results demonstrate that multi-domain fusion confers robustness to specimen-level domain shift that single-domain architectures do not possess.

\begin{table}[htbp]
\centering
\caption{Cross-domain generalization: intact-trained models evaluated on defect-containing aluminum.}
\label{tab:generalization-gap}
\begin{tabular}{lccc}
\toprule
Model & Intact $\Delta$SNR (dB) & Defect $\Delta$SNR (dB) & Gap (dB) \\
\midrule
PMDF-Net (intact-only training) & \placeholder{13.7} & \placeholder{12.3} & \placeholder{1.4} \\
Single-domain CNN & \placeholder{10.8} & \placeholder{6.2} & \placeholder{4.6} \\
\bottomrule
\end{tabular}
\end{table}

\textbf{Ablation on generalization.} To identify which components of PMDF-Net contribute to generalization, we evaluated the ablation variants from Section~\ref{sec:experiment-ablation} on the defect test set. The time-domain-only configuration showed the largest degradation, with $\Delta$SNR dropping to \placeholder{4.8}\,dB on defect specimens. The time-frequency-only variant exhibited moderate degradation ($\Delta$SNR = \placeholder{8.1}\,dB on defect specimens). Full PMDF-Net with both branches retained near-intact performance ($\Delta$SNR = \placeholder{12.3}\,dB). Critically, removing the physics loss while keeping both branches caused $\Delta$SNR to fall to \placeholder{7.9}\,dB, confirming that physics-constrained feature preservation—not multi-domain fusion alone—is the dominant factor enabling cross-domain generalization. The physics loss terms enforce that arrival time, peak amplitude, and waveform morphology are faithfully reconstructed, and these features are inherently sensitive to defect-related reflections and scattering.

\textbf{Cross-thickness generalization.} We additionally evaluated generalization across aluminum plates of varying thickness. PMDF-Net trained on 3\,mm aluminum was tested on 5\,mm and 8\,mm plates without retraining. $\Delta$SNR degraded by \placeholder{1.8}\,dB on 5\,mm specimens and \placeholder{3.2}\,dB on 8\,mm specimens, attributable to the shift in center frequency and group velocity of Lamb wave modes at different thicknesses. Nonetheless, absolute performance on the 8\,mm plates ($\Delta$SNR = \placeholder{9.1}\,dB) remained substantially above the single-domain CNN intact baseline, indicating clinically useful generalization capability.

\textbf{Why generalization works.} The physics-constrained loss explicitly penalizes deviations in physically meaningful signal features—arrival time shifts, amplitude changes, and waveform distortion—rather than optimizing solely for pixel-level or spectrogram-level reconstruction metrics. Because defects manifest as perturbations to these same physical features (altered arrival times due to scattering, reduced amplitudes due to energy dissipation, and distorted waveforms due to mode conversion), the model trained to preserve physically meaningful structure is implicitly trained to be sensitive to defect-related perturbations. Multi-domain fusion complements this by capturing both time-domain waveform details and time-frequency spectral characteristics, ensuring that defect signatures visible in one representation but obscured in the other are nonetheless preserved.
