# Elsevier Format Reference

## Document Setup

### Required Template Structure
```latex
\documentclass[review]{elsarticle}

\usepackage{lineno,hyperref}
\modulolinenumbers[5]

\journal{Journal Name}

\begin{document}

\begin{frontmatter}
\title{Paper Title}
\author[1]{First Author\corref{cor1}}
\author[2]{Second Author}

\affiliation[1]{organization={Department, University},
                city={City}, country={Country}}
\cortext[cor1]{Corresponding author}

\begin{abstract}
% 150-300 words
\end{abstract}

\begin{keyword}
keyword1 \sep keyword2 \sep keyword3
\end{keyword}
\end{frontmatter}

\linenumbers

\input{sections/introduction}
\input{sections/methodology}
% etc.

\section*{Acknowledgments}
\section*{References}
\bibliographystyle{elsarticle-num}
\bibliography{references}  % Change 'references' to match your .bib filename

\end{document}
```

### Additional Required Statements (per journal requirements)

```latex
\section*{Conflict of Interest}
The authors declare that they have no known competing financial interests...

\section*{Funding}
This work was supported by [funder name] under grant [number].

\section*{Author Contributions}
% Use CRediT taxonomy
Conceptualization: Author A.; Methodology: Author B.; Software: Author A.; Validation: Author B.; Formal analysis: Author A.; Investigation: Author B.; Resources: Author A.; Data curation: Author B.; Writing – original draft: Author A.; Writing – review \& editing: Author B.; Visualization: Author A.; Supervision: Author B.; Project administration: Author A.; Funding acquisition: Author B.

\section*{Data Availability}
Data and materials are available at [repository link] / upon reasonable request from the corresponding author.
```

### Highlights (Elsevier specific)

Place before the abstract in `\begin{frontmatter}`:
```latex
\begin{frontmatter}
\begin{highlight}
\item First highlight point (max 85 characters)
\item Second highlight point
\item Third highlight point
\item Optional fourth highlight point
\end{highlight}
% ... title, abstract, keywords
```

### Package Dependencies

Add to preamble for proper formatting:
```latex
\usepackage{booktabs}   % Professional tables
\usepackage{amsmath}    % Math formatting
\usepackage{graphicx}   % Figures
\usepackage{url}        % URL formatting
```

## Formatting Rules

### Text Formatting
- Use `\cite{key}` for citations
- Use `\citealp{key1,key2}` for multiple citations
- Use `\citeauthor{key}` for author names in text
- Do NOT use author-date formatting

### Mathematics
- Number equations sequentially
- Use `align` for multi-line equations
- Use `equation` for single equations
- Define all variables before use

### Figures
- Preferred format: PDF (vector graphics)
- Acceptable: PNG, JPG (raster, minimum 300 dpi)
- Always provide captions
- Reference figures in text: "as shown in Figure~\ref{fig:1}"

### Tables
- Use `booktabs` style for professional tables
- Avoid vertical rules
- Always provide captions
- Reference tables in text: "Table~\ref{tab:1} presents..."

## Citation Style

### Correct (Numbered)
```latex
Deep learning has shown remarkable performance \cite{lecun2015deep}.
Recent work \citealp{vaswani2017attention,devlin2019bert} has advanced...
```

### Incorrect (Author-Date - DO NOT USE)
```latex
% WRONG - Elsevier uses numbered, not author-date
Deep learning (LeCun et al., 2015) has shown...
```

## Bibliography Entry Types

### Journal Article
```bibtex
@article{author2024,
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
@inproceedings{author2023,
  title={Conference Paper Title},
  author={Author, A.},
  booktitle={Proceedings of Conference Name},
  year={2023},
  pages={456--470},
  organization={Publisher}
}
```

### Book
```bibtex
@book{author2022,
  title={Book Title},
  author={Author, A.},
  year={2022},
  publisher={Publisher Name},
  address={City}
}
```

## Common Issues

| Issue | Solution |
|-------|----------|
| "Command already defined" | Remove duplicate package loading |
| "Label(s) may have changed" | Run pdflatex twice |
| "Citation undefined" | Check \cite{} keys match .bib entries |
| "Figure file not found" | Check file path in \includegraphics{} |
| "Undefined reference" | Ensure \label{} precedes \ref{}; run pdflatex twice |
| "Undefined citation" | Run bibtex after pdflatex; check .bib file exists |
| "Overfull hbox" | Text too wide; reduce figure/table width or adjust text |
| "BibTeX warning: empty year" | Add year field to .bib entry |
| "BibTeX warning: undefined database" | Check \bibliography{filename} matches actual .bib file |
