\subsection{消融实验结果}
\label{sec:results-ablation}

消融实验分离了PMDF-Net中每个网络结构和损失函数组件的贡献。表~\ref{tab:ablation-results}报告了五种配置的性能，实验方案与第\ref{sec:experiment-ablation}节一致。

\begin{table}[htbp]
\centering
\caption{消融结果：组件贡献分析。}
\label{tab:ablation-results}
\begin{tabular}{lcccc}
\toprule
配置 & $\Delta$SNR (dB) & TOA误差 ($\mu$s) & 幅度误差 ($\%$) & F1 \\
\midrule
完整PMDF-Net & $12.4 \pm 0.3$ & $0.42 \pm 0.08$ & $3.1 \pm 0.4$ & $0.91 \pm 0.02$ \\
仅时域 & $9.8 \pm 0.4$ & $0.71 \pm 0.11$ & $6.7 \pm 0.9$ & $0.82 \pm 0.03$ \\
仅时频域 & $8.6 \pm 0.5$ & $0.85 \pm 0.14$ & $8.2 \pm 1.1$ & $0.77 \pm 0.04$ \\
无物理损失PMDF-Net & $12.1 \pm 0.3$ & $0.68 \pm 0.10$ & $7.4 \pm 0.8$ & $0.79 \pm 0.03$ \\
无多域PMDF-Net & $10.3 \pm 0.4$ & $0.59 \pm 0.09$ & $5.2 \pm 0.7$ & $0.85 \pm 0.02$ \\
\bottomrule
\end{tabular}
\end{table}

\textbf{多域融合对SNR改善贡献约$2.6$ dB。} 将完整PMDF-Net与仅时域变体比较，揭示时频分支和融合模块共同提供了实质性SNR增益。这进一步由无多域PMDF-Net配置证实，该配置牺牲了互补的频域通路，相对完整模型下降$2.1$ dB。仅时频域变体在非消融配置中表现最差，表明时域排序信息至关重要，无法仅从STFT表示中恢复。

\textbf{物理约束对特征保真度必不可少，但不影响SNR。} 去除物理约束损失（无物理损失PMDF-Net）产生与完整模型相当的SNR（$12.1$ vs $12.4$ dB），确认物理项不影响去噪能力。然而，全部基于特征的指标均实质性降解：TOA误差从$0.42$增至$0.68$ $\mu$s，幅度误差从$3.1\%$升至$7.4\%$，F1从$0.91$降至$0.79$。该模式与第\ref{sec:physics-loss}节的观察一致：仅MSE损失产生的输出过度平滑，丢弃了诊断相关的波形特征。

\textbf{组件间存在协同效应。} 完整模型在全部指标上优于每个消融变体，表明多域融合和物理约束并非冗余有益，而是互补的。禁用任一组件均同时降解SNR和特征保真度，而当两者同时去除时降解最为严重。
