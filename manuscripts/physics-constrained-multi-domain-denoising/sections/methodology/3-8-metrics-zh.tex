\subsection{评估指标}
\label{sec:metrics}

性能从三个方面进行评估：去噪保真度、声学特征保留和缺陷检测能力。所有指标按试样计算，并在测试集上报告为均值 $\pm$ 标准差，统计显著性在 $p < 0.05$ 下评估。

\textbf{去噪保真度。} 主要指标是信噪比(SNR)改善：
\begin{equation}
\Delta\text{SNR} = \text{SNR}_{\text{out}} - \text{SNR}_{\text{in}},
\end{equation}
其中 $\text{SNR}_{\text{in}}$ 和 $\text{SNR}_{\text{out}}$ 分别从输入—参考和去噪—参考信号对计算。此外，均方误差(MSE) 和归一化均方误差(NMSE $= \| \hat{y} - y \|_2^2 / \| y \|_2^2$) 量化与高平均参考的偏差。波形相似性使用 Lin 一致性相关系数(CCC)评估：
\begin{equation}
\text{CCC} = \frac{2\rho\sigma_{\hat{y}}\sigma_{y}}{\sigma_{\hat{y}}^2 + \sigma_{y}^2 + (\mu_{\hat{y}} - \mu_{y})^2},
\end{equation}
其中 $\mu$ 和 $\sigma$ 表示均值和标准差，$\rho$ 是去噪输出 $\hat{y}$ 与参考 $y$ 之间的 Pearson 相关系数。

\textbf{特征保留。} 到达时间（TOA）误差以样本为单位测量，作为 $\hat{y}$ 与 $y$ 之间互相关的 argmax 偏移量，使用采样周期转换为微秒。幅值误差是相对峰值误差 $|A_{\text{peak}}^{\hat{y}} - A_{\text{peak}}^{y}| / A_{\text{peak}}^{y} \times 100\%$，其中峰值幅值取门控波形窗口内的最大绝对值。波形包络相似性评估为在每个信号的 Hilbert 包络上计算的相关系数(CCC)，捕获与相位无关的形态保留。

\textbf{缺陷检测。} 对于缺陷存在分类，报告 F1 分数作为精确率和召回率的调和均值。检测概率（POD）曲线通过绘制检测概率与已知缺陷尺寸（平底孔的深度和直径）的关系构建，报告 $50\%$ 检测阈值作为最小可检测缺陷尺寸。ROC 曲线下面积（AUC）量化所有工作点下的判别能力。

\textbf{统计分析。} 给定测试试样数量有限，使用 Wilcoxon 符号秩检验（配对、双侧）跨试样评估统计显著性，并应用 Holm--Bonferroni 校正进行多次比较。当 $p < 0.05$ 时认为结果显著。