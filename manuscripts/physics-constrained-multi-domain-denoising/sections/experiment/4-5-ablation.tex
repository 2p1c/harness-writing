\subsection{Ablation Study Configuration}
\label{sec:experiment-ablation}

To quantify the contribution of each component in PMDF-Net, five network configurations were evaluated on the identical test set. All variants share the same training protocol (AdamW optimizer, cosine annealing, early stopping at $15$ epochs patience) and were initialized from independent random seeds to ensure statistical reliability.

\begin{table}[htbp]
\centering
\caption{Ablation configurations and component breakdown.}
\label{tab:ablation-configs}
\begin{tabular}{lcccccc}
\toprule
Configuration & Time-domain branch & Time-frequency branch & Physics loss & MSE loss & Residual learning \\
\midrule
Full PMDF-Net & \checkmark & \checkmark & \checkmark & \checkmark & \checkmark \\
Time-domain only & \checkmark & -- & -- & \checkmark & \checkmark \\
Time-frequency only & -- & \checkmark & -- & \checkmark & \checkmark \\
PMDF-Net w/o physics loss & \checkmark & \checkmark & -- & \checkmark & \checkmark \\
PMDF-Net w/o multi-domain & \checkmark & -- & \checkmark & \checkmark & \checkmark \\
\bottomrule
\end{tabular}
\end{table}

\textbf{Full PMDF-Net} is the complete model described in Section~\ref{sec:architecture}, featuring both time-domain and time-frequency encoder branches, the fusion module, shared decoder, and the full physics-constrained loss function $\mathcal{L}_{total}$ from Section~\ref{sec:physics-loss}. This configuration establishes the upper-bound performance for all metrics.

\textbf{Time-domain only} replaces the dual-branch structure with a single time-domain encoder-decoder of comparable capacity (approximately equal parameter count to one PMDF-Net branch). Training uses MSE loss only, with no time-frequency branch or physics constraints. This configuration quantifies the benefit of multi-domain fusion over a single-domain baseline.

\textbf{Time-frequency only} mirrors the time-domain-only variant but operates exclusively on the STFT magnitude spectrogram. The 2D convolutional encoder-decoder processes spectrograms independently, and the inverse STFT reconstructs the denoised time-domain waveform. MSE loss is applied without physics constraints. This variant measures standalone time-frequency denoising performance relative to time-domain processing.

\textbf{PMDF-Net w/o physics loss} uses the complete dual-branch architecture with fusion module, but trains with MSE loss only ($\mathcal{L}_{total} = \mathcal{L}_{\text{rec}}$), removing the arrival time, amplitude, and morphology preservation terms from Section~\ref{sec:physics-loss}. Residual learning is retained. This isolates the effect of physics-constrained feature preservation against multi-domain fusion.

\textbf{PMDF-Net w/o multi-domain} disables the time-frequency branch and fusion module, retaining only the time-domain encoder-decoder with residual learning and the full physics-constrained loss ($\mathcal{L}_{total}$). This configuration tests whether the physics constraint alone, without cross-domain complementarity, is sufficient to achieve feature-preserving denoising.

\textbf{Evaluation protocol.} All five configurations are evaluated on the same test set described in Section~\ref{sec:experiment-setup}, using identical metrics: SNR improvement ($\Delta$SNR), time-of-arrival (TOA) error, peak amplitude error, and F1-score for defect detection. Each configuration is trained from three independent initializations, and results are reported as mean $\pm$ standard deviation across runs.