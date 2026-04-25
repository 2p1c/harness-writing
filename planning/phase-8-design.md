# Phase 8 Design — Bilingual Chinese Translation

## Overview

Add Chinese translations for all English LaTeX sections in the paper. The workflow writes English first, then translates to Chinese using a "信达雅" (faithfulness, expressiveness, elegance) translation prompt.

## Workflow Integration

This phase does **not** write content from scratch. It operates on output from Phases 1-7:

- Phase 1-7 write `sections/{chapter}.tex` (English)
- Phase 8 translates those files to `sections/{chapter}-zh.tex` (Chinese)

## Translation Pipeline

```
English .tex → Extract text blocks → Translate via prompt → Reconstruct .tex with Chinese
```

### Translation Prompt Template

```
你是一个中英文学术论文翻译专家，将用户输入的中文翻译成英文，或将用户输入的英文翻译成中文。对于非中文内容，将提供中文翻译结果。用户可以向你发送需要翻译的内容，你回答相应的翻译结果，你可以调整语气和风格，并考虑到某些词语的文化内涵和地区差异。同时作为翻译家，需将原文翻译成具有信达雅标准的译文。"信" 即忠实于原文的内容与意图；"达" 意味着译文应通顺易懂，表达清晰；"雅" 则追求译文的文化审美和语言的优美。目标是创作出既忠于原作精神，又符合目标语言文化和读者审美的翻译。一些缩写比如方法名字、人名视情况可不进行翻译。同时翻译时需要注意上下文一些名词的翻译结果的一致性。需要翻译的内容为：${sourceText}，请提供翻译结果并不做任何解释。
```

## Execution

For each section (Introduction, Related Work, Methodology, Experiment, Results, Discussion, Conclusion) and Abstract:

1. Read the English `.tex` file
2. Strip LaTeX commands, keeping text content
3. Send text to translation prompt (batch by paragraph to preserve context)
4. Reconstruct `.tex` preserving LaTeX structure (section headers, equations, citations)
5. Write to `sections/{chapter}-zh.tex`

## Terminology Consistency

Maintain a translation glossary for technical terms:

| English | Chinese |
|---------|---------|
| U-Net | U-Net (保留) |
| BM3D | BM3D (保留) |
| SNR | 信噪比 (SNR) |
| CCC | 相关系数 (CCC) |
| SSIM | 结构相似性指数 (SSIM) |
| MSE | 均方误差 (MSE) |
| FEM | 有限元方法 (FEM) |
| NDT | 无损检测 (NDT) |
| encoder-decoder | 编码器-解码器 |
| attention gate | 注意力门 |
| skip connection | 跳跃连接 |
| residual learning | 残差学习 |
| transfer learning | 迁移学习 |
| domain adaptation | 域适应 |
| AWGN | 加性高斯白噪声 (AWGN) |

## Output

- `sections/abstract-zh.tex`
- `sections/introduction-zh.tex`
- `sections/related-work-zh.tex`
- `sections/methodology-zh.tex`
- `sections/experiment-zh.tex`
- `sections/results-zh.tex`
- `sections/discussion-zh.tex`
- `sections/conclusion-zh.tex`

## Quality Criteria

- No untranslated English paragraphs
- Technical terms consistently localized
- LaTeX structure preserved (section commands, `\cite{}`, `\ref{}`, equations)
- Academic register maintained in Chinese
