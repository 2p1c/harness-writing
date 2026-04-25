\subsection{Limitations}
\label{sec:discussion-limitations}

Several constraints bound the scope of the present results and should guide interpretation and application.

\textbf{Training data requirement.} The method relies on paired training data comprising low-averaging input signals and high-averaging reference targets. Acquiring such pairs requires controlled acquisition sessions with sufficient repeatability to register the same spatial locations across multiple averaging levels. This protocol is feasible for laboratory specimens but imposes a practical barrier for field deployment or for materials where stable cross-session registration is difficult.

\textbf{Cross-thickness generalization.} Generalization to aluminum plates of thickness different from the training set introduces measurable degradation. PMDF-Net trained on 3\,mm specimens exhibited $\Delta$SNR drops of 1.8\,dB on 5\,mm plates and 3.2\,dB on 8\,mm plates without retraining. This degradation arises from thickness-dependent shifts in Lamb wave mode composition and group velocity, which alter the effective center frequency of the received signals.

\textbf{Defect type coverage.} The defect generalization experiments use machined slots and edge notches as test defects. These geometries produce relatively strong, broadband reflections. Other defect types—particularly cracks with sub-millimeter opening displacements and delaminations at composite interfaces—may generate weaker, more localized scattering signatures that are not captured by the current test set.

\textbf{Computational cost.} Training PMDF-Net requires GPU resources; the physics-constrained loss and multi-domain architecture increase the computational burden relative to single-domain baselines. Inference, however, is efficient and operates at commercially relevant speeds on standard hardware.

\textbf{Material scope.} All training and evaluation use aluminum specimens. Carbon fiber-reinforced polymers or other composite laminates exhibit substantially different anisotropic wave propagation behavior and would require separate training data and likely architectural adaptation.