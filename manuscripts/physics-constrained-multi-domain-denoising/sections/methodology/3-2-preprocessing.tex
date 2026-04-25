\subsection{Signal Preprocessing}
\label{sec:preprocessing}

Raw laser ultrasonic signals acquired with limited shot averaging ($N = 1$, $2$, $4$, or $8$) undergo a standardized preprocessing pipeline before feeding into the network. No high-averaging signals are used as inputs at any stage.

\textbf{Bandpass filtering.} A finite impulse response (FIR) bandpass filter is applied to retain the Lamb wave frequency band of interest. The passband is set to $100\,\text{kHz}$--$2\,\text{MHz}$, with stopband attenuation of $-40\,\text{dB}$ and passband ripple below $0.1\,\text{dB}$. This range captures the fundamental symmetric ($S_0$) and anti-symmetric ($A_0$) Lamb wave modes typically excited in plate specimens while suppressing low-frequency mechanical vibrations and high-frequency electromagnetic noise.

\textbf{Time-gating.} A rectangular window selects the arrival region containing Lamb wave packets. The gate starts $2\,\mu\text{s}$ before the theoretically predicted first arrival based on the $S_0$ mode velocity ($c_S \approx 5400\,\text{m/s}$ for the aluminum plate) and extends $30\,\mu\text{s}$ to capture the full wave packet including possible multi-mode arrivals. Signals outside this window are zeroed to eliminate external interference.

\textbf{Amplitude normalization.} Per-shot $z$-score normalization standardizes signal amplitudes:
\begin{equation}
x_{\text{norm}} = \frac{x - \mu_x}{\sigma_x},
\end{equation}
where $\mu_x$ and $\sigma_x$ are the mean and standard deviation computed over the entire time-gated segment. This ensures that the network receives inputs with zero mean and unit variance regardless of laser energy fluctuations across shots.

\textbf{Time-frequency transform.} The time-frequency branch operates on STFT representations. STFT parameters are: Hanning window of length $W = 256$ samples; hop size $H = 64$ samples (75\% overlap); frequency resolution $\Delta f = f_s / W$, where $f_s$ is the sampling rate. These settings yield a balance between time localization ($\approx 0.8\,\mu\text{s}$) and frequency resolution ($\approx 60\,\text{kHz}$) sufficient to resolve dispersive Lamb wave components.

\textbf{Resampling.} All time-gated signals are resampled to a fixed length $L = 1024$ samples via linear interpolation. This enforces a consistent input dimensionality across all datasets, required by the fixed-size architecture of PMDF-Net.