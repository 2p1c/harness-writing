\subsection{物理约束损失函数}
\label{sec:physics-loss}

使用标准 L2（均方误差(MSE)）损失单独训练去噪网络存在一个根本局限：它最小化逐像素平方误差，隐含地倾向于过度平滑的输出，可能破坏对缺陷检测至关重要的超声特征。为此，我们设计了一个由三个互补项组成的物理约束损失函数 $\mathcal{L}_{total}$：

\begin{equation}
\mathcal{L}_{total} = \lambda_{\text{rec}} \mathcal{L}_{\text{rec}} + \lambda_{\text{phys}} \mathcal{L}_{\text{physics}} + \lambda_{\text{TV}} \mathcal{L}_{\text{TV}},
\end{equation}

其中 $\lambda_{\text{rec}}$、$\lambda_{\text{phys}}$ 和 $\lambda_{\text{TV}}$ 是经验调优的加权系数。

\textbf{重构损失。} 重构项强制去噪输出 $\hat{y}$ 与高质量参考目标 $y$ 之间的整体波形相似性：

\begin{equation}
\mathcal{L}_{\text{rec}} = \| \hat{y} - y \|_2^2.
\end{equation}

虽然 $\mathcal{L}_{\text{rec}}$ 驱动网络进行噪声抑制，但它不会显式保留诊断相关的声学特征。

\textbf{物理约束特征保留。} 物理项 $\mathcal{L}_{\text{physics}}$ 惩罚编码缺陷信息的三个波形特征的偏差：

\begin{equation}
\mathcal{L}_{\text{physics}} = \mathcal{L}_{\text{arrival}} + \mathcal{L}_{\text{amplitude}} + \mathcal{L}_{\text{morphology}},
\end{equation}

其中 $\mathcal{L}_{\text{arrival}}$ 通过基于互相关的时间对齐来测量到达时间偏差，$\mathcal{L}_{\text{amplitude}}$ 强制峰值幅值比一致性，$\mathcal{L}_{\text{morphology}}$ 使用 Lin 相关系数(CCC)量化波形包络相似性。这些项共同确保声学事件在去噪后保持时间和形态上的完整性。

\textbf{全变分正则化。} 平滑正则化项

\begin{equation}
\mathcal{L}_{\text{TV}} = \| \nabla \hat{y} \|_1
\end{equation}

惩罚基于 CNN 的去噪器典型的振荡伪影，鼓励与物理声传播一致的分段平滑输出。

\textbf{权重选择。} 损失权重在验证集上经验确定，典型平衡为 $\lambda_{\text{rec}} = 1.0$、$\lambda_{\text{phys}} \in [0.1, 1.0]$ 和 $\lambda_{\text{TV}} \in [0.01, 0.1]$。消融研究（第~\ref{sec:ablation} 节）验证了移除 $\mathcal{L}_{\text{physics}}$ 会降低特征保留指标，尽管达到更高的信噪比(SNR)，确认了物理约束对于诊断可靠去噪的必要性。