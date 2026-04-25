\subsection{Physics-Constrained Loss Function}
\label{sec:physics-loss}

Training denoising networks with a standard L2 (MSE) loss alone presents a fundamental limitation: it minimizes pixel-wise squared errors, which implicitly favors overly smooth outputs that may destroy high-frequency acoustic features critical for defect detection. To address this, we design a physics-constrained loss function $\mathcal{L}_{total}$ composed of three complementary terms:

\begin{equation}
\mathcal{L}_{total} = \lambda_{\text{rec}} \mathcal{L}_{\text{rec}} + \lambda_{\text{phys}} \mathcal{L}_{\text{physics}} + \lambda_{\text{TV}} \mathcal{L}_{\text{TV}},
\end{equation}

where $\lambda_{\text{rec}}$, $\lambda_{\text{phys}}$, and $\lambda_{\text{TV}}$ are empirically tuned weighting coefficients.

\textbf{Reconstruction loss.} The reconstruction term enforces overall waveform similarity between the denoised output $\hat{y}$ and the high-quality reference target $y$:

\begin{equation}
\mathcal{L}_{\text{rec}} = \| \hat{y} - y \|_2^2.
\end{equation}

While $\mathcal{L}_{\text{rec}}$ drives the network toward noise suppression, it does not explicitly preserve diagnostically relevant acoustic features.

\textbf{Physics-constrained feature preservation.} The physics term $\mathcal{L}_{\text{physics}}$ penalizes deviation in three waveform characteristics that encode defect information:

\begin{equation}
\mathcal{L}_{\text{physics}} = \mathcal{L}_{\text{arrival}} + \mathcal{L}_{\text{amplitude}} + \mathcal{L}_{\text{morphology}},
\end{equation}

where $\mathcal{L}_{\text{arrival}}$ measures arrival time deviation via cross-correlation-based time alignment, $\mathcal{L}_{\text{amplitude}}$ enforces peak amplitude ratio consistency, and $\mathcal{L}_{\text{morphology}}$ quantifies waveform envelope similarity using Lin's concordance correlation coefficient (CCC). These terms collectively ensure that acoustic events remain temporally and morphologically intact after denoising.

\textbf{Total variation regularization.} The smoothness regularization term

\begin{equation}
\mathcal{L}_{\text{TV}} = \| \nabla \hat{y} \|_1
\end{equation}

penalizes oscillatory artifacts typical of CNN-based denoisers, encouraging piecewise-smooth outputs consistent with physical acoustic propagation.

\textbf{Weight selection.} The loss weights are determined empirically on a validation set, with typical balances $\lambda_{\text{rec}} = 1.0$, $\lambda_{\text{phys}} \in [0.1, 1.0]$, and $\lambda_{\text{TV}} \in [0.01, 0.1]$. Ablation studies (Section~\ref{sec:ablation}) validate that removing $\mathcal{L}_{\text{physics}}$ degrades feature preservation metrics despite achieving higher SNR, confirming the necessity of physics constraints for diagnostically reliable denoising.
