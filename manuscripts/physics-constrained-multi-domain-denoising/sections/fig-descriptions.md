% ============================================================
% Figure Placeholder Descriptions
% Figures 2, 3, 4, 5
% ============================================================

%% ------------------------------------------------------------
%% Figure 2 — PMDF-Net Architecture
%% ------------------------------------------------------------
\begin{figure}[tb]
  \centering
  %\includegraphics[width=0.9\textwidth]{figs/pmdfnet-architecture.pdf}
  \caption{PMDF-Net architecture: time-domain branch (left), time-frequency branch (center), fusion module, shared decoder (right).}
  \label{fig:pmdfnet-architecture}
\end{figure}

% Placeholder description:
% This figure illustrates the PMDF-Net architecture, which employs a dual-branch
% encoder-decoder structure. The time-domain branch processes 1D convolutional
% features along the temporal axis, while the time-frequency branch operates on
% 2D convolutions applied to the STFT representation. A fusion module at the
% bottleneck combines both branch representations before a shared decoder
% reconstructs the denoised signal. Skip connections link corresponding encoder
% and decoder layers to preserve fine-grained signal details throughout the
% processing pipeline.

%% ------------------------------------------------------------
%% Figure 3 — Training Pipeline
%% ------------------------------------------------------------
\begin{figure}[tb]
  \centering
  %\includegraphics[width=0.9\textwidth]{figs/training-pipeline.pdf}
  \caption{Training pipeline: signal preprocessing, dual-branch encoding, fusion, decoding, and physics-constrained loss computation.}
  \label{fig:training-pipeline}
\end{figure}

% Placeholder description:
% This figure depicts the end-to-end training pipeline for PMDF-Net. The input
% low-averaged signal undergoes bandpass filtering, amplitude normalization, and
% STFT computation. The dual-branch encoder extracts time-domain and time-frequency
% features in parallel. A fusion module at the bottleneck integrates both
% representations, which the shared decoder then uses to reconstruct the denoised
% signal. The total loss combines a reconstruction loss measuring output fidelity,
% a physics loss enforcing the wave equation-based S0 arrival-time constraint,
% and a total variation regularization term promoting piecewise-smooth solutions.

%% ------------------------------------------------------------
%% Figure 4 — Denoising Examples
%% ------------------------------------------------------------
\begin{figure}[tb]
  \centering
  %\includegraphics[width=0.9\textwidth]{figs/denoising-examples.pdf}
  \caption{Denoising examples: time-domain waveforms comparing all methods.}
  \label{fig:denoising-examples}
\end{figure}

% Placeholder description:
% This figure presents a six-panel comparison of denoising performance on a
% representative A-scan signal. Panels from left to right show the reference
% clean signal, the noisy input, and the outputs of Wiener filtering, BM3D,
% DWT thresholding, and the proposed PMDF-Net. Waveforms are displayed in the
% time domain, with a vertical marker indicating the S0 arrival time. A zoomed
% inset highlights the arrival region where differences between methods are most
% pronounced. PMDF-Net visibly preserves the sharp arrival discontinuity while
% suppressing background noise more effectively than the competing approaches.

%% ------------------------------------------------------------
%% Figure 5 — B-scan Imaging
%% ------------------------------------------------------------
\begin{figure}[tb]
  \centering
  %\includegraphics[width=0.9\textwidth]{figs/bscan-imaging.pdf}
  \caption{B-scan images of aluminum specimen with machined slot: comparison of denoising methods.}
  \label{fig:bscan-imaging}
\end{figure}

% Placeholder description:
% This figure displays four B-scan images of a slotted aluminum specimens obtained
% after applying different denoising methods to the raw acquisition. From left to
% right: simple averaging across measurements, Wiener-filtered, BM3D-processed,
% and PMDF-Net output. The machined slot appears as a dark vertical feature in
% all panels. PMDF-Net produces a noticeably cleaner image with enhanced defect
% contrast and reduced speckle noise, making the slot boundaries more clearly
% discernible compared to the other three approaches.
