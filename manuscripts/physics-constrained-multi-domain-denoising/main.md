\documentclass[review]{elsarticle}

\usepackage{lineno,hyperref}
\modulolinenumbers[5]

\journal{Measurement}

%% Essential packages
\usepackage{amsmath,amsfonts,amssymb}
\usepackage{graphicx}
\usepackage{float}
\usepackage{cite}
\usepackage{url}
\usepackage{booktabs}
\usepackage{algorithm}
\usepackage{algorithmic}

\begin{document}

\begin{frontmatter}

%% Title of your paper
\title{A Multi-Domain Fusion Neural Network for Laser Ultrasonic Denoising as an Alternative to Signal Averaging with Generalization to Defect Detection}

%% Author names and affiliations (update with actual authors)
\author[1]{Author One\corref{cor1}}
\author[1]{Author Two}
\author[1]{Author Three}
\author[2]{Author Four}

\affiliation[1]{organization={Department of Mechanical Engineering},
                city={City},
                country={Country}}

\affiliation[2]{organization={Department of Materials Science},
                city={City},
                country={Country}}

\cortext[cor1]{Corresponding author: authorone@university.edu}

%% Abstract
\input{sections/abstract}

%% Keywords
\begin{keyword}
laser ultrasonic \sep denoising \sep multi-domain fusion \sep physics-constrained neural network \sep signal averaging \sep defect detection
\end{keyword}

\end{frontmatter}

\linenumbers

%% Main content sections
\input{sections/introduction}
\input{sections/related_work}
\input{sections/methodology}
\input{sections/experiment}
\input{sections/results}
\input{sections/discussion}
\input{sections/conclusion}

%% Acknowledgments (optional)
\section*{Acknowledgments}
The authors acknowledge...

%% References
\bibliographystyle{elsarticle-num}
\bibliography{references}

\end{document}
