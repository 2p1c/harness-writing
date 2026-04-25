\subsection{消融实验配置}
\label{sec:experiment-ablation}

为量化PMDF-Net中每个组件的贡献，在相同的测试集上评估了五种网络配置。所有变体共享相同的训练协议（AdamW优化器、余弦退火、$15$个epoch早停耐心）并从独立随机种子初始化以确保统计可靠性。

\begin{table}[htbp]
\centering
\caption{消融配置与组件分解。}
\label{tab:ablation-configs}
\begin{tabular}{lcccccc}
\toprule
配置 & 时域分支 & 时频分支 & 物理约束损失 & MSE损失 & 残差学习 \\
\midrule
完整PMDF-Net & \checkmark & \checkmark & \checkmark & \checkmark & \checkmark \\
仅时域分支 & \checkmark & -- & -- & \checkmark & \checkmark \\
仅时频分支 & -- & \checkmark & -- & \checkmark & \checkmark \\
PMDF-Net无物理损失 & \checkmark & \checkmark & -- & \checkmark & \checkmark \\
PMDF-Net无多域 & \checkmark & -- & \checkmark & \checkmark & \checkmark \\
\bottomrule
\end{tabular}
\end{table}

\textbf{完整PMDF-Net}是第\ref{sec:architecture}节描述的完整模型，具有时域和时频两个编码器分支、融合模块、共享解码器以及第\ref{sec:physics-loss}节的完整物理约束损失函数$\mathcal{L}_{total}$。此配置为所有指标建立了性能上界。

\textbf{仅时域分支}用单一时域编码器-解码器（容量与一个PMDF-Net分支相当，即参数量大致相等）替代双分支结构。训练仅使用MSE损失，无时频分支或物理约束。
此配置量化了多域融合相对于单域基线的优势。

\textbf{仅时频分支}镜像仅时域分支变体但仅在STFT幅度频谱上运行。2D卷积编码器-解码器独立处理频谱，逆STFT重建去噪后的时域波形。应用MSE损失但无物理约束。
此变体测量独立时频去噪相对于时域处理的性能。

\textbf{PMDF-Net无物理损失}使用完整的双分支架构与融合模块，但仅使用MSE损失训练（$\mathcal{L}_{total} = \mathcal{L}_{\text{rec}}$），移除第\ref{sec:physics-loss}节的到达时刻、振幅和形态保留项。保留残差学习。此配置隔离了物理约束特征保留相对于多域融合的效果。

\textbf{PMDF-Net无多域}禁用时频分支和融合模块，仅保留时域编码器-解码器与残差学习和完整物理约束损失（$\mathcal{L}_{total}$）。此配置检验物理约束单独（无跨域互补性）是否足以实现特征保留去噪。

\textbf{评估协议。}所有五种配置在第\ref{sec:experiment-setup}节描述的相同测试集上评估，使用相同指标：信噪比改善（$\Delta$SNR）、到达时间(TOA)误差、峰振幅误差和缺陷检测F1分数。每个配置从三个独立初始化训练，结果以跨运行的均值$\pm$标准差报告。