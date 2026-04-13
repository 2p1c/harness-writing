---
name: latex-live-preview
description: Real-time LaTeX PDF preview with live reload. Triggers when user says "live preview", "实时预览", "打开预览", "/preview" during paper writing. Starts a local web server that auto-compiles and refreshes the PDF when .tex files change.
---

# LaTeX Live Preview

Real-time LaTeX compilation with browser PDF preview. When you save a `.tex` file, the browser automatically refreshes to show the updated PDF.

## Prerequisites

Before starting, verify these tools are installed:

```bash
which latexmk   # LaTeX build tool (comes with TeX Live / MacTeX)
which fswatch    # macOS file watcher (brew install fswatch)
# Linux users: use inotifywait instead (apt install inotify-tools)
```

If `latexmk` is missing:
- **macOS**: `brew install --cask mactex`
- **Linux**: `sudo apt install texlive-latex-base latexmk`
- **Windows**: Install TeX Live via https://texlive.org

## Workflow

### Step 1: Detect Project

Find the paper project directory. Look for `main.tex` in standard locations:

```
manuscripts/<paper-name>/main.tex
```

If no `main.tex` found, ask the user which directory to serve.

### Step 2: Check Prerequisites

Run `scripts/check-prereqs.sh` to verify:
- `latexmk` is available
- `fswatch` or `inotifywait` is available
- Port 3000 is free

### Step 3: Start Preview Server

Run `scripts/start-preview.sh <project-dir>`:

```bash
./scripts/start-preview.sh manuscripts/my-paper/
```

This will:
1. Start `latexmk -pvc -pdf` in the project directory (watches for .tex/.bib changes)
2. Start `pdf-live-server` on port 3000 (serves PDF with auto-refresh)
3. Open browser to `http://localhost:3000`

### Step 4: Write and Save

As the user writes in LaTeX and saves `.tex` files:
- `latexmk` detects the change and recompiles
- New PDF is written
- `pdf-live-server` detects PDF change and refreshes the browser

### Step 5: Stop Server

When the user says "stop preview" or "/stop-preview":

```bash
./scripts/stop-preview.sh
```

This kills the latexmk and pdf-live-server processes.

## Architecture

```
.tex files → latexmk (auto-compile) → .pdf
                                          ↓
                              pdf-live-server :3000
                                          ↓
                                    Browser (auto-refresh)
```

## Port Configuration

Default port is 3000. To change:

```bash
PORT=8080 ./scripts/start-preview.sh <project-dir>
```

## Error Handling

If PDF fails to compile:
- `latexmk` prints errors to console
- Browser shows the last successful PDF (no crash)
- Common errors: undefined references, missing `.bib` entry, syntax errors

## Skill Trigger Check

When the user starts writing a paper section, proactively ask:

> "Would you like me to start a live LaTeX preview? This will open a browser window that auto-refreshes as you save."

Do NOT activate automatically on every `.tex` file open — only when the user explicitly requests or confirms.
