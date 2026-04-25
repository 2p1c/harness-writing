\subsection{跨域泛化}
\label{sec:results-generalization}

在实际无损检测(NDT)场景部署中，一个关键实践问题是：在完整试样上训练的模型能否泛化到含缺陷试样。与传统信号平均（无差别保留所有特征）不同，神经网络可能学习到不随试样条件转移的数据集特定伪影。我们通过完全在完整铝板获取的信号上训练PMDF-Net，随后在含缺陷试样信号上测试（无任何微调）来评估跨域泛化能力。

\textbf{完整→缺陷泛化差距。} 表~\ref{tab:generalization-gap}报告了仅在完整数据上训练的模型在缺陷测试集上的去噪性能。PMDF-Net在缺陷试样上实现平均$\Delta$SNR为\placeholder{12.3}\,dB，相比其完整测试集性能下降\placeholder{1.4}\,dB。相比之下，单域CNN基线表现出更大降解，$\Delta$SNR从完整试样上的\placeholder{10.8}\,dB降至缺陷试样上的\placeholder{6.2}\,dB（$\Delta$ = \placeholder{4.6}\,dB）。这些结果表明，多域融合赋予了单域架构所不具备的试样级域移鲁棒性。

\begin{table}[htbp]
\centering
\caption{跨域泛化：仅完整训练的模型在含缺陷铝板上的评估。}
\label{tab:generalization-gap}
\begin{tabular}{lccc}
\toprule
模型 & 完整$\Delta$SNR (dB) & 缺陷$\Delta$SNR (dB) & 差距 (dB) \\
\midrule
PMDF-Net（仅完整训练） & \placeholder{13.7} & \placeholder{12.3} & \placeholder{1.4} \\
单域CNN & \placeholder{10.8} & \placeholder{6.2} & \placeholder{4.6} \\
\bottomrule
\end{tabular}
\end{table}

\textbf{泛化消融。} 为识别PMDF-Net中哪些组件对泛化有贡献，我们在缺陷测试集上评估了第\ref{sec:experiment-ablation}节的消融变体。仅时域配置降解最大，$\Delta$SNR在缺陷试样上降至\placeholder{4.8}\,dB。仅时频域变体表现中等降解（缺陷试样上$\Delta$SNR = \placeholder{8.1}\,dB）。具有双分支的完整PMDF-Net保留了近乎完整的性能（$\Delta$SNR = \placeholder{12.3}\,dB）。关键地，去除物理损失但保留双分支导致$\Delta$SNR降至\placeholder{7.9}\,dB，证实物理约束特征保真度——而非仅多域融合——是实现跨域泛化的主导因素。物理损失项强制执行到达时间偏移、峰值幅度和波形形态的忠实重建，而这些特征本身对缺陷相关反射和散射敏感。

\textbf{跨厚度泛化。} 我们进一步评估了在不同厚度铝板上的泛化能力。在3\,mm铝板上训练的PMDF-Net在未重训练的情况下测试了5\,mm和8\,mm板。$\Delta$SNR在5\,mm试样上降解\placeholder{1.8}\,dB，在8\,mm试样上降解\placeholder{3.2}\,dB，归因于不同厚度下Lamb波模态的中心频率和群速度偏移。尽管如此，8\,mm板上的绝对性能（$\Delta$SNR = \placeholder{9.1}\,dB）仍显著高于单域CNN完整基线，表明具有临床有用的泛化能力。

\textbf{泛化为何有效。} 物理约束损失显式惩罚物理意义信号特征的偏离——到达时间偏移、幅度变化和波形失真——而非仅优化像素级或语谱图级重建指标。因为缺陷表现为这些相同物理特征的扰动（由散射引起的到达时间改变、由能量耗散引起的幅度减小、由模态转换引起的波形失真），训练以保留物理有意义结构的模型隐式地被训练为对缺陷相关扰动敏感。多域融合通过同时捕获时域波形细节和时频谱特征来补充这一点，确保在一个表示中可见但在另一表示中被遮蔽的缺陷特征仍能被保留。
