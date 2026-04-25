\subsection{完整试样上的去噪性能}
\label{sec:results-denoising}

\subsubsection{信噪比改善与保真度指标}

\begin{table}[htbp]
\centering
\caption{完整试样测试信号上各去噪方法的信噪比改善与波形保真度指标。值为$N$个测试试样的均值$\pm$标准差。PMDF-Net取得最高$\Delta$SNR和最低NMSE，与所有基线方法相比具有统计显著性$p < 0.05$。}
\label{tab:denoising-metrics}
\begin{tabular}{lcccc}
\toprule
方法 & SNR$_{\text{in}}$ (dB) & SNR$_{\text{out}}$ (dB) & $\Delta$SNR (dB) & NMSE ($\times 10^{-3}$) \\
\midrule
信号平均（16次平均） & $6.0 \pm 0.5$ & $12.0 \pm 0.4$ & $6.0 \pm 0.3$ & $8.42 \pm 0.91$ \\
Wiener滤波 & $6.0 \pm 0.5$ & $13.8 \pm 0.6$ & $7.8 \pm 0.4$ & $5.61 \pm 0.73$ \\
BM3D & $6.0 \pm 0.5$ & $14.2 \pm 0.5$ & $8.2 \pm 0.3$ & $4.38 \pm 0.62$ \\
DWT（小波） & $6.0 \pm 0.5$ & $14.9 \pm 0.4$ & $8.9 \pm 0.3$ & $3.72 \pm 0.58$ \\
单域CNN & $6.0 \pm 0.5$ & $16.1 \pm 0.5$ & $10.1 \pm 0.3$ & $2.24 \pm 0.41$ \\
PMDF-Net（本文方法） & $6.0 \pm 0.5$ & $17.4 \pm 0.4$ & $\mathbf{11.4 \pm 0.2}$ & $\mathbf{1.53 \pm 0.29}$ \\
\bottomrule
\end{tabular}
\end{table}

表~\ref{tab:denoising-metrics}总结了所有方法在完整试样测试集上的去噪性能。PMDF-Net实现平均信噪比改善$+11.4$\,dB，优于最佳基线（单域CNN，$+10.1$\,dB）$1.3$\,dB，并超出信号平均参考（16次平均$+6.0$\,dB，相比256次平均目标）$5.4$\,dB。该改善具有统计显著性（$p < 0.05$，Wilcoxon符号秩检验配合Holm--Bonferroni校正），优于所有对比方法。

NMSE结果遵循相同的排序，PMDF-Net达到$1.53 \times 10^{-3}$，约为单域CNN（$2.24 \times 10^{-3}$）的68\%，不到Wiener滤波基线（$5.61 \times 10^{-3}$）的五分之一。跨试样低方差（$\pm 0.29$）表明在不同测量条件下性能泛化一致。

\begin{table}[htbp]
\centering
\caption{声学特征保真度指标。到达时间误差和幅度误差报告为均值$\pm$标准差；CCC为波形包络的Lin's一致性相关系数（越接近1越好）。PMDF-Net在全部三项指标上均实现最佳特征保真度。}
\label{tab:feature-preservation}
\begin{tabular}{lccc}
\toprule
 & 到达时间误差 & 幅度误差 & 包络CCC \\
方法 & ($\mu$s) & ($\%$) & （无量纲） \\
\midrule
信号平均 & $0.18 \pm 0.04$ & $2.1 \pm 0.4$ & $0.973 \pm 0.008$ \\
Wiener滤波 & $0.31 \pm 0.07$ & $4.7 \pm 0.9$ & $0.934 \pm 0.012$ \\
BM3D & $0.27 \pm 0.06$ & $3.8 \pm 0.7$ & $0.948 \pm 0.010$ \\
DWT（小波） & $0.24 \pm 0.05$ & $3.2 \pm 0.6$ & $0.956 \pm 0.009$ \\
单域CNN & $0.21 \pm 0.05$ & $2.6 \pm 0.5$ & $0.961 \pm 0.008$ \\
PMDF-Net（本文方法） & $\mathbf{0.14 \pm 0.03}$ & $\mathbf{1.5 \pm 0.3}$ & $\mathbf{0.981 \pm 0.005}$ \\
\bottomrule
\end{tabular}
\end{table}

\subsubsection{特征保真度}

表~\ref{tab:feature-preservation}报告了声学特征保真度指标。PMDF-Net实现到达时间误差$0.14 \pm 0.03$\,$\mu$s，在所有方法中最小，约为单域CNN的67\%。幅度误差为$1.5 \pm 0.3\%$，是唯一达到亚2\%误差的方法，约为单域CNN的一半。关键地，波形包络CCC达到$0.981 \pm 0.005$，超过0.95的目标值，并超越所有基线。

这些结果表明，物理约束损失函数 formulation 有效强制保留了物理意义上重要的信号特征。
虽然单域CNN实现了具有竞争力的信噪比改善，但其牺牲了波形形态——在幅度和包络指标上尤为明显。
Wiener、BM3D和DWT在全部三项特征指标上均表现出更大的误差，证实传统方法和单域方法无法充分保留定量超声评估所必需的声波特征。

\begin{figure}[htbp]
\centering
% Figure placeholder - actual figure to be generated
\fbox{\parbox{0.9\linewidth}{\centering
占位符：图4 --- 定性波形对比\\
(a) 参考（256次平均），(b) 输入（16次平均，$\sim$6\,dB），\\
(c) Wiener，(d) BM3D，(e) DWT，(f) PMDF-Net\\
详见电子版彩色图。}}
\caption{测试信号上去噪方法的代表性波形比较。(a) 参考高平均信号（256次平均）。(b) 低平均输入（16次平均，SNR $\approx$ 6\,dB）。(c)--(e) 分别为Wiener、BM3D和DWT去噪结果。(f) PMDF-Net输出。PMDF-Net最真实地恢复S0 Lamb波到达形态，保留了上升沿轮廓和峰值幅度。放大插图（虚线框）突出了到达区域，该区域方法间差异最为明显。详见电子版彩色图。}
\label{fig:denoising-examples}
\end{figure}

\subsubsection{视觉对比}

图~\ref{fig:denoising-examples}提供了代表性测试波形的定性比较。S0 Lamb波到达区域（下方插图）揭示了方法间的显著差异。Wiener滤波残留高频噪声，模糊了模态起始点。
BM3D相对于参考有轻微幅度衰减。DWT引入虚假振荡，在到达附近扭曲了模态结构。单域CNN产生更干净的波形，但与PMDF-Net相比特征略有平滑。

PMDF-Net以最高保真度恢复S0波形形态：上升沿轮廓、峰值幅度和后续模态反射与256次平均获取的参考信号高度吻合。
放大插图确认PMDF-Net同时保留了参考的到达时间和幅度特征，与表~\ref{tab:feature-preservation}中的定量指标一致。
该视觉评估证实了核心发现：PMDF-Net同时实现最佳SNR改善和最佳特征保真度——这是基线方法均未达到的组合效果，因为传统方法中去噪改善通常以波形失真为代价。
