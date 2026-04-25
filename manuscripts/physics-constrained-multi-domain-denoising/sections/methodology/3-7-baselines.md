\subsection{Baseline Methods}
\label{sec:baselines}

To contextualize the proposed PMDF-Net, we compare against five established denoising approaches spanning classical signal processing and modern deep learning. All baseline methods are carefully tuned for optimal performance prior to comparison.

\textbf{Signal averaging} represents the conventional industrial standard for SNR improvement in laser ultrasonic testing. Repeated N-shot averaged signals are acquired and compared against M-shot references where M \textgreater{}\textgreater{} N. The expected SNR improvement scales as $10\log_{10}(M/N)$ dB, though this comes at the cost of prolonged laser exposure and reduced inspection throughput. This baseline directly captures the trade-off this work aims to overcome.

\textbf{Wiener filtering} employs an adaptive approach that estimates the noise power spectral density from the input signal and applies frequency-domain filtering accordingly \cite{dabov2007bm3d}. Unlike simple averaging, Wiener filtering exploits spectral differences between signal and noise components. The method requires accurate noise characterization; when this assumption holds, it provides moderate denoising without the temporal cost of multiple acquisitions.

\textbf{BM3D} (block-matching 3D collaborative filtering) extends conventional 3D transform-domain denoising by grouping similar signal patches and applying collaborative filtering in a sparse 3D representation \cite{dabov2007bm3d}. BM3D achieves strong performance on natural images and has been adapted to 1D signal denoising. Its strength lies in exploiting patch similarity; however, it may struggle with the transient, high-frequency characteristics of laser ultrasonic waveforms where exact patch matches are less common.

\textbf{Wavelet denoising (DWT)} applies discrete wavelet transform with soft thresholding using the db4 wavelet family \cite{chen2019wavelet}. Wavelet threshold levels are selected via cross-validation on held-out noisy data to balance noise suppression against signal distortion. This approach provides a computationally efficient baseline that captures multi-scale signal features, though fixed wavelet basis selection may not optimally represent the diverse acoustic waveforms encountered in practice.

\textbf{Single-domain CNN (DnCNN/U-Net)} implements a deep convolutional denoising network trained in the time domain only \cite{zhang2017denoising}. This ablation baseline mirrors the time-domain branch of PMDF-Net but without the time-frequency branch or physics constraints. It serves to isolate the contribution of multi-domain fusion, expected to show comparable SNR improvement to PMDF-Net but with degraded feature preservation due to the absence of spectral guidance and physics-based loss terms.

Each baseline is tuned via grid search over relevant hyperparameters (e.g., Wiener noise variance estimation window, BM3D matching threshold, DWT decomposition levels, CNN learning rate and epochs) to ensure fair comparison.
