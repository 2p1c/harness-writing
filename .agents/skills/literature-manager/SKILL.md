---
name: literature-manager
description: Manage academic citations and references. Triggers when user says "add citation", "cite", "引用", "/cite", or needs to manage references.bib. Validates BibTeX entries, checks citation consistency, and ensures proper formatting.
---

# Literature Manager

## Purpose

Manage the paper's bibliography: add citations, validate BibTeX entries, ensure citation consistency.

## When to Trigger

- User says "/cite" or "add citation"
- User needs to check or clean up references
- Compilation reports citation errors
- User asks about citation format

## Citation Management Tasks

### 1. Add New Citation

```bash
/cite <author, year> or <title>
```

**Process**:
1. Parse user's citation request
2. Search for BibTeX entry (user provides or AI generates template)
3. Add to project's `references.bib`
4. Validate format compliance
5. Report citation key to use

### 2. Validate Citations

```bash
/check-refs
```

**Validates**:
- All `\cite{}` commands have entries in references.bib
- No duplicate entries
- BibTeX format is correct

### 3. List References

Shows all entries in references.bib with:
- Citation key
- Type (article, conference, book)
- Title
- Year

---

## BibTeX Entry Templates

### Journal Article
```bibtex
@article{AuthorYEAR,
  title={Paper Title},
  author={Author, A. and Author, B.},
  journal={Journal Name},
  year={2024},
  volume={10},
  number={2},
  pages={123--145},
  doi={10.xxxx/xxxxx}
}
```

### Conference Paper
```bibtex
@inproceedings{AuthorYEAR,
  title={Paper Title},
  author={Author, A.},
  booktitle={Proceedings of Conference Name},
  year={2023},
  pages={456--470},
  organization={Publisher}
}
```

### Book
```bibtex
@book{AuthorYEAR,
  title={Book Title},
  author={Author, A.},
  year={2022},
  publisher={Publisher Name},
  address={City}
}
```

### Preprint (use cautiously)
```bibtex
@misc{AuthorYEAR,
  title={Paper Title},
  author={Author, A.},
  year={2024},
  eprint={xxxxx},
  archivePrefix={arXiv},
  primaryClass={cs.XY}
}
```

---

## Citation Commands in LaTeX

| Command | Usage | Example |
|---------|-------|---------|
| `\cite{key}` | Numbered citation | `[1]` |
| `\citealp{key}` | Citation without brackets | `Author [1]` |
| `\citealp{key1,key2}` | Multiple citations | `[1,2]` |
| `\citeauthor{key}` | Author names only | `Smith et al.` |
| `\citeyear{key}` | Year only | `(2024)` |

---

## Validation Rules

### Must Have Fields

| Entry Type | Required Fields |
|------------|----------------|
| Article | author, title, journal, year |
| InProceedings | author, title, booktitle, year |
| Book | author, title, publisher, year |
| TechReport | author, title, institution, year |

### Format Rules
- **Author names**: Use "Last, First" format
- **Year**: 4 digits
- **Pages**: Use double dash: `1--10`
- **DOI**: Include when available (starts with 10.)

### Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| "Empty year" | Missing year field | Add `year={YYYY}` |
| "Undefined database" | .bib filename mismatch | Check \bibliography{filename} |
| "Repeated BIBENTRY" | Duplicate key | Change key or remove duplicate |

---

## Usage Examples

- `/cite LeCun 2015`
- `/cite add transformer paper by Vaswani`
- `/cite check my references`
- `/cite 帮我添加这篇论文`
