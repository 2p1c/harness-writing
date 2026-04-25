\subsection{减少平均次数的影响}
\label{sec:discussion-averaging}

平均协议减少 16 倍（16 次 vs 256 次平均）对实验工作流程具有 substantial practical implications。在 acquisition speed 方面，16 倍的加速直接转化为 $16\times$ 的吞吐量提升，使得 high-throughput screening 和原位检测方案成为可能，否则这些方案将 prohibitively time-consuming。此外，还有试样表面累积激光通量减少 $16\times$，这在处理敏感涂层、易碎生物组织或光敏材料时至关重要，因为热累积或光漂白会 degrade sample integrity。因此，该方法不仅解决了效率问题，还解决了光学成像流程中固有的样本保存限制。

从定量角度，效率增益由以下等式 capture：PMDF-Net$+$16 次平均 $\approx$ 256 次平均，如第~\ref{sec:results} 节所示。这种近乎相等意味着网络有效地学习了一种去噪函数，否则需要 16 倍的光子预算才能实现相同效果。实际结果是研究人员可以在更严格的采集预算内运行而不牺牲图像质量，或者在相同剂量下追求更高质量。

该方法固有的权衡是需要配对的低/高平均训练数据。网络必须学习 under-averaged 和 fully-averaged 采集之间的残差映射，而不是仅从统计推断。幸运的是，本研究包含了此配对训练语料库（第~\ref{sec:method-inference} 节），确保减少平均协议得到充分验证。采用此框架的机构必须为其特定试样和成像条件建立等效的配对数据集。因此，减少平均协议将负担从推理时的光子采集转移到训练时的数据整理，这是一个有利于实际实验工作流程的权衡，在这些流程中采集时间和剂量是限制因素。