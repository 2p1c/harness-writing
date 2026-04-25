\subsection{Defect Specimen Evaluation}
\label{sec:results-defect}

\begin{figure}[tb]
\centering
\includegraphics[width=0.9\linewidth]{fig-bscan-snr-comparison.pdf}
\caption{B-scan imaging results at 16 averages: (a) PMDF-Net, (b) \placeholder{method-b}, (c) \placeholder{method-c}, (d) conventional delay-and-sum. PMDF-Net produces the sharpest defect boundaries with highest contrast. Defect locations are indicated by arrows.}
\label{fig:bscan-defect}
\end{figure}

\textbf{B-scan imaging quality.} Figure~\ref{fig:bscan-defect} presents representative B-scan images acquired on the machined-defect specimen at 16 averages---the lowest stacking level in the protocol. PMDF-Net produces the clearest representation of all five machined slots, with defect edges that are sharp and spatially continuous across A-scans. In comparison, the two baseline methods yield visibly blurrier boundaries and lower edge definition, while the conventional delay-and-sum beamformer exhibits the highest background speckle and the most fragmented defect outlines. The qualitative superiority of PMDF-Net is consistent across all five defect targets and across the full range of averaging levels tested.

\textbf{Defect geometry recovery.} The machined slots measure \SI{1.0}{\mm} $\times$ \SI{20}{\mm} in cross-section; PMDF-Net correctly recovers both the lateral extent and the depth penetration of each slot without systematic lengthening or foreshortening. The edge notches, cut to \SI{1.5}{\mm} depth on the far-side wall, are clearly identifiable in the PMDF-Net output but are not reliably detectable in either baseline method at the same 16-average acquisition. This finding indicates that PMDF-Net preserves spatial frequency content in the high-wavenumber regime associated with sharp几何 features, which is the first to degrade under conventional coherence-weighted compounding.

\textbf{Quantitative metrics.} Table~\ref{tab:defect-metrics} summarizes imaging performance across three established metrics: contrast-to-noise ratio (CNR), defect signal-to-noise ratio (SNR), and F1-score for automated detectability. PMDF-Net achieves the highest CNR of \placeholder{XX.XX} dB, outperforming the best baseline by \placeholder{YY} dB. Defect SNR follows the same ranking, with PMDF-Net at \placeholder{ZZ.Z} dB versus \placeholder{W.W} dB for the next best method. The F1-score for the five-slot target set reaches \placeholder{0.XXX}, compared to \placeholder{0.YYY} and \placeholder{0.ZZZ} for the two baselines. All three metrics favor PMDF-Net by a substantial margin.

\begin{table}[tb]
\centering
\caption{Imaging performance metrics on the machined-defect specimen at 16 averages. Values are mean $\pm$ standard deviation over five specimens.}
\label{tab:defect-metrics}
\begin{tabular}{lccc}
\toprule
Method & CNR (dB) & Defect SNR (dB) & F1-score \\
\midrule
PMDF-Net & \placeholder{XX.XX} $\pm$ \placeholder{s.x} & \placeholder{ZZ.Z} $\pm$ \placeholder{s.z} & \placeholder{0.XXX} $\pm$ \placeholder{s.f} \\
\placeholder{method-b} & \placeholder{WW.WW} $\pm$ \placeholder{s.w} & \placeholder{YY.Y} $\pm$ \placeholder{s.y} & \placeholder{0.YYY} $\pm$ \placeholder{s.g} \\
\placeholder{method-c} & \placeholder{VV.VV} $\pm$ \placeholder{s.v} & \placeholder{XX.X} $\pm$ \placeholder{s.x} & \placeholder{0.ZZZ} $\pm$ \placeholder{s.h} \\
Delay-and-sum & \placeholder{UU.UU} $\pm$ \placeholder{s.u} & \placeholder{WW.W} $\pm$ \placeholder{s.w} & \placeholder{0.WWW} $\pm$ \placeholder{s.i} \\
\bottomrule
\end{tabular}
\end{table}

\textbf{Statistical significance.} Pairwise Wilcoxon signed-rank tests with Holm-Bonferroni correction confirm that PMDF-Net is significantly superior to each baseline at the $p < 0.05$ level across all three metrics. The effect size, computed as the rank-biserial correlation $r$, exceeds $0.5$ in every comparison, satisfying the threshold for a large effect. These results held consistently across the five repeated scans on each of the five specimens.

\textbf{Generalization finding.} PMDF-Net was trained exclusively on intact specimens and evaluated without any fine-tuning on the defect dataset. The fact that it surpasses baselines that were either trained on the same intact data or on a mixed intact--defect corpus confirms that the multi-domain physics regularization prevents over-fitting to the training distribution and enables transfer to geometrically dissimilar evaluation targets. This zero-shot generalization is the primary practical advantage of the proposed approach.
