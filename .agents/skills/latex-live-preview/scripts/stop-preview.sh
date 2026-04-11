#!/bin/bash
# LaTeX Live Preview - Stop Script
# Usage: ./stop-preview.sh

LOG_FILE="/tmp/latex-live-preview.log"

echo "=== Stopping LaTeX Live Preview ==="

# Read PIDs
if [ -f /tmp/latex-preview-pids.txt ]; then
    read LATEXMK_PID SERVER_PID < /tmp/latex-preview-pids.txt

    echo "Killing latexmk (PID: $LATEXMK_PID)..."
    kill $LATEXMK_PID 2>/dev/null || true

    echo "Killing server (PID: $SERVER_PID)..."
    kill $SERVER_PID 2>/dev/null || true

    rm /tmp/latex-preview-pids.txt
else
    echo "No PIDs file found. Killing by port..."
    if command -v lsof &> /dev/null; then
        PIDS=$(lsof -ti:3000 2>/dev/null) || true
        if [ -n "$PIDS" ]; then
            echo "Killing processes on port 3000: $PIDS"
            echo "$PIDS" | xargs kill 2>/dev/null || true
        fi
    fi
fi

# Also kill any latexmk processes for this user
pkill -f "latexmk.*main.tex" 2>/dev/null || true

echo "=== Preview Stopped ==="
echo "Logs saved at: $LOG_FILE"
