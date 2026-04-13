---
name: aw-research
description: |
  GSDAW Research Agent — literature search and analysis.
  Triggers when user approves Research Brief (after aw-discuss-1), or runs /aw-research.
  Reads research-brief.json to understand the research question, then searches the
  user's Zotero library (local SQLite, then HTTP API fallback, then PDF folder).
  Analyzes top 20 papers, generates literature matrix, identifies research gaps.
  Output: .planning/literature.md.
---

# GSDAW Research Agent

## Purpose

Perform literature research and gap analysis for academic writing. Reads the Research Brief to understand the research question, then searches for relevant papers using a cascade: **local Zotero SQLite → Zotero HTTP API → user-provided PDF folder**. Analyzes the top 20 most relevant papers and generates a structured Literature Summary.

## When to Trigger

- User approves Research Brief in Discuss #1 (`aw-discuss-1`)
- User explicitly runs `/aw-research` command
- Parallel with `aw-methodology` agent after Discuss #1 approval

## Cascade Access Strategy

```
1. Local Zotero SQLite  (priority — no API key needed, fastest)
        ↓ fail / not found
2. Zotero HTTP API       (ask user for API key)
        ↓ fail / not available
3. User-provided PDFs    (user points to a folder of PDFs)
```

The agent tries each step in order. At each step:
- Success → proceed with that source
- Failure → log reason, try next step
- Exhausted all → report error with specific diagnosis

## Step 1: Read Research Brief

Read `.planning/research-brief.json` to extract:

```json
{
  "research_question": {
    "problem": "what problem to solve",
    "existingGaps": "why existing methods fail",
    "novelty": "what makes this work novel"
  },
  "research_approach": {
    "strategy": "high-level approach"
  },
  "constraints": {
    "targetVenue": "journal/conference name"
  }
}
```

Extract keywords for search:
- Problem domain keywords
- Method/approach keywords
- Application area keywords

## Step 2: Cascade Literature Search

### Source 1: Local Zotero SQLite (Priority)

**Detection:**

```python
# Auto-discover Zotero data directory
candidates = [
    "~/Zotero",
    "~/Library/Application Support/Zotero",
    "~/.zotero/zotero",
    "~/.config/Zotero",
]
# Look for zotero.sqlite in candidates
```

**Zotero data structure:**
```
~/Zotero/
├── zotero.sqlite          # Local database (read-only copy)
└── storage/               # PDF attachments
    ├── {itemKey}/
    │   └── Authors - Year - Title.pdf
    └── ...
```

**Script:** Use `skills/zotero-context-injector/scripts/build_zotero_context.py`

```bash
python3 skills/zotero-context-injector/scripts/build_zotero_context.py \
  --zotero-data-dir "$HOME/Zotero" \
  --collection "My Library/Your Collection" \
  --query "keyword1 keyword2 keyword3" \
  --max-items 20 \
  --top-paragraphs 5 \
  --output .planning/.zotero-temp.md \
  --json-output .planning/.zotero-temp.json
```

**PDF Extraction:** Uses `markitdown` CLI (conda install: `conda install -c conda-forge markitdown`). Converts PDF to structured Markdown for cleaner text extraction. Falls back to `pdftotext` CLI if markitdown is not available.

**If local Zotero found:**
```
✓ 使用本地 Zotero 数据库: ~/Zotero
  发现 [N] 篇相关论文，开始分析...
```

**If local Zotero NOT found:**
```
⚠ 未检测到本地 Zotero 数据库
  尝试下一步: Zotero HTTP API...
```

### Source 2: Zotero HTTP API (Fallback 1)

**When to use:**
- Local SQLite not found or not accessible
- User has Zotero account with relevant papers

**Setup:**

1. Check environment variable:
   ```bash
   echo $ZOTERO_API_KEY   # If empty, try next
   ```

2. If not set, ask user:
   ```
   未检测到 Zotero API Key。请提供：
   1. 你的 Zotero API Key（从 https://www.zotero.org/settings/keys 获取）
   2. 或者你的 Zotero User ID（从 https://www.zotero.org/settings 获取）
   ```

**API Usage:**
```bash
# Search user's library
curl -H "Zotero-API-Key: $ZOTERO_API_KEY" \
  "https://api.zotero.org/users/{userID}/items?v=3&q={keywords}&limit=50&format=json"

# Get items from a collection
curl -H "Zotero-API-Key: $ZOTERO_API_KEY" \
  "https://api.zotero.org/users/{userID}/collections/{collectionID}/items?v=3&limit=100"
```

**Rate limit:** 100 requests/second. Add 50ms delay between requests. Handle 429 with exponential backoff.

**If API works:**
```
✓ 使用 Zotero API（用户库）
  获取 [N] 篇论文，开始分析...
```

**If API fails or unavailable:**
```
⚠ Zotero API 不可用
  尝试下一步: 用户提供 PDF 文件夹...
```

### Source 3: User-Provided PDF Folder (Fallback 2)

**When to use:**
- No Zotero database and no API key
- User has PDFs stored elsewhere

**Ask user:**
```
请提供包含 PDF 文献的文件夹路径。
例如: /Users/you/Documents/papers 或 ~/research/pdfs

支持以下格式:
- 直接的 PDF 文件（.pdf）
- 子文件夹中的 PDF 文件
```

**Process folder:**
```bash
# Extract each PDF to Markdown using markitdown
for pdf_path in $(find "$folder" -name "*.pdf" -type f); do
    markitdown "$pdf_path" -o "${pdf_path%.pdf}.md"
done

# Read the generated .md files
for md_path in $(find "$folder" -name "*.md" -type f); do
    cat "$md_path"
done
```

**If user provides folder:**
```
✓ 找到 [N] 个 PDF 文件，开始分析...
```

**If no PDFs found:**
```
✗ 指定的文件夹中未找到 PDF 文件
  请确认路径正确且包含 .pdf 文件。
```

### Search Query Generation

Generate 3-5 search queries from research question keywords:

**Example:**
- Research question: "deep learning for medical image segmentation"
- Generated queries:
  1. `"deep learning medical image segmentation"`
  2. `"CNN U-Net medical imaging segmentation"`
  3. `"neural network medical image segmentation CNN"`
  4. `"deep learning image segmentation medical applications"`
  5. `"semantic segmentation medical images deep learning"`

For each source, generate queries that combine:
- Primary problem keywords
- Method keywords
- Application domain

## Step 3: Paper Analysis (Top 20)

For each of the top 20 papers, extract:

| Field | Source | Notes |
|-------|--------|-------|
| Title | Metadata | Full title |
| Authors | Metadata | First author + et al. |
| Year | Metadata | Publication year |
| Venue | Metadata | Journal/conference |
| Method/Approach | Abstract/PDF | Technical approach |
| Dataset(s) | Abstract/PDF | Data used for evaluation |
| Key Results | Abstract/PDF | Quantitative results |
| Limitations | PDF | Weaknesses, failure modes |
| Relation to My Research | Analysis | How it connects to user's work |

**Priority Order:**
1. Recent papers (2022+) from top venues
2. Highly cited foundational papers
3. Papers directly addressing the research gap
4. Papers using similar methods/datasets

## Step 4: PDF Reading Pipeline

For papers where abstract is insufficient:

```bash
# Extract PDF to Markdown using markitdown
markitdown "/path/to/paper.pdf" -o /tmp/paper.md

# Read the Markdown content
cat /tmp/paper.md
```

**markitdown** produces cleaner, structured Markdown output with headers, lists, and tables preserved — easier for the agent to parse and extract key claims than raw pypdf text.

**Evidence passage ranking** (used by `build_zotero_context.py`):
```
score = keyword_hits + min(paragraph_length, 1200) / 120000
```

Higher keyword hit rate + reasonable length → ranked higher.

**Sub-agent analysis prompt:**
```
Analyze this paper and extract:
1. Research question/objective
2. Method proposed
3. Dataset(s) used
4. Key quantitative results
5. Limitations identified
6. How it relates to: [user's research question]

Paper text:
[paper_text_here]
```

## Step 5: Output Literature Summary

Write to `.planning/literature.md`:

```markdown
# Literature Summary

**Research Question:** [from brief]
**Generated:** [ISO date]
**Papers Analyzed:** [count]
**Source:** [local Zotero / Zotero API / PDF folder]

## Related Work by Category

### Category: [Method Type A]

| Paper | Year | Method | Dataset | Key Result | Gap Addressed |
|-------|------|--------|---------|------------|---------------|
| [Citation] | 2023 | Transformer | ImageNet | 95.2% acc | Long-range dependencies |
| [Citation] | 2022 | CNN | Pascal VOC | 89.3% mIoU | Local feature capture |

### Category: [Method Type B]

| Paper | Year | Method | Dataset | Key Result | Gap Addressed |
|-------|------|--------|---------|------------|---------------|
| [Citation] | 2023 | GAN | Cityscapes | FID 15.3 | Image quality |

## Research Gaps

1. **[Gap 1]:** [description of unsolved problem]
   - Identified by: [paper1], [paper2]
   - Why it matters: [reasoning]

2. **[Gap 2]:** [description of failed approach]
   - Identified by: [paper3]
   - Why approaches failed: [reasoning]

## My Research Positioning

**Gap I Fill:** [specific gap from user's brief]
**Why Existing Methods Fail:** [reason from brief]
**How My Approach Addresses:** [how user's approach solves the gap]

## Key References (Must Cite)

- [paper1] - Foundational work, widely cited
- [paper2] - Direct comparison baseline
- [paper3] - Methodology foundation
- [paper4] - Dataset used in this field
- [paper5] - Recent advance in the field

## References

@article{paper1,
  author = {Author, Name and Author, Name},
  title = {Paper Title},
  journal = {Journal Name},
  year = {2023}
}

[... additional BibTeX entries ...]
```

## Step 6: Post-Completion

After generating Literature Summary:

```
文献调研完成。

来源: [local Zotero / Zotero API / PDF folder]
已分析 [X] 篇相关论文，发现：
- [N] 个方法类别
- [M] 个研究空白

关键发现：
1. [key finding 1]
2. [key finding 2]

下一步：Discuss #2 — 一致性检查（将 Research 结果与 Methodology 对比）
```

## Error Handling Summary

| Scenario | Handling |
|----------|----------|
| Local Zotero found | Use `build_zotero_context.py` directly |
| Local Zotero not found | Try Zotero HTTP API |
| No API key | Ask user for key or PDF folder |
| PDF folder provided | Extract + analyze PDFs with markitdown |
| PDF extraction fails | Use abstract only, note limitation |
| < 20 papers found | Note coverage gap, proceed with available |
| Rate limited (429) | Wait 1s, exponential backoff retry |

## File Outputs

| File | Location | Created By |
|------|----------|------------|
| Literature Summary | `.planning/literature.md` | aw-research |
| Zotero temp JSON | `.planning/.zotero-temp.json` | build_zotero_context.py |
| Zotero temp MD | `.planning/.zotero-temp.md` | build_zotero_context.py |

## Integration

```
aw-questioner → aw-discuss-1 → [aw-research + aw-methodology] → aw-discuss-2 → aw-planner
```

- **Receives from:** `aw-discuss-1` (Research Brief approval)
- **Receives from:** `.planning/research-brief.json`
- **Outputs to:** `.planning/literature.md`
- **Sends to:** `aw-discuss-2` (consistency check)

## Usage Examples

- `/aw-research` — Run after Discuss #1 approval
- (Auto-triggered after Discuss #1 approval in orchestrator flow)
