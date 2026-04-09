# Academic Writing Template for Engineering Research

专为理工科英文学术论文设计的写作模版仓库，集成 Elsevier 期刊格式、LaTeX 编译流程、AI 写作辅助技能，以及**对抗性文本审查系统**。

---

## 核心功能

| 功能 | 说明 |
|------|------|
| **IMRAD 大纲生成** | 输入研究主题，AI 生成标准学术论文结构 |
| **LaTeX 章节撰写** | 按 Elsevier 格式撰写各章节，含正确引用格式 |
| **对抗性文本审查** | 双代理循环批评（Critic → 质疑）+ 改进（Improver → 完善）|
| **一键 PDF 编译** | 完整的 LaTeX → BibTeX → PDF 工作流 |
| **引用管理** | BibTeX 格式验证，引用一致性检查 |

---

## 环境要求

### 必需

```bash
# Ubuntu/Debian
sudo apt-get install texlive-full bibtex2html

# macOS
brew install --cask mactex

# Windows: 下载 MiKTeX https://miktex.org/download
```

### 可选

```bash
# Pandoc (LaTeX → Word 转换)
brew install pandoc

# 图表生成
brew install plantuml graphviz
```

---

## 快速开始（5 分钟上手）

### 步骤 1：告诉 AI 助手你想写什么

在 Claude Code（或支持的 AI 助手）中输入：

```
我想开始写一篇关于 [你的研究主题] 的论文，使用这个学术写作模版。
```

AI 助手会自动激活对应的写作技能，引导你完成后续步骤。

### 步骤 2：初始化论文项目

```bash
# 在 AI 助手中输入：
/newpaper 基于深度学习的医学影像诊断研究
```

这会自动：
- 创建 `manuscripts/你的论文名/` 项目目录
- 复制 Elsevier 模板结构
- 生成 `project.yaml` 元数据文件

### 步骤 3：生成论文大纲

```bash
/outline 基于深度学习的医学影像诊断研究
```

AI 会生成 IMRAD 结构的大纲，包含：
- Introduction（含背景、文献综述、研究问题）
- Methodology（研究设计、数据收集、分析方法）
- Results（主要发现、统计数据）
- Discussion（讨论、局限性、未来工作）
- Conclusion（总结、贡献）

用"可以"、"生成吧"等肯定语气表示 approval，AI 会生成对应的 LaTeX 文件。

### 步骤 4：撰写章节

```bash
/write introduction
/write methodology
```

推荐写作顺序：
1. **Methodology** - 你最清楚自己做了什么
2. **Results** - 你有数据
3. **Introduction** - 了解了背景后写更容易
4. **Discussion** - 有了结果再解读
5. **Conclusion** - 总结所有内容
6. **Abstract** - 最后写（总结全文）

### 步骤 5：对抗性审查

```bash
/review introduction
```

审查流程：
```
文本 → Critic Agent（质疑问题）→ 批判报告
       ↓
 Improver Agent（改进文本）→ 改进版本
       ↓
    你决定：继续还是接受（最多 3 轮）
```

审查会识别：
- 模糊表述（"significant"、"many" 需要量化）
- 缺失引用（没有证据支撑的断言）
- 逻辑跳跃（缺少过渡）
- 学术语气问题（口语化表达）

### 步骤 6：编译 PDF

```bash
/compile
```

运行完整编译流程：`pdflatex → bibtex → pdflatex × 2`

---

## 斜杠命令参考

| 命令 | 功能 | 示例 |
|------|------|------|
| `/newpaper <标题>` | 初始化新论文项目 | `/newpaper 机器视觉研究` |
| `/outline <主题>` | 生成 IMRAD 大纲 | `/outline 深度学习优化算法` |
| `/write <章节>` | 撰写指定章节 | `/write methodology` |
| `/review` | 对抗性文本审查 | `/review introduction` |
| `/status` | 查看写作进度 | `/status` |
| `/cite <作者年份>` | 添加引用 | `/cite LeCun 2015` |
| `/figure <描述>` | 生成图表代码 | `/figure 系统架构图` |
| `/compile` | 编译 PDF | `/compile` |
| `/check-refs` | 检查引用完整性 | `/check-refs` |

---

## 项目结构

```
harness-writing/
├── manuscripts/                 # 论文项目工作目录
│   └── my-paper/               # 你的论文项目
│       ├── project.yaml         # 元数据（标题、作者、目标期刊）
│       ├── outline.md          # 生成的大纲
│       ├── main.tex           # 主文档
│       ├── references.bib     # 参考文献
│       └── sections/          # 各章节
│           ├── abstract.tex
│           ├── introduction.tex
│           ├── methodology.tex
│           ├── results.tex
│           ├── discussion.tex
│           └── conclusion.tex
│
├── templates/elsevier/         # Elsevier 模板（来源）
│   ├── main.tex
│   ├── references.bib
│   └── sections/
│
├── corpus/                     # 学术用语语料库
├── drafts/                     # 草稿笔记
├── figures/                    # 图片参考
│
├── .agents/skills/            # AI 写作技能
│   ├── paper-outline-generator/  # 大纲生成
│   ├── latex-paper-en/         # LaTeX 撰写
│   ├── academic-review/         # 对抗性审查
│   ├── research-paper-writer/   # 工作流编排
│   ├── literature-manager/      # 引用管理
│   └── figure-integrator/       # 图表生成
│
├── Makefile                    # 编译脚本
└── CLAUDE.md                   # AI 助手指南
```

---

## 操作示例：完整论文写作流程

### 示例主题

假设你要写一篇关于"基于 Transformer 的代码补全"的论文。

### 1. 初始化项目

```
/newpaper 基于Transformer的代码补全研究
```

AI 输出：
```
✅ 项目已创建：manuscripts/transformer-code-completion/
✅ 模板已复制
✅ project.yaml 已生成

下一步建议：/outline <你的研究主题> 来生成论文结构
```

### 2. 生成大纲

```
/outline 基于Transformer的代码补全研究
```

AI 输出：
```
## 论文大纲：基于Transformer的代码补全研究

### 1. Introduction
- [ ] **1.1 Background** - 代码补全的重要性
- [ ] **1.2 Prior Work** - 现有代码补全方法及局限
- [ ] **1.3 Research Gap** - Transformer在代码补全的潜力未被充分探索
- [ ] **1.4 Research Questions** - RQ1, RQ2...
- [ ] **1.5 Contributions** - 本文贡献

### 2. Methodology
- [ ] **2.1 Dataset** - 使用的代码数据集
- [ ] **2.2 Model Architecture** - Transformer架构设计
- [ ] **2.3 Training** - 训练策略
- [ ] **2.4 Evaluation** - 评估指标

...

要生成 LaTeX 文件吗？回复"可以"继续。
```

你回复：**可以**

### 3. 撰写 Methodology

```
/write methodology
```

AI 生成完整的 LaTeX 格式 Methodology 章节，包含：
- 正确的 LaTeX 标记
- 占位符引用 `\cite{xxx}`
- 学术化表达

### 4. 审查

```
/review methodology
```

Round 1 - Critic Agent 输出：
```
## 批判报告

**BLOCKING 问题 (必须修复):**
1. "significantly better" - 缺少具体量化指标
2. 缺少与 baseline 方法的对比实验设置描述

**HIGH 问题 (建议修复):**
1. "the model was trained" - 被动语态混用，应统一

**MEDIUM 问题:**
1. 部分过渡句略显生硬
```

Round 1 - Improver Agent 输出：
```
## 改进版本

原文: "The model performed significantly better than baseline"
改进: "Our model achieved 92.3% accuracy, outperforming the baseline by 15.2 percentage points (p<0.01)"

原文: "the model was trained"
改进: "We trained the model using..."
```

你回复：**再来一轮** 或 **可以了**

### 5. 编译

```
/compile
```

AI 运行 `make paper`，报告：
```
✅ PDF 生成成功：manuscripts/transformer-code-completion/main.pdf
📄 文件大小：1.2MB
⚠️ 警告：3个引用未在 .bib 文件中找到，请检查 /check-refs
```

---

## Elsevier 格式要点

### 引用格式（必须用 numbered 格式）

```latex
% ✅ 正确
Deep learning has shown remarkable performance \cite{lecun2015deep}.
Recent work \citealp{vaswani2017attention,devlin2019bert} has advanced...

% ❌ 错误（作者-年份格式，Elsevier 不用）
Deep learning (LeCun et al., 2015) has shown...
```

### 表格格式（用 booktabs）

```latex
\usepackage{booktabs}

\begin{table}[htbp]
    \caption{Experimental Results}
    \begin{tabular}{lccc}
        \toprule
        Method & Precision & Recall & F1 \\
        \midrule
        Baseline & 78.2 & 75.1 & 76.6 \\
        Ours & 92.3 & 89.7 & 91.0 \\
        \bottomrule
    \end{tabular}
\end{table}
```

### 图表引用

```latex
% Figure 引用
As shown in Figure~\ref{fig:architecture}, ...

% Table 引用
Table~\ref{tab:results} presents the comparison.
```

---

## 故障排除

| 问题 | 解决方案 |
|------|----------|
| `elsarticle.cls not found` | `tlmgr install elsarticle` |
| `bibtex command not found` | 安装完整 LaTeX 发行版 |
| 编译后引用显示 `[?]` | 运行 `make clean && make paper`（需要 2-3 次编译）|
| 图片不显示 | 检查文件格式（PDF/PNG/JPG），确认路径正确 |
| `make: command not found` | Windows 安装 Make 或使用 WSL |

---

## 查看详细文档

| 文档 | 内容 |
|------|------|
| `CLAUDE.md` | AI 助手完整指南（含技能触发机制）|
| `.agents/skills/*/SKILL.md` | 各技能详细说明 |
| `.agents/skills/*/references/` | 参考资料（IMRAD结构、Elsevier格式等）|
| `templates/elsevier/README.md` | Elsevier 模板说明 |

---

**🎓 开始写作**：告诉 AI 助手你想研究的主题，用斜杠命令完成从大纲到 PDF 的全流程！
