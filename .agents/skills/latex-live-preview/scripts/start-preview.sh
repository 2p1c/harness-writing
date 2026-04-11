#!/bin/bash
# LaTeX Live Preview - Start Script
# Usage: ./start-preview.sh <project-dir> [port]

set -e

PROJECT_DIR="${1:-.}"
PORT="${2:-3000}"
LOG_FILE="/tmp/latex-live-preview.log"

cd "$PROJECT_DIR"

echo "=== LaTeX Live Preview ==="
echo "Project: $(pwd)"
echo "Port: $PORT"
echo ""

# Find main.tex
if [ ! -f "main.tex" ]; then
    echo "ERROR: main.tex not found in $(pwd)"
    exit 1
fi

# Check for latexmk
if ! command -v latexmk &> /dev/null; then
    echo "ERROR: latexmk not found."
    echo "Install: brew install --cask mactex  (macOS)"
    echo "        sudo apt install texlive-latex-base latexmk  (Linux)"
    exit 1
fi

# Kill any existing processes on this port
if command -v lsof &> /dev/null; then
    PID=$(lsof -ti:$PORT 2>/dev/null) || true
    if [ -n "$PID" ]; then
        echo "Killing existing process on port $PORT (PID: $PID)"
        kill $PID 2>/dev/null || true
    fi
fi

# Start latexmk in preview-continuous mode
echo "Starting latexmk (file watcher + auto-compile)..."
latexmk -pvc -pdf -quiet main.tex >> "$LOG_FILE" 2>&1 &
LATEXMK_PID=$!
echo "latexmk PID: $LATEXMK_PID"

# Give latexmk time to compile the initial PDF
sleep 3

# Check if PDF was generated
if [ ! -f "main.pdf" ]; then
    echo "ERROR: PDF not generated. Check $LOG_FILE for errors."
    kill $LATEXMK_PID 2>/dev/null || true
    exit 1
fi

PDF_SIZE=$(du -h main.pdf | cut -f1)
echo "PDF generated: ${PDF_SIZE}"

# Ensure pdf-live-server is installed
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PKG_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Starting pdf-live-server on port $PORT..."

# Use the bundled Node.js pdf-live-server
node "$SCRIPT_DIR/pdf-live-server.js" main.pdf "$PORT" >> "$LOG_FILE" 2>&1 &
SERVER_PID=$!

echo "Server PID: $SERVER_PID"

# Save PIDs for stop script
echo "$LATEXMK_PID $SERVER_PID" > /tmp/latex-preview-pids.txt

# Open browser
if command -v open &> /dev/null; then
    echo "Opening browser..."
    sleep 1
    open "http://localhost:$PORT/main.pdf"
elif command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:$PORT/main.pdf"
fi

echo ""
echo "=== Preview Running ==="
echo "URL: http://localhost:$PORT/main.pdf"
echo "latexmk PID: $LATEXMK_PID"
echo "server PID: $SERVER_PID"
echo "Log: $LOG_FILE"
echo ""
echo "Save a .tex file to trigger recompile. Browser auto-refreshes."
echo "Run ./stop-preview.sh to stop."
