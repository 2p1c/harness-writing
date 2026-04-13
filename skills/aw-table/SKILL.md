---
name: aw-table
description: Build LaTeX booktabs tables from user-provided CSV data. Ask for CSV per table need, generate .tex files, auto-insert \input{} in sections, report status.
triggers:
  - /aw-table
  - aw-table
  - build table
  - latex table
---

# Table Builder — aw-table

## Purpose

Read the active paper's `sections/` to determine which tables are needed (dataset table, baseline comparison, ablation study, results summary, etc.), prompt the user for CSV data for each table, convert CSV to LaTeX booktabs format, write `sections/tables/{name}.tex`, auto-insert `\input{tables/{name}}` at the correct location in the parent section, and report a status summary.

## Workflow

### Step 0 — Verify working directory

Must be inside an active paper project under `manuscripts/[paper-name]/`. Abort if `sections/` or `main.tex` is not found.

### Step 1 — Determine needed tables

Read `sections/methodology.tex` (or the appropriate section file) to identify table references. Look for patterns:

```
\placeholder{tab:name}
\ref{tab:name}
Table~\ref{tab:name}
```

Common table names:
- `tab:dataset` — dataset / experimental setup
- `tab:baseline` — baseline comparison
- `tab:ablation` — ablation study
- `tab:results` — results summary
- `tab:comparison` — method comparison

Build a list of table names needed.

If no table references are found, report "No tables referenced in sections — nothing to build."

### Step 2 — Collect CSV data per table

For each needed table, prompt the user:

```
请提供 {table-name} 的 CSV 数据，格式:
header1,header2,header3
row1col1,row1col2,row1col3
row2col1,row2col2,row2col3
...

(或直接粘贴 CSV 内容)
```

Accept CSV as multi-line input until the user sends an empty line or a confirmation signal (e.g., "done", "ok", "生成").

- If CSV is provided and non-empty → proceed to conversion
- If user skips or provides no data → mark as `placeholder`, write a `\placeholder{tab:name}` comment in the section, do not create a file

### Step 3 — Convert CSV to LaTeX booktabs

For each table with CSV data:

1. Parse the CSV (split on commas, trim whitespace)
2. First row = column headers
3. Determine column alignment: use `l` for text columns, `c` for numeric/short, `r` for right-aligned
4. Generate LaTeX:

```latex
\begin{table}[htbp]
  \centering
  \caption{<Caption>}
  \begin{tabular}{<cols>}
    \toprule
    <Header1> & <Header2> & <Header3> \\
    \midrule
    <Row1Col1> & <Row1Col2> & <Row1Col3> \\
    <Row2Col1> & <Row2Col2> & <Row2Col3> \\
    \bottomrule
  \end{tabular}
  \label{tab:<name>}
\end{table}
```

5. Create `sections/tables/` directory if it does not exist
6. Write to `sections/tables/{name}.tex`

### Step 4 — Auto-insert \input{} in section

After generating the table file, find the appropriate section file and insert:

```latex
% --- tab:name ---
\input{tables/{name}}
```

near the location of `\placeholder{tab:name}` or the first `\ref{tab:name}` reference in that section. Replace `\placeholder{tab:name}` if found.

### Step 5 — Report

```markdown
# Table Builder Report

| Table | Status | File |
|-------|--------|------|
| tab:dataset | ✅ Generated | sections/tables/dataset.tex |
| tab:baseline | ✅ Generated | sections/tables/baseline.tex |
| tab:ablation | ⚠️ Placeholder | (no CSV provided) |
| tab:results | ✅ Generated | sections/tables/results.tex |

Generated: 3 | Placeholder: 1 | Skipped: 0
```

## LaTeX booktabs Template

```latex
\begin{table}[htbp]
  \centering
  \caption{Caption text}
  \begin{tabular}{lccc}
    \toprule
    Header1 & Header2 & Header3 \\
    \midrule
    Row1 & val1 & val2 \\
    Row2 & val3 & val4 \\
    \bottomrule
  \end{tabular}
  \label{tab:name}
\end{table}
```

## Rules

- Column separators must be `&`
- Use `\toprule`, `\midrule`, `\bottomrule` from `booktabs` package
- Do NOT use vertical rules (`|` in tabular preamble)
- caption goes ABOVE the tabular
- Always include `\label{tab:name}`

## Error Handling

- CSV malformed → warn user, show expected format, do not generate file
- Cannot write to `sections/tables/` → abort with error, do not update section
- Table reference found but no section file contains it → warn, skip auto-insert
- Empty CSV → treat as placeholder

## CSV Format Reference

```
Method,PSNR (dB),SSIM,Time (s)
SRCNN,30.2,0.882,1.2
ESPCN,31.5,0.903,0.4
EDSR,32.1,0.912,8.6
```

Accepts:
- Commas as separators
- Optional spaces around values
- Empty lines (skipped)
- Lines starting with `#` (comment, skipped)
