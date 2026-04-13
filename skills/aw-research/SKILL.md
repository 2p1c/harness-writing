---
name: aw-research
description: |
  GSDAW Research Agent — literature search and analysis.
  Triggers when user approves Research Brief (after aw-discuss-1), or runs /aw-research.
  Reads research-brief.json to understand the research question, then searches Zotero API
  (primary) + Semantic Scholar / arXiv (fallback) for relevant papers. Analyzes top 20 papers,
  generates literature matrix, identifies research gaps. Output: .planning/literature.md.
---

# GSDAW Research Agent

## Purpose

Perform literature research and gap analysis for academic writing. Reads the Research Brief to understand the research question, then searches for relevant papers using Zotero API (primary) and web search (fallback). Analyzes the top 20 most relevant papers and generates a structured Literature Summary.

## When to Trigger

- User approves Research Brief in Discuss #1 (`aw-discuss-1`)
- User explicitly runs `/aw-research` command
- Parallel with `aw-methodology` agent after Discuss #1 approval

## Workflow

```
.research-brief.json (input)
         │
         ▼
┌─────────────────────────────────────────────────┐
│  LITERATURE SEARCH                              │
│  1. Query Zotero API (primary)                  │
│  2. Fallback: Semantic Scholar + arXiv         │
│  3. Collect 20+ most relevant papers            │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  PAPER ANALYSIS                                 │
│  For each paper:                                │
│  - Extract metadata (title, authors, year)      │
│  - Extract method, dataset, results            │
│  - Identify limitations                         │
│  - Map to research question                    │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│  GAP ANALYSIS                                    │
│  - Identify unsolved problems                   │
│  - Identify failed approaches                   │
│  - Position user's research                     │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
.planning/literature.md (output)
```

## Step 1: Read Research Brief

Read `.planning/research-brief.json` to extract:

```json
{
  "researchQuestion": {
    "problem": "what problem to solve",
    "existingGaps": "why existing methods fail",
    "novelty": "what makes this work novel"
  },
  "researchApproach": {
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

## Step 2: Literature Search

### Primary: Zotero API

```bash
# Get user/library items from a collection
curl -H "Zotero-API-Key: $ZOTERO_API_KEY" \
  "https://api.zotero.org/users/{userID}/collections/{collectionID}/items?v=3&limit=100"

# Or search user's entire library
curl -H "Zotero-API-Key: $ZOTERO_API_KEY" \
  "https://api.zotero.org/users/{userID}/items?v=3&q={keywords}&limit=50"
```

**Zotero API Key Handling:**
1. Check environment variable `ZOTERO_API_KEY`
2. If not set, check `.planning/config.json` for stored credentials
3. If no credentials available, skip Zotero and use web search directly
4. Warn user: "No Zotero API key found. Using web search for literature."

**Rate Limiting:**
- Zotero API: 100 requests/second max
- Add 50ms delay between requests
- Handle 429 (rate limit) with exponential backoff

### Fallback: Web Search

If Zotero returns < 20 papers, search Semantic Scholar and arXiv.

**Semantic Scholar API:**
```bash
# Search for papers
curl "https://api.semanticscholar.org/graph/v1/paper/search?query={query}&limit=20&fields=title,authors,year,venue,abstract,methodology,datasetS,results"

# Get paper by DOI
curl "https://api.semanticscholar.org/graph/v1/paper/DOI:{doi}?fields=title,authors,year,venue,abstract,methodology,datasetS,results"
```

**arXiv API:**
```bash
# Search by keywords
curl "https://export.arxiv.org/api/query?search_query=all:{keywords}&start=0&max_results=20&sortBy=relevance&sortOrder=descending"
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
# Download PDF from Zotero attachment
curl -L -o paper.pdf "https://api.zotero.org/users/{userID}/items/{itemKey}/file"

# Extract text using pdfminer.six
python3 -c "
from pdfminer.high_level import extract_text
text = extract_text('paper.pdf')
print(text[:5000])  # First 5000 chars for summarization
"
```

**Sub-agent Summary Prompt:**
```
Analyze this paper and extract:
1. Research question/objective
2. Method proposed
3. Dataset(s) used
4. Key quantitative results
5. Limitations identified

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

已分析 [X] 篇相关论文，发现：
- [N] 个方法类别
- [M] 个研究空白

关键发现：
1. [key finding 1]
2. [key finding 2]

下一步：Discuss #2 — 一致性检查（将 Research 结果与 Methodology 对比）
```

## File Outputs

| File | Location | Created By |
|------|----------|------------|
| Literature Summary | `.planning/literature.md` | aw-research |
| Literature Cache | `.planning/.literature-cache.json` | aw-research (optional, for session reuse) |

## Error Handling

| Scenario | Handling |
|----------|----------|
| No Zotero API key | Skip Zotero, use web search only |
| Zotero returns 0 items | Use web search immediately |
| Web search fails | Try alternative search engine, then report error |
| PDF extraction fails | Use abstract only, note limitation |
| < 20 papers found | Note coverage gap, proceed with available |
| Rate limited | Wait with backoff, retry |

## Integration

```
aw-questioner → aw-discuss-1 → [aw-research + aw-methodology] → aw-discuss-2 → aw-planner
```

- **Receives from:** `aw-discuss-1` (Research Brief approval)
- **Receives from:** `.planning/research-brief.json`
- **Outputs to:** `.planning/literature.md`
- **Sends to:** `aw-discuss-2` (consistency check)

## Usage Examples

- `/aw-research`
- (Auto-triggered after Discuss #1 approval)
