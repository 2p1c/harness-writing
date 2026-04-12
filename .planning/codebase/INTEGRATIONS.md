# External Integrations

## No External API Integrations

This is a standalone skill workspace with no external API dependencies.

## Local Tool Integrations

| Tool | Purpose | Fallback |
|------|---------|----------|
| **pdflatex** | PDF compilation | Must be installed |
| **bibtex** | Bibliography processing | Included in LaTeX distro |
| **pandoc** | DOCX export | `make word` fails gracefully |
| **PlantUML** | UML diagrams | Skipped if not found |
| **Graphviz** | DOT diagrams | Skipped if not found |

## GitHub Integration

- **GitHub MCP** (`mcp__plugin_ecc_github__*`) — used for repo operations, PRs, issues
- **Repository** — https://github.com/harness-writing/harness-writing

## Web Search Integration

- **WebSearch** — enabled in permissions for research
- **exa web search** — enabled for broad research queries

## Zotero Integration

- **zotero-context-injector skill** — imports PDFs from Zotero library into writing context
- Uses Zotero MCP or file-based PDF import

## Browser/Preview Integration

- **pdf-live-server** — Node.js HTTP server for PDF preview
- **Live reload** — browser auto-refresh via polling
- Configured in `latex-live-preview` skill scripts

## File References

- `.claude/settings.local.json` — permitted tool access
- `skills/zotero-context-injector/SKILL.md` — Zotero import workflow
