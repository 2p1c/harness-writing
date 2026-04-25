This study addresses a critical gap in laser ultrasonic non-destructive testing: whether multi-domain fusion neural networks can replace conventional signal averaging under reduced averaging conditions while preserving acoustic features essential for defect detection. Traditional denoising methods such as Wiener filtering and wavelet thresholding suppress noise but frequently destroy acoustically meaningful features including arrival times, amplitudes, and waveform morphology \cite{chen2019wavelet}. Meanwhile, existing deep learning approaches either require extensive signal averaging for training \cite{liu2022deep} or operate in a single domain, failing to capture complementary time-frequency information \cite{zhang2020deep}. This limitation is particularly acute for laser US, where repeated averaging induces surface damage and reduces inspection efficiency \cite{yang2023unsupervised}. The research question guiding this work is: \emph{Can a multi-domain fusion denoising network trained under reduced averaging conditions achieve comparable or superior defect detection capability relative to conventional signal averaging, while generalizing from intact specimens to defect-containing workpieces?}

To answer this question, this paper makes the following novel contributions:

\begin{enumerate}
\item \textbf{Multi-domain fusion architecture.} A physics-constrained encoder-decoder network that jointly encodes time-domain waveforms and time-frequency representations, leveraging complementary information from both domains to improve signal enhancement fidelity.

\item \textbf{Physics-constrained loss function.} A loss formulation that explicitly preserves acoustically meaningful features including arrival times, peak amplitudes, and waveform morphology, ensuring that denoised signals retain diagnostic information for defect characterization.

\item \textbf{Reduced averaging training protocol.} A paired training strategy in which network inputs are limited-average signals ($N$ averages) and target outputs are high-average reference signals ($\gg N$), enabling the model to learn denoising under practical reduced-averaging conditions.

\item \textbf{Cross-domain generalization evaluation.} Systematic validation demonstrating that models trained exclusively on intact aluminum specimens maintain detection performance on defect-containing workpieces, addressing the intact-to-defect generalization gap identified in prior deep learning NDT research \cite{liu2022deep}.
\end{enumerate}

These contributions collectively establish a framework for practical laser ultrasonic inspection that reduces reliance on time-consuming signal averaging while preserving---rather than sacrificing---defect detection capability.