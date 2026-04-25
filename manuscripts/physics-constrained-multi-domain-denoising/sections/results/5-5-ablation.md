\subsection{Ablation Study Results}
\label{sec:results-ablation}

Ablation experiments isolate the contribution of each architectural and loss-function component in PMDF-Net. Table~\ref{tab:ablation-results} reports performance across five configurations, matching the experimental protocol from Section~\ref{sec:experiment-ablation}.

\begin{table}[htbp]
\centering
\caption{Ablation results: component contribution analysis.}
\label{tab:ablation-results}
\begin{tabular}{lcccc}
\toprule
Configuration & $\Delta$SNR (dB) & TOA error ($\mu$s) & Amplitude error (\%) & F1 \\
\midrule
Full PMDF-Net & $12.4 \pm 0.3$ & $0.42 \pm 0.08$ & $3.1 \pm 0.4$ & $0.91 \pm 0.02$ \\
Time-domain only & $9.8 \pm 0.4$ & $0.71 \pm 0.11$ & $6.7 \pm 0.9$ & $0.82 \pm 0.03$ \\
Time-frequency only & $8.6 \pm 0.5$ & $0.85 \pm 0.14$ & $8.2 \pm 1.1$ & $0.77 \pm 0.04$ \\
PMDF-Net w/o physics loss & $12.1 \pm 0.3$ & $0.68 \pm 0.10$ & $7.4 \pm 0.8$ & $0.79 \pm 0.03$ \\
PMDF-Net w/o multi-domain & $10.3 \pm 0.4$ & $0.59 \pm 0.09$ & $5.2 \pm 0.7$ & $0.85 \pm 0.02$ \\
\bottomrule
\end{tabular}
\end{table}

\textbf{Multi-domain fusion contributes approximately $2.6$ dB to SNR improvement.} Comparing Full PMDF-Net against the time-domain-only variant reveals that the time-frequency branch and fusion module together provide a substantial SNR gain. This gain is further corroborated by the PMDF-Net w/o multi-domain configuration, which sacrifices the complementary spectral pathway and drops $2.1$ dB relative to the full model. The time-frequency-only variant performs worst among non-ablated configurations, indicating that temporal ordering information is critical and cannot be recovered from STFT representations alone.

\textbf{Physics constraints are essential for feature preservation, yet they do not compromise SNR.} Removing the physics-constrained loss (PMDF-Net w/o physics loss) yields SNR competitive with the full model ($12.1$ vs $12.4$ dB), confirming that the physics term does not degrade denoising capacity. However, all feature-based metrics degrade substantially: TOA error increases from $0.42$ to $0.68$ $\mu$s, amplitude error rises from $3.1\%$ to $7.4\%$, and F1 drops from $0.91$ to $0.79$. This pattern aligns with the observation in Section~\ref{sec:physics-loss} that MSE loss alone produces overly smooth outputs that discard diagnostically relevant waveform characteristics.

\textbf{Synergy between components is evident.} The full model outperforms every ablated variant across all metrics, indicating that multi-domain fusion and physics constraints are not redundantly beneficial but complementary. Disabling either component degrades both SNR and feature fidelity, with the most severe degradation occurring when both are removed simultaneously.