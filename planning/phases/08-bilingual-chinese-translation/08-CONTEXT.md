# Phase 8: Bilingual Chinese Translation - Context

**Gathered:** 2026-04-21
**Status:** Ready for planning
**Source:** ROADMAP.md + phase-8-design.md

<domain>
## Phase Boundary

Translate all English LaTeX sections (Phases 1-7 output) into Chinese. The phase reads English `.tex` files and produces corresponding Chinese versions with `-zh` suffix. This phase does NOT write content from scratch — it operates on existing output from earlier phases.

</domain>

<decisions>
## Implementation Decisions

### Translation Workflow
- **Approach:** Per-section sequential translation (not parallel)
- **Batch size:** Process section-by-section, paragraph by paragraph within each section
- **LaTeX handling:** Strip LaTeX commands for translation, reconstruct with structure preserved
- **Translation prompt:** Pre-defined "信达雅" academic translation expert prompt

### Technical Terminology (Locked)
- U-Net → U-Net (保留 / retained)
- BM3D → BM3D (保留 / retained)
- SNR → 信噪比 (SNR)
- CCC → 相关系数 (CCC)
- SSIM → 结构相似性指数 (SSIM)
- MSE → 均方误差 (MSE)
- FEM → 有限元方法 (FEM)
- NDT → 无损检测 (NDT)
- encoder-decoder → 编码器-解码器
- attention gate → 注意力门
- skip connection → 跳跃连接
- residual learning → 残差学习
- domain adaptation → 域适应
- AWGN → 加性高斯白噪声 (AWGN)

### File Naming
- Abstract: `abstract.tex` → `abstract-zh.tex`
- Introduction: `introduction.tex` → `introduction-zh.tex`
- Related Work: `related-work.tex` → `related-work-zh.tex`
- Methodology: `methodology.tex` → `methodology-zh.tex`
- Experiment: `experiment.tex` → `experiment-zh.tex`
- Results: `results.tex` → `results-zh.tex`
- Discussion: `discussion.tex` → `discussion-zh.tex`
- Conclusion: `conclusion.tex` → `conclusion-zh.tex`

### Translation Order
1. Abstract (shortest, establishes tone)
2. Introduction
3. Related Work
4. Methodology
5. Experiment
6. Results
7. Discussion
8. Conclusion

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project Structure
- `manuscripts/laser-ultrasound-denoising/project.yaml` — Project metadata
- `manuscripts/laser-ultrasound-denoising/main.tex` — Main LaTeX file
- `manuscripts/laser-ultrasound-denoising/references.bib` — Bibliography

### Source Files to Translate
- `manuscripts/laser-ultrasound-denoising/sections/abstract.tex`
- `manuscripts/laser-ultrasound-denoising/sections/introduction.tex`
- `manuscripts/laser-ultrasound-denoising/sections/intro/*.tex` (intro subsections)
- `manuscripts/laser-ultrasound-denoising/sections/related-work.tex`
- `manuscripts/laser-ultrasound-denoising/sections/methodology.tex`
- `manuscripts/laser-ultrasound-denoising/sections/experiment.tex`
- `manuscripts/laser-ultrasound-denoising/sections/results.tex`
- `manuscripts/laser-ultrasound-denoising/sections/discussion.tex`
- `manuscripts/laser-ultrasound-denoising/sections/conclusion.tex`

### Phase Design
- `planning/phase-8-design.md` — Phase 8 design document with full translation pipeline

### Planning Docs
- `.planning/ROADMAP.md` — Full roadmap with phase definitions
- `.planning/methodology.md` — Technical methodology for context
- `.planning/literature.md` — Literature review for context

</canonical_refs>

<specifics>
## Specific Ideas

### Translation Prompt (verbatim from ROADMAP)
```
你是一个中英文学术论文翻译专家，将用户输入的中文翻译成英文，或将用户输入的英文翻译成中文。对于非中文内容，将提供中文翻译结果。用户可以向你发送需要翻译的内容，你回答相应的翻译结果，你可以调整语气和风格，并考虑到某些词语的文化内涵和地区差异。同时作为翻译家，需将原文翻译成具有信达雅标准的译文。"信" 即忠实于原文的内容与意图；"达" 意味着译文应通顺易懂，表达清晰；"雅" 则追求译文的文化审美和语言的优美。目标是创作出既忠于原作精神，又符合目标语言文化和读者审美的翻译。一些缩写比如方法名字、人名视情况可不进行翻译。同时翻译时需要注意上下文一些名词的翻译结果的一致性。

**关键排版要求：**
1. **保留原文的换行结构** — 原文在句子边界或从句边界换行处，译文也应在对应位置换行
2. **段落间距保持不变** — 段与段之间保留空行，不要合并段落
3. **中文每行不超过80个字符** — 在句号、问号、感叹号、分号处换行
4. **LaTeX命令完整性** — \section{}、\paragraph{}、\cite{}、\ref{}、\label{}、\begin{}/\end{} 等命令必须保持完整，不可在命令中间换行
5. **数学公式不变** — $...$ 和 \[...\] 中的内容保持原样，不翻译
6. **缩进对齐** — 译文保持与原文相同的缩进层次

需要翻译的内容为：${sourceText}，请提供翻译结果并不做任何解释。
```

### LaTeX Structure to Preserve
- `\section{}` and `\subsection{}` commands
- `\cite{}` citations (keep as-is)
- `\ref{}` cross-references (keep as-is)
- Equations (`$$...$$`, `$...$`)
- Figures (`\figure{}` environment)
- Tables (`\table{}` environment)

### What to Strip and Restore
- Text content within `\section{...}` — translate
- Paragraph text — translate
- Figure captions — translate
- Table content — translate
- Keep all LaTeX commands, equations, citations intact

</specifics>

<deferred>
## Deferred Ideas

None — Phase 8 scope is fully defined by translation of existing sections.

</deferred>

---

*Phase: 08-bilingual-chinese-translation*
*Context gathered: 2026-04-21*
