\section{实验验证}
\label{sec:experiments}

本文档描述了PMDF-Net在激光超声缺陷成像上的实验验证。验证工作分为三个阶段进行。第\ref{sec:experiment-setup}节详细介绍了激光超声检测系统，包括Nd:YAG激发激光、LDV检测、扫描配置以及用于训练和测试的铝板试件。第\ref{sec:experiment-training}节阐述了信号预处理流程、配对训练数据的构建（信噪比目标为12\,dB）、数据增强协议，以及在单块RTX 4090上进行的PMDF-Net训练配置。第\ref{sec:experiment-imaging}节通过缺陷处B-scan重建评估全波形成像性能，将PMDF-Net与维纳滤波、BM3D及DWT进行对比，
评价指标包括信噪比改善(SNR improvement)、NMSE、特征保真度和CNR。

\input{sections/experiment/4-1-setup-zh.tex}

\input{sections/experiment/4-2-training-zh.tex}

\input{sections/experiment/4-3-imaging-zh.tex}

\input{sections/experiment/4-4-statistics-zh.tex}

\input{sections/experiment/4-5-ablation-zh.tex}

\input{sections/experiment/4-6-fig4-zh.tex}