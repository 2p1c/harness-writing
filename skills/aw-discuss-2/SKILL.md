---
name: aw-discuss-2
description: |
  GSDAW Discuss Agent #2 — Research vs Methodology consistency check.
  Triggers automatically after both aw-research and aw-methodology complete.
  Compares Literature Summary vs Methodology Design for consistency:
  - Does literature confirm the gap the methodology addresses?
  - Do the baselines in methodology appear in literature?
  - Are the datasets used realistic?
  Offers resolution options if conflicts found.
---

# GSDAW Discuss Agent #2 — Research vs Methodology Consistency Check

## Purpose

This is the **second checkpoint** in the GSDAW writing pipeline. It runs after parallel `aw-research` and `aw-methodology` complete. It compares the Literature Summary against the Methodology Design for logical consistency before proceeding to the Planning Agent.

## Responsibilities

1. Read `.planning/literature.md` (from Research Agent)
2. Read `.planning/methodology.md` (from Methodology Agent)
3. Run four consistency checks
4. Report findings with clear pass/warn/fail status
5. If consistent: ask user to confirm and proceed
6. If inconsistent: offer resolution options and loop back

## Workflow

```
aw-questioner
    │
    ▼
aw-discuss-1 ──► [confirm] ──► [aw-research + aw-methodology] (parallel)
                                              │
                                              ▼
                                         aw-discuss-2  ◄── You are here
                                              │
                           ┌───────────────────┼───────────────────┐
                           │                   │                   │
                      [all pass]         [inconsistent]        [warnings only]
                           │                   │                   │
                           ▼                   ▼                   ▼
                    Planning Agent      Resolution Options      User Decision
                                              │
                                    ┌─────────┼─────────┐
                                    │         │         │
                              Adjust Meth  Adjust Scope  Accept & Continue
                                    │         │
                                    ▼         ▼
                              Re-run Meth  Re-run Research
                                    │         │
                                    └────┬────┘
                                         ▼
                                    Re-check
```

---

## Step 1 — Read Both Documents

Read the following files from the current working directory:

- `.planning/literature.md` — Literature Summary from Research Agent
- `.planning/methodology.md` — Methodology Design from Methodology Agent

If either file is missing, abort with:

```
错误: 未找到必要文件。
- .planning/literature.md: [存在/不存在]
- .planning/methodology.md: [存在/不存在]

请确保 Research Agent 和 Methodology Agent 都已完成。
```

---

## Step 2 — Extract Key Information

### From `.planning/literature.md`, extract:

| Field | Where to Find |
|-------|---------------|
| Research gap(s) stated | `## Research Gaps` section |
| Methods/baselines reviewed | `## Related Work by Category` tables |
| Datasets mentioned | Tables in Related Work |
| Key references | `## Key References` or `## References` |
| Total papers analyzed | Header metadata |

### From `.planning/methodology.md`, extract:

| Field | Where to Find |
|-------|---------------|
| Problem statement | `## Technical Pipeline > Method Overview` |
| Proposed method | `## Technical Pipeline > Key Innovations` |
| Datasets used | `## Experiment Design > Datasets` table |
| Baselines compared | `## Experiment Design > Baselines` table |
| Evaluation metrics | `## Experiment Design > Evaluation Metrics` table |

---

## Step 3 — Run Four Consistency Checks

### Check 1: 研究空白对齐 (Gap Alignment)

**What to check:**
- Does the Literature's stated `research gap` match the Methodology's problem statement?
- Does the Methodology address a gap that Literature confirms exists?

**Inconsistency triggers:**
- Methodology addresses "Gap X" but Literature shows Gap X is already solved by prior work
- Methodology claims a gap but Literature provides no evidence the gap exists
- Literature shows the problem is unsolved but Methodology does not actually address that specific problem

**Example of PASS:** Literature identifies "no existing method handles X under Y conditions." Methodology proposes a method that specifically handles X under Y conditions.

**Example of FAIL:** Literature shows "Method Z already achieves 95% on this exact problem." Methodology proposes improving on that problem without acknowledging Method Z.

---

### Check 2: Baseline 覆盖 (Baseline Coverage)

**What to check:**
- Do all baselines listed in Methodology's `Baselines` table appear in Literature's references or Related Work?
- Are the baselines credible/famous enough to be legitimate comparisons?

**Warning triggers:**
- Baseline appears in Methodology but is not found in Literature → **WARNING** (may need to add citation)
- Baseline appears in Literature only as a passing mention without details → **WARNING**

**Inconsistency triggers:**
- Baseline is a well-known method but Literature shows no record of it → **INCONSISTENT** (cannot compare to something not reviewed)
- Baseline is a paper the user would need to cite but has not been analyzed → **WARNING**

**Example of PASS:** Methodology lists ResNet, ViT, and CLIP as baselines. Literature includes all three with full analysis.

**Example of WARNING:** Methodology lists "Method X" as a baseline, but Literature only mentions it briefly in passing without analyzing its approach or results.

---

### Check 3: 数据集可行性 (Dataset Reality)

**What to check:**
- Do the datasets in Methodology's `Datasets` table exist and are they publicly available?
- Are the dataset sizes and splits realistic?

**Inconsistency triggers:**
- Methodology uses "Dataset Y" but no such dataset exists (confirmed via web search)
- Dataset is proprietary/private with no public access path
- Dataset is misnamed (e.g., "ImageNet" vs correct "ImageNet-1K")

**Warning triggers:**
- Dataset exists but access requires special approval/agreement not mentioned
- Dataset is extremely small or extremely large compared to similar work
- Dataset split ratios differ from standard practice in the field

**Example of PASS:** Methodology uses CIFAR-10, Cityscapes. Literature confirms these are standard benchmarks in the field.

**Example of FAIL:** Methodology claims to use "BenchmarkV3" but no such dataset exists publicly.

---

### Check 4: 方法验证 (Approach Validation)

**What to check:**
- Does Literature show that similar approaches (to what Methodology proposes) have been attempted before?
- Is the approach plausibly grounded in prior work, or is it completely unprecedented?

**This is typically a NOTE, not a failure**, because novel approaches are expected in research. However, extreme cases warrant warning.

**Note triggers:**
- Similar approach has been tried in related fields → NOTE (this is normal and healthy)
- Approach is unprecedented but theoretically motivated → NOTE

**Warning triggers:**
- Methodology proposes a complete paradigm shift with no theoretical or empirical foundation in Literature
- Methodology ignores an entire class of proven methods and proposes something completely disconnected

**Example of NOTE:** Literature uses CNNs for task X. Methodology proposes a Transformer variant of CNN. This is a reasonable extension — not a problem.

**Example of WARNING:** Literature exclusively shows that graph-based approaches fail on this task domain. Methodology proposes an entirely graph-based solution with no bridging evidence.

---

## Step 4 — Output Consistency Report

Display the report in this exact format:

```markdown
## 一致性检查报告

**检查时间:** [ISO timestamp]
**文献调研:** .planning/literature.md
**方法设计:** .planning/methodology.md

---

### Check 1: 研究空白对齐
**状态:** ✅ 通过 / ⚠️ 警告 / ❌ 不一致
**详情:** [findings — 2-3 sentences max]

---

### Check 2: Baseline 覆盖
**状态:** ✅ 通过 / ⚠️ 警告 / ❌ 不一致
**详情:** [findings — list any missing or under-represented baselines]

---

### Check 3: 数据集可行性
**状态:** ✅ 通过 / ⚠️ 警告 / ❌ 不一致
**详情:** [findings — list any questionable datasets]

---

### Check 4: 方法验证
**状态:** ✅ 通过 / ⚠️ 警告 / ❌ 不一致
**详情:** [findings — note if approach is novel but grounded, or unprecedented]

---

**总体状态:** 全部通过 / 发现问题需处理
```

---

## Step 5 — Route Based on Overall Status

### If All Checks Pass (总体状态: 全部通过):

```
一致性检查全部通过。

文献调研发现了 [N] 篇相关工作，方法设计与文献发现一致。

- Gap Alignment:    ✅ Gap 在文献中得到确认
- Baseline 覆盖:   ✅ [X] 个 baselines 均在文献中有记录
- 数据集可行性:    ✅ 所有数据集真实可用
- 方法验证:        ✅ 方法设计有文献依据

下一步：Planning Agent 制定写作计划。
```

Ask user to confirm:

```
header: "确认"
question: "一致性检查全部通过，是否继续？"
options:
  1. "确认"         — "继续进入 Planning Agent"
  2. "需要调整"     — "我有其他调整意见"
```

#### If user selects "确认":

Proceed to `aw-planner` (or inform user that the GSDAW orchestrator will proceed).

#### If user selects "需要调整":

Ask what needs to be adjusted, then determine which agent to re-run:
- Adjust research findings → re-run `aw-research`
- Adjust methodology → re-run `aw-methodology`
- Both need changes → re-run both in parallel
- After adjustments, re-run this consistency check

---

### If Inconsistencies Found (总体状态: 发现问题需处理):

Present each conflict clearly:

```markdown
## ⚠️ 检测到不一致

需要解决以下问题后才能继续。

---

### 问题 1: [concise title]

**性质:** Gap 不一致 / Baseline 缺失 / 数据集不可用
**文献发现:** [what literature says — 1 sentence]
**方法设计:** [what methodology states — 1 sentence]
**影响:** [why this matters for the paper — 1 sentence]

---

### 问题 2: [title]
...

---
```

Then offer resolution options:

```
请选择处理方式：

1. 调整方法设计        → 回到 Methodology Agent，重新设计
2. 补充文献调研        → 回到 Research Agent，补充 [specific gap]
3. 接受不一致继续       → 解释原因，在论文中说明局限性
4. 重新开始           → 回到 Questioner，重新提问

[Or enter "q" to quit the GSDAW pipeline]
```

#### After user selects:

**Option 1 (Adjust Methodology):**
1. Note which aspects need changing
2. Tell user: `请运行 /aw-methodology 重新设计，完成后我会重新检查一致性。`
3. Stop — wait for user to re-run the agent

**Option 2 (Supplement Research):**
1. Note which gap needs more literature
2. Tell user: `请运行 /aw-research 补充调研，完成后我会重新检查一致性。`
3. Stop — wait for user to re-run the agent

**Option 3 (Accept and Continue):**
1. Ask user to write a brief justification (1-2 sentences)
2. Record the accepted inconsistency in `.planning/consistency-log.md`:
   ```markdown
   # Consistency Log

   ## Accepted Inconsistencies

   | Date | Issue | Justification |
   |------|-------|---------------|
   | [date] | [issue description] | [user-provided reason] |
   ```
3. Proceed to Planning Agent, noting the accepted limitation

**Option 4 (Restart):**
1. Clear `.planning/research-brief.json`
2. Tell user: `已重置。请重新运行 /aw-init 开始。`
3. Stop

---

## Step 6 — Post-Resolution Re-check

After user resolves issues and re-runs the relevant agent(s):

1. Re-read the updated files
2. Re-run only the affected checks
3. If new issues emerge, repeat from Step 4
4. If all issues resolved, proceed to Step 5 (ask for confirmation)

---

## Edge Cases

### Missing Files

- If `.planning/literature.md` does not exist:
  ```
  错误: 未找到文献调研文件 (.planning/literature.md)。
  请先完成 Research Agent。
  ```
- If `.planning/methodology.md` does not exist:
  ```
  错误: 未找到方法设计文件 (.planning/methodology.md)。
  请先完成 Methodology Agent。
  ```

### Malformed Files

- If either file cannot be parsed, report:
  ```
  错误: 无法解析文件内容。请检查以下文件格式：
  - .planning/literature.md
  - .planning/methodology.md
  ```

### Empty Sections

- If a section is empty (e.g., no baselines listed), treat it as **WARNING** not FAIL
- Ask user to confirm intent before failing

### Conflicting Information Within Same File

- If literature.md says X in one place and contradicts itself elsewhere → flag as **WARNING**
- Do not fail the check based on internal contradictions within the same agent's output
- Note the internal contradiction and move on

---

## Exit States

| Outcome | Next Skill |
|---------|------------|
| All checks pass, user confirms | `aw-planner` (Planning Agent) |
| Inconsistencies found, user adjusts | Re-run `aw-methodology` or `aw-research` |
| Inconsistencies found, user accepts | `aw-planner` with logged caveats |
| User restarts | End — user runs `/aw-init` again |
| Files missing | End — user must complete prior agents first |

---

## File Locations

```
.planning/
├── research-brief.json    ← Input (from aw-questioner)
├── literature.md         ← Input (from aw-research)
├── methodology.md        ← Input (from aw-methodology)
└── consistency-log.md    ← Optional output (if inconsistencies accepted)
```

---

## Usage Examples

- (Auto-triggered after `aw-research` + `aw-methodology` complete in GSDAW pipeline)
- `/aw-discuss-2` — Run consistency check manually if files exist
