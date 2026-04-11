#!/usr/bin/env node
/**
 * pdf-live-server - Simple PDF live reload server with pure polling
 * Usage: node pdf-live-server.js <pdf-file> [port]
 */

const http = require('http');
const fs = require('fs');
const path = require('path');

const pdfFile = path.resolve(process.argv[2] || 'main.pdf');
const port = parseInt(process.argv[3] || '3000', 10);
const pdfName = path.basename(pdfFile, '.pdf');
const pollInterval = 1000; // ms

let clients = [];

// Track modification time of PDF
let lastMtime = 0;
try {
  const stat = fs.statSync(pdfFile);
  lastMtime = stat.mtimeMs;
} catch (e) {}

// SSE connection pool
function notifyClients(type, data) {
  const message = `event: message\ndata: ${JSON.stringify({ type, ...data })}\n\n`;
  clients = clients.filter(res => {
    try {
      res.write(message);
      return true;
    } catch {
      return false;
    }
  });
}

// Polling watcher
setInterval(() => {
  try {
    const stat = fs.statSync(pdfFile);
    if (stat.mtimeMs > lastMtime) {
      lastMtime = stat.mtimeMs;
      notifyClients('change', { file: pdfName });
      console.log(`[${new Date().toISOString()}] PDF updated: ${pdfName}`);
    }
  } catch (e) {
    // File not ready yet, ignore
  }
}, pollInterval);

const HTML_TEMPLATE = `<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>${pdfName} - Live Preview</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { height: 100%; background: #1a1a2e; display: flex; flex-direction: column; }
    .toolbar {
      background: #16213e; padding: 10px 20px; display: flex; align-items: center;
      gap: 12px; border-bottom: 1px solid #0f3460; flex-shrink: 0;
    }
    .status {
      width: 10px; height: 10px; border-radius: 50%; background: #4ecca3;
      box-shadow: 0 0 8px #4ecca3; transition: all 0.3s;
    }
    .status.compiling { background: #f9a826; box-shadow: 0 0 8px #f9a826; }
    .status.error { background: #e74c3c; box-shadow: 0 0 8px #e74c3c; }
    .label { color: #a0a0a0; font-family: 'SF Mono', Monaco, monospace; font-size: 13px; }
    .viewer { flex: 1; overflow: hidden; display: flex; align-items: center; justify-content: center; }
    iframe { width: 100%; height: 100%; border: none; background: white; }
    .info {
      position: fixed; bottom: 10px; right: 15px; background: rgba(0,0,0,0.7);
      color: #888; font-size: 11px; padding: 4px 8px; border-radius: 4px;
      font-family: monospace;
    }
  </style>
</head>
<body>
  <div class="toolbar">
    <div class="status" id="status"></div>
    <span class="label">${pdfName}.pdf</span>
    <span class="label" id="status-text">Ready</span>
  </div>
  <div class="viewer">
    <iframe id="pdf-frame" src="${pdfName}.pdf?t=${Date.now()}"></iframe>
  </div>
  <div class="info">Auto-refresh on .tex save</div>
  <script>
    const statusEl = document.getElementById('status');
    const statusText = document.getElementById('status-text');
    const iframe = document.getElementById('pdf-frame');

    let evtSource = new EventSource('/events');
    let isReloading = false;

    evtSource.onmessage = function(e) {
      const data = JSON.parse(e.data);
      if (data.type === 'change' && !isReloading) {
        isReloading = true;
        statusEl.className = 'status compiling';
        statusText.textContent = 'Compiling...';
        // Reload iframe after a short delay to let PDF finish writing
        setTimeout(() => {
          iframe.src = '${pdfName}.pdf?t=' + Date.now();
          statusEl.className = 'status';
          statusText.textContent = 'Updated';
          setTimeout(() => {
            if (statusText.textContent === 'Updated') {
              statusEl.className = 'status';
              statusText.textContent = 'Ready';
            }
            isReloading = false;
          }, 2000);
        }, 800);
      }
    };

    evtSource.onerror = function() {
      // Silently reconnect
      setTimeout(() => {
        evtSource = new EventSource('/events');
      }, 3000);
    };
  </script>
</body>
</html>`;

const server = http.createServer((req, res) => {
  if (req.url === '/events') {
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
      'Access-Control-Allow-Origin': '*'
    });
    clients.push(res);
    req.on('close', () => {
      clients = clients.filter(c => c !== res);
    });
    return;
  }

  let filePath = req.url.split('?')[0].replace(/^\//, '');
  if (!filePath || filePath === 'index.html') {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(HTML_TEMPLATE);
    return;
  }

  const fullPath = path.join(path.dirname(pdfFile), filePath);

  try {
    const stat = fs.statSync(fullPath);
    if (stat.isFile()) {
      const ext = path.extname(fullPath).toLowerCase();
      const contentTypes = {
        '.pdf': 'application/pdf',
        '.css': 'text/css',
        '.js': 'application/javascript',
        '.html': 'text/html',
      };
      const ct = contentTypes[ext] || 'application/octet-stream';
      res.writeHead(200, {
        'Content-Type': ct,
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0'
      });
      fs.createReadStream(fullPath).pipe(res);
    } else {
      res.writeHead(404);
      res.end('Not found');
    }
  } catch {
    res.writeHead(404);
    res.end('Not found');
  }
});

server.listen(port, () => {
  console.log(`PDF Live Server running at http://localhost:${port}/`);
  console.log(`Watching: ${pdfFile}`);
  console.log(`Polling interval: ${pollInterval}ms`);
});

process.on('SIGINT', () => {
  console.log('\nShutting down...');
  server.close();
  process.exit(0);
});
