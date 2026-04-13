# GSDAW — Get Shit Done Academic Writing

**规范驱动的学术论文写作框架。** 通过经过验证的流程串联 AI Agent：提问 → 研究 → 方法论 → 规划 → 写作 → 引用 → 图表 → 摘要 → 编译。

---

## 一键安装

```bash
npm install -g @2p1c/harness-writing
```

安装后重启 Claude Code 会话，所有技能自动发现。

---

## 环境准备

GSDAW 需要 LaTeX 环境，可选 markitdown 用于 PDF 提取。请在使用前完成安装。

### LaTeX（必装）

**macOS：**
```bash
brew install --cask mactex
```

**Linux（Debian/Ubuntu）：**
```bash
sudo apt install texlive-latex-base latexmk
```

**Windows（推荐 WSL2）：**
```bash
# 在 WSL2 中
sudo apt install texlive-latex-base latexmk
```
> 或在 Windows 原生安装 [TeX Live](https://www.tug.org/texlive/)。

### markitdown — PDF 提取（可选）

markitdown 将 PDF 转换为整洁的 Markdown，用于文献调研。

**macOS：**
```bash
conda install -c conda-forge markitdown
# 或
brew install --cask mambaforge && conda install -c conda-forge markitdown
```

**Linux：**
```bash
conda install -c conda-forge markitdown
# 或
wget "https://github.com/daltonmatos/markitdown/releases/latest/download/markitdown-x86_64-linux.tar.gz" \
  && tar -xzf markitdown-x86_64-linux.tar.gz && sudo mv markitdown /usr/local/bin/
```

**Windows：**
```powershell
# 使用 conda/mamba
conda install -c conda-forge markitdown

# 或从 GitHub releases 下载并添加到 PATH
```

---

## 开始使用

```
/aw-init
```

回答 5 类问题（研究问题、研究思路、方法论、约束条件、参考资料）→ 生成研究简报。

---

## 完整流程

```
/aw-init              → 研究简报
       ↓
/aw-execute          → 撰写所有章节（wave 并行）
       ↓
/aw-cite             → 验证引用
       ↓
/aw-table            → 生成表格（提供 CSV）
/aw-figure           → 生成图表（PlantUML + matplotlib）
       ↓
/aw-abstract         → 撰写 250 词摘要
       ↓
/aw-finalize         → make paper — 编译并验证
```

---

## 各步骤说明

### `/aw-init`
- 写作开始前按 5 个类别深度提问
- 自动检测已有研究简报 → 询问继续或新建
- `--quick` 跳过所有 Discuss 检查点

### `/aw-execute`
- 读取 ROADMAP → 按依赖关系分组为 wave
- Wave 1：无依赖任务 → 并行执行
- Wave 2+：依赖前置 wave → 每 wave 内并行
- 每 wave 结束后：质量门检查（继续/修改/暂停）
- 手动编译：准备好后自行运行 `make paper`

### `/aw-cite`
- 扫描所有 `\cite{}` 与 `references.bib` 比对
- 自动从 `literature.md` 修复缺失条目
- 每次修改章节添加引用后运行

### `/aw-table`
- 每张表询问 CSV 数据（数据集、基线、 ablation 、结果）
- 暂无 CSV → 在章节中留 `\placeholder{tab:name}`
- 自动在正确位置插入 `\input{tables/{name}}`

### `/aw-figure`
- 流程图 → PlantUML `.tex`
- 结果图 → Python matplotlib `.pdf`
- 无数据 → `\placeholder{fig:name}`
- 自动在正确位置插入 `\input{figures/fig-name}`

### `/aw-abstract`
- 读取所有章节草稿
- 综合为 250 词 IMRAD 格式摘要
- 摘要中不引用、不使用图表编号
- 所有章节完成后运行

### `/aw-finalize`
- `make paper` — 完整编译
- 检查：未定义引用、未解析引用、字数、摘要存在性
- 更新 STATE.md 为 "ready for submission"

---

## 写作顺序

方法论 → 结果 → 引言 → 讨论 → 结论 → 摘要

---

## 全部命令

| 命令 | 阶段 | 说明 |
|------|------|------|
| `/aw-init` | Init | 开始新论文 — 提问器 → 简报 |
| `/aw-execute` | Phase 2 | 执行 wave 计划 — 撰写所有章节 |
| `/aw-cite` | Phase 3 | 验证引用解析 |
| `/aw-table` | Phase 3 | 从 CSV 生成表格 |
| `/aw-figure` | Phase 3 | 生成图表 |
| `/aw-abstract` | Phase 3 | 撰写摘要 |
| `/aw-finalize` | Phase 3 | 编译并验证 |
| `/aw-review` | Any | 章节质量审查 |
| `/aw-wave-planner` | Manual | 从 ROADMAP 重新规划 wave |
| `/aw-pause` | Any | 保存写作会话（休息前） |
| `/aw-resume` | Any | 从检查点恢复写作 |

---

## 流程概览

```
/aw-init
    │
    ├── aw-questioner → research-brief.json
    ├── aw-discuss-1 → 确认简报
    ├── [research + methodology] → literature.md + methodology.md（并行）
    ├── aw-discuss-2 → 一致性检查
    ├── aw-planner → ROADMAP.md + STATE.md
    └── aw-discuss-3 → 审批计划

/aw-execute
    │
    ├── aw-wave-planner → wave-plan.md
    ├── Wave 1（并行） → aw-write-*
    ├── aw-review → 质量门
    ├── Wave 2（并行） → aw-write-*
    ├── ...
    └── phase merge → sections/{chapter}.tex

/aw-cite → /aw-table → /aw-figure → /aw-abstract → /aw-finalize

/aw-pause  →  休息前保存检查点
/aw-resume →  从检查点恢复
```

---

## 项目结构

```
manuscripts/
└── {paper-slug}/
    ├── project.yaml
    ├── references.bib
    ├── main.tex
    └── sections/
        ├── intro/
        │   ├── 1-1-background.tex
        │   └── ...
        ├── related-work/
        ├── methodology/
        ├── experiment/
        ├── results/
        ├── discussion/
        ├── conclusion/
        └── tables/
```

段落文件（`sections/{chapter}/{task-id}.tex`）是独立单元 — 每任务一个段落，由 wave executor 合并为章节 `.tex` 文件。

---

## 故障排除

| 问题 | 解决方法 |
|------|----------|
| 日志中 `Undefined reference` | 运行 `/aw-cite` 查找缺失键 |
| 引用显示 `[?]` | `make clean && make paper` |
| `elsarticle.cls not found` | `tlmgr install elsarticle` |
| 找不到 `/aw-init` | npm 安装后重启 Claude Code |
| markitdown 未找到 | 参见上文的系统安装指南 |

---

## 技能统计

24 个技能，涵盖 3 个阶段 + 会话管理。

| 阶段 | 技能 |
|------|------|
| Phase 1 — 编排 | aw-questioner, aw-discuss-1/2/3, aw-research, aw-methodology, aw-planner, aw-orchestrator |
| Phase 2 — 执行 | aw-wave-planner, aw-execute, aw-review, aw-write-intro, aw-write-related, aw-write-methodology, aw-write-experiment, aw-write-results, aw-write-discussion, aw-write-conclusion |
| Phase 3 — 完善 | aw-cite, aw-table, aw-figure, aw-abstract, aw-finalize |
| 会话管理 | aw-pause, aw-resume |

---

## License

MIT
