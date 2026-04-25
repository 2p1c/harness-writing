#!/usr/bin/env python3
"""
Reformat Chinese translation .tex and .md files for readability.

Preserves LaTeX commands, math expressions, and paragraph structure.
Breaks text at sentence/clause boundaries with ~80 char line target.
"""

import re
import sys
from pathlib import Path

# LaTeX constructs to protect from splitting
LATEX_PROTECTED = re.compile(
    r'\\[a-zA-Z]+(\[[^\]]*\])?\{[^}]*\}'        # \command{...} or \command[...]{...}
    r'|\\[a-zA-Z]+'                               # \command without args
    r'|\$[^\$]*\$'                                # inline math $...$
    r'|\\\[.*?\\\]'                                # display math \[...\]
    r'|\\\\'                                       # line break \\
)

CLAUSE_BREAK = re.compile(r'(?<=[。！？；])')

COMMA_BREAK = re.compile(r'(?<=[，、：；])')


def break_text(text: str, max_line: int = 80) -> str:
    """Break Chinese text at clause boundaries to keep lines readable."""
    text = text.strip()
    if not text or len(text) <= max_line:
        return text

    # Check if text is mostly Chinese (contains Chinese chars)
    has_chinese = bool(re.search(r'[一-鿿]', text))

    # For Chinese text, break at sentence ends first, then commas
    if has_chinese:
        # Phase 1: split at sentence boundaries (。！？；)
        sentences = []
        for part in CLAUSE_BREAK.split(text):
            part = part.strip()
            if not part:
                continue
            # Phase 2: if still too long, split at comma boundaries
            if len(part) > max_line:
                for sub in COMMA_BREAK.split(part):
                    sub = sub.strip()
                    if sub:
                        sentences.append(sub)
            else:
                sentences.append(part)
    else:
        # English: break at sentence boundaries (.!?)
        sentences = []
        for part in re.split(r'(?<=[.!?;])\s+', text):
            part = part.strip()
            if not part:
                continue
            if len(part) > max_line:
                for sub in re.split(r'(?<=[,:;])\s+', part):
                    sub = sub.strip()
                    if sub:
                        sentences.append(sub)
            else:
                sentences.append(part)

    if not sentences:
        return text

    # Assemble into lines of ~max_line chars
    lines = []
    current = ''
    for sent in sentences:
        if not sent:
            continue
        # +1 for space between segments
        if current and len(current) + len(sent) + 1 > max_line:
            lines.append(current)
            current = sent
        elif current:
            current += ' ' + sent if not has_chinese else sent
        else:
            current = sent

    if current:
        lines.append(current)

    return '\n'.join(lines)


def find_latex_segments(line: str):
    """Split line into [(is_latex, text)] segments."""
    segments = []
    pos = 0
    for m in LATEX_PROTECTED.finditer(line):
        start, end = m.start(), m.end()
        if start > pos:
            segments.append((False, line[pos:start]))
        segments.append((True, line[start:end]))
        pos = end
    if pos < len(line):
        segments.append((False, line[pos:]))
    return segments


def format_file(filepath: Path) -> bool:
    """Reformat a single file. Returns True if changes were made."""
    content = filepath.read_text(encoding='utf-8')
    lines = content.split('\n')
    new_lines = []
    in_protected_block = False  # inside \begin{}...\end{} or \[...\]

    for line in lines:
        stripped = line.strip()

        # Detect protected block boundaries
        if not in_protected_block:
            if stripped.startswith('\\[') or stripped.startswith('\\begin{'):
                in_protected_block = True
                new_lines.append(line)
                continue
        else:
            new_lines.append(line)
            if stripped.startswith('\\]') or stripped.startswith('\\end{'):
                in_protected_block = False
            continue

        # Preserve blank lines, comments, pure LaTeX commands
        if not stripped or stripped.startswith('%'):
            new_lines.append(line)
            continue

        # Pure LaTeX commands (no regular text) — preserve
        if LATEX_PROTECTED.fullmatch(stripped):
            new_lines.append(line)
            continue

        # Table rows with & — preserve
        if '&' in stripped:
            new_lines.append(line)
            continue

        # Text paragraphs: apply breaking
        segments = find_latex_segments(line)
        text_parts = []
        for is_latex, seg in segments:
            if is_latex:
                text_parts.append(seg)
            else:
                text_parts.append(break_text(seg))

        new_lines.append(''.join(text_parts))

    new_content = '\n'.join(new_lines)
    if new_content != content:
        filepath.write_text(new_content, encoding='utf-8')
        return True
    return False


def main():
    base_dir = Path('manuscripts')
    if not base_dir.exists():
        print('Error: manuscripts/ directory not found')
        sys.exit(1)

    files = sorted(base_dir.glob('**/*-zh.tex')) + sorted(base_dir.glob('**/*-zh.md'))
    files = [f for f in files if f.is_file()]

    if not files:
        print('No *-zh.tex or *-zh.md files found under manuscripts/')
        return

    changed = 0
    for f in files:
        try:
            if format_file(f):
                print(f'  ✓ {f}')
                changed += 1
            else:
                print(f'  - {f} (unchanged)')
        except Exception as e:
            print(f'  ✗ {f}: {e}')

    print(f'\nFormatted {changed}/{len(files)} files')


if __name__ == '__main__':
    main()
