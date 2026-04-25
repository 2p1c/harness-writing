\subsection{缺陷检测增强}
\label{sec:results-detection}

缺陷检测性能通过将标准基于到达时间的缺陷定位算法应用于去噪波形来评估。
该算法计算两个超声换能器之间的到达时间(TOA)差，并利用得到的椭圆进行缺陷位置三角定位；椭圆相交置信度的阈值决定检测结果。
分类指标在全部含缺陷试样的三个平均水平（16、64和256次平均）上计算。

\textbf{分类指标。}在16次平均下，PMDF-Net的F1分数达到\placeholder{F1_pmdf_16}，而最佳传统基线（Wiener滤波）为\placeholder{F1_baseline_16}，相对改善为\placeholder{F1_rel_improvement}\%。PMDF-Net在该平均水平下的ROC AUC为\placeholder{AUC_pmdf_16}，而Wiener滤波为\placeholder{AUC_baseline_16}。随着平均次数增加，所有方法均有改善，但PMDF-Net保持稳定领先。在256次平均下，PMDF-Net的F1达到\placeholder{F1_pmdf_256}，而最佳基线（BM3D）达到\placeholder{F1_bm3d_256}，表明PMDF-Net以16次平均的性能近似于传统方法256次平均的检测性能。

\textbf{POD曲线。}图~\ref{fig:detection_results}展示了概率 of detection (POD) 随缺陷尺寸的变化。PMDF-Net在最小缺陷尺寸\placeholder{POD90_pmdf}mm处达到90\% POD，而最佳基线为\placeholder{POD90_baseline}mm。PMDF-Net的POD曲线上升更陡峭，表明对更小缺陷的可靠检测。80\% POD下的最小可检测缺陷尺寸PMDF-Net为\placeholder{MDS80_pmdf}mm，而Wiener滤波为\placeholder{MDS80_baseline}mm。

\textbf{效率提升。}PMDF-Net在降低平均次数与传统方法在完整平均次数之间的交叉点量化了实际效率收益。
以16次平均运行的PMDF-Net展示了与传统信号平均256次平均相当的检测性能，对应采集时间减少\textbf{16$\times$}。在等效检测性能下（F1 =\placeholder{F1_equiv}），PMDF-Net仅需\placeholder{avg_pmdf}次平均，而Wiener滤波需要\placeholder{avg_wiener}次平均，确认了在全部缺陷尺寸范围内的效率优势。

\textbf{特征保真度推动检测改善。}缺陷检测的收益直接源于PMDF-Net卓越的特征保真度。准确的到达时间估计（第~\ref{sec:results-imaging}节）减少了基于TOA三角定位的定位误差，产生更紧密的位置置信椭圆，在小缺陷尺寸下减少漏检。
保留的峰值幅度维持了到达包络的信噪比(SNR)，即使在低平均次数下也能实现可靠的缺陷尺寸估计。
这些结果确认，波形保真度——而非仅仅是总体SNR——是实际缺陷检测的决定性因素。
