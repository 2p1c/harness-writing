# Academic Writing Template for Engineering Research

这是一个专为理工科英文学术论文写作设计的模板仓库，基于Elsevier期刊格式，集成了LaTeX工作流和AI写作辅助技能。

## ⚡ 环境要求

在开始之前，确保您的系统已安装：

### LaTeX环境
```bash
# Ubuntu/Debian
sudo apt-get install texlive-full bibtex2html

# macOS (使用Homebrew)
brew install --cask mactex

# Windows
# 下载并安装 MiKTeX: https://miktex.org/download
```

### 可选工具
```bash
# Pandoc (用于LaTeX到Word转换)
# Ubuntu/Debian: sudo apt-get install pandoc
# macOS: brew install pandoc
# Windows: https://pandoc.org/installing.html

# 图表生成工具
# PlantUML: sudo apt-get install plantuml (需要Java)
# Graphviz: sudo apt-get install graphviz
```

### AI助手技能
模板已预配置以下AI写作技能（自动安装）：
- `latex-paper-en`：LaTeX英文论文写作
- `research-paper-writer`：研究论文写作助手

## 🚀 快速开始

### 对于新用户

复制以下提示词给您的AI助手（Claude Code、Cursor等）即可开始：

```
我想使用这个学术写作模板开始写论文。请帮我：

1. 检查当前的项目结构和已安装的写作技能
2. 检查并配置LaTeX编译环境（如果缺少工具，请提供安装指导）
3. 指导我如何自定义论文模板（标题、作者、关键词等）
4. 解释各个文件夹的用途和写作工作流
5. 帮助我开始第一个章节的写作
6. 提供文献检索和引用管理的基本指导

我的研究领域是：[请描述您的研究领域]
论文主题是：[请描述您的论文主题，如果还没确定可以说"还在规划中"]
目标期刊是：[例如：Journal of Machine Learning Research, IEEE Transactions等，如果还未确定可以说"待定"]
```

### 对于熟悉用户

如果您已经熟悉该模板，可以直接使用以下命令：

```bash
# 创建新论文项目
cp -r templates/elsevier manuscripts/your-paper-name

# 进入项目目录（重要！）
cd manuscripts/your-paper-name

# 开始编译
make paper
```

## 📁 项目结构

```
academic-writing-template/
├── corpus/                 # 语料库：收集的学术表达和好句子
├── drafts/                 # 草稿箱：初步想法和混乱笔记
├── manuscripts/            # 正式论文项目目录
│   └── my-research-paper/  # 示例论文项目
├── figures/                # 图片集：收集的参考图片
├── templates/elsevier/     # Elsevier LaTeX模板
├── Makefile               # 自动化编译脚本
└── CLAUDE.md              # AI助手使用指南
```

## 🎯 核心特性

- **Elsevier期刊格式**：符合主流工程期刊要求
- **LaTeX优先工作流**：专业排版，Git友好
- **AI写作辅助**：集成 `latex-paper-en` 和 `research-paper-writer` 技能
- **模块化结构**：每章节独立文件，便于协作
- **自动化工具**：一键编译、格式转换、引用检查

## 📖 使用指南

### 第一次使用
1. 使用上面的快速开始提示词
2. AI助手会引导您完成所有设置

### 日常写作
1. 文献阅读时，将好的表达保存到 `corpus/`
2. 初步想法记录在 `drafts/`
3. 正式写作在 `manuscripts/your-project/` 中进行
4. **在项目目录下**使用 `make paper` 编译PDF

### 技能自动触发
当您进行以下操作时，AI写作技能会自动激活：
- 学术写作任务
- LaTeX编译问题
- 引用格式处理
- 文献管理

## 🛠 技术栈

- **LaTeX**：专业排版系统
- **BibTeX**：参考文献管理
- **Elsevier模板**：elsarticle文档类
- **Make**：自动化构建
- **AI技能**：写作辅助和格式优化

## 📝 写作工作流

1. **规划阶段**：在 `drafts/` 中整理思路
2. **模板准备**：复制并自定义Elsevier模板
3. **分章写作**：在各section文件中撰写内容
4. **引用管理**：维护 `references.bib` 文件
5. **编译发布**：使用LaTeX生成最终PDF

## 🔧 常用命令

**注意：以下命令需要在具体的论文项目目录下运行**

```bash
# 首先切换到您的论文项目目录
cd manuscripts/your-paper-name/

# 然后运行以下命令：

# 完整编译（包含参考文献）
make paper

# 快速编译（不处理参考文献）
make quick

# 转换为Word格式
make word

# 检查引用完整性
make check-refs

# 处理图表文件
make update-figs

# 清理临时文件
make clean
```

**示例工作流：**
```bash
# 创建新论文项目
cp -r templates/elsevier manuscripts/my-new-paper

# 进入项目目录
cd manuscripts/my-new-paper

# 编辑论文内容...
# 然后编译
make paper
```

## 💡 写作技巧

### 文献管理最佳实践
1. **收集阶段**：将好的学术表达保存到 `corpus/`
2. **引用格式**：使用标准BibTeX格式，示例：
   ```bibtex
   @article{author2024,
     title={Paper Title},
     author={Author, First and Author, Second},
     journal={Journal Name},
     year={2024},
     volume={10},
     pages={1--15}
   }
   ```
3. **引用检索**：使用Google Scholar、DBLP或期刊官网获取BibTeX

### AI技能触发指南
以下操作会自动激活AI写作技能：
- 创建或编辑LaTeX文件
- 询问学术写作相关问题
- 请求格式化帮助
- 文献引用处理

### 常见问题解决
- **编译错误**：运行 `make clean` 清理临时文件后重试
- **中文支持**：在main.tex中添加 `\usepackage[UTF8]{ctex}`
- **图片问题**：确保图片格式为PDF、PNG或JPG

## 📚 更多信息

- 详细使用指南：查看 `CLAUDE.md`
- 模板说明：查看 `templates/elsevier/README.md`
- 项目指南：每个论文项目都有独立的README

## 🔍 故障排除

### 编译问题
```bash
# 切换到您的论文项目目录
cd manuscripts/your-paper-name

# 检查LaTeX安装
which pdflatex

# 检查模板完整性
make help

# 清理并重新编译
make clean && make paper
```

### 常见错误
- **"elsarticle.cls not found"**：运行 `tlmgr install elsarticle`
- **"bibtex command not found"**：安装完整的LaTeX发行版
- **"make command not found"**：Windows用户安装Make或使用WSL

---

**🎓 开始您的学术写作之旅**：复制上面的快速开始提示词，让AI助手引导您完成第一篇论文的设置和写作！