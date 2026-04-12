# Coding Conventions

## Language Standards

- **JavaScript (CommonJS)** — all `scripts/*.js` files use `module.exports` syntax
- **No ESM** — project uses CommonJS throughout
- **Node.js >=18** — runtime requirement

## Git Conventions

### Commit Message Format

```
<type>: <description>

Types: feat, fix, refactor, docs, test, chore, perf, ci
```

Examples from recent commits:
- `feat(latex-live-preview): rewrite preview server with Node.js polling`
- `chore: clean up redundant dirs and add latex-live-preview skill`

### Branching

- `main` — stable branch
- Paper-specific branches created via `paper-branch-by-title` skill
- Session checkpoints via `paper-session-checkpoint-commit` skill

## Skill File Convention

- Each skill lives in `skills/[name]/SKILL.md`
- Slash commands mapped in `.claude/commands/`
- Skill symlinks auto-installed via `postinstall` npm hook

## LaTeX Conventions

- **Elsevier format** — `elsarticle` document class
- **Numbered citations** — `\cite{key}` produces `[1]` style
- **booktabs tables** — mandatory for professional tables
- Bibliography style: `elsarticle-num`

## Code Style

- No explicit linter configured — `npm test` is a no-op placeholder
- Formatting left to editor defaults
- Scripts kept minimal and readable

## File Naming

- Scripts: `kebab-case.js` (e.g., `install-skill-links.js`)
- Skills: `kebab-case` directories
- Commands: `kebab-case.md`
- Papers: `kebab-case` directories under `manuscripts/`

## File References

- `package.json` — commit types align with npm scripts
- `skills/*/SKILL.md` — skill convention
- `Makefile` — LaTeX build conventions
