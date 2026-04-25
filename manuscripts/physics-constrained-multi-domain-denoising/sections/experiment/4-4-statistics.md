\subsection{Statistical Analysis Protocol}
\label{sec:experiment-stats}

All comparative evaluations between denoising methods are conducted using the Wilcoxon signed-rank test, a non-parametric paired test appropriate for the non-normal distributions observed in experimental ultrasonic signal metrics. The test is applied in a two-sided configuration to detect any systematic difference between method pairs.

\textbf{Multiple comparison correction.} When more than two methods are compared simultaneously, the family-wise error rate is controlled using the Holm--Bonferroni procedure~\cite{Holm1979}. For $k$ method comparisons, the $k$ unadjusted $p$-values are ordered $p_{(1)} \leq p_{(2)} \leq \cdots \leq p_{(k)}$; the null hypothesis for the $i$-th ordered test is rejected at level $\alpha / (k - i + 1)$. This step-down procedure is uniformly more powerful than the standard Bonferroni correction.

\textbf{Significance threshold.} All tests adopt a significance level of $p < 0.05$.

\textbf{Reporting conventions.} Metric values are reported as median $\pm$ interquartile range (IQR) across the $N$ specimens, or as mean $\pm$ standard deviation where the distribution is approximately symmetric and the sample size is sufficient to assess normality (Shapiro--Wilk test, $p > 0.05$). Each specimen contributes $M$ measurement positions; metrics are first averaged within each specimen before cross-specimen summary statistics are computed.

\textbf{Effect size.} Where statistically significant differences are identified, the effect size is reported using the rank-biserial correlation coefficient $r = Z / \sqrt{N}$, where $Z$ is the standardized test statistic from the Wilcoxon signed-rank test and $N$ is the number of paired observations. Effect sizes are interpreted as small ($|r| = 0.1$), medium ($|r| = 0.3$), or large ($|r| = 0.5$) following Cohen's conventions.
