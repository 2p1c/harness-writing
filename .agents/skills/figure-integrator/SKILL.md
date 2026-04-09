---
name: figure-integrator
description: Generate and integrate academic figures with proper formatting. Triggers when user says "add figure", "generate figure", "图表", or needs help with figure formatting. Creates figures using PlantUML/Graphviz and ensures Elsevier-compliant formatting.
---

# Figure Integrator

## Purpose

Create, format, and integrate figures into academic papers following Elsevier guidelines.

## When to Trigger

- User requests a new figure
- User needs figure formatting help
- User mentions generating diagrams
- User asks about figure placement or caption format

## Figure Generation

### Supported Tools

1. **PlantUML** - For diagrams, flowcharts, UML
2. **Graphviz** - For directed graphs, hierarchies
3. **LaTeX/TikZ** - For technical diagrams (via direct code)

### Generating a Figure

```bash
/figure <description>
```

Example:
```
/figure 生成一个系统架构图，展示数据处理流程
/figure create a flowchart for the experiment procedure
```

## Elsevier Figure Guidelines

### File Formats
- **Preferred**: PDF (vector graphics, crisp at any zoom)
- **Acceptable**: PNG, JPEG (300+ dpi required for raster)
- **Avoid**: GIF, BMP (low quality)

### Sizing
- Single column: max 8cm width
- Double column: max 17cm width
- Keep simple enough to read at print size

### Caption Placement
```latex
\begin{figure}[htbp]
    \centering
    \includegraphics[width=0.8\textwidth]{figures/fig1.pdf}
    \caption{Concise description of what figure shows.}
    \label{fig:overview}
\end{figure}
```

### Subfigures
```latex
\begin{figure}[htbp]
    \centering
    \begin{subfigmatrix}{2}
        \subfig{fig1a.pdf}{(a) First part}
        \subfig{fig1b.pdf}{(b) Second part}
    \end{subfigmatrix}
    \caption{Overall figure caption.}
    \label{fig:combined}
\end{figure}
```

## PlantUML Examples

### System Architecture
```plantuml
@startuml
skinparam backgroundColor #FFFFFF
skinparam componentStyle rectangle

component "Data Input" as DI
component "Processing Unit" as PU
component "Output Module" as OM

DI --> PU
PU --> OM

note right of PU: Neural Network\nInference
@enduml
```

### Flowchart
```plantuml
@startuml
skinparam activityArrowFontSize 11
skinparam activityFontSize 11

start
:Load Dataset;
:Preprocess Data;
:Train Model;
if (Validation OK?) then (yes)
  :Evaluate on Test Set;
  stop
else (no)
  :Adjust Parameters;
  :Retrain;
endif
@enduml
```

## Graphviz Examples

### Directed Graph
```dot
digraph Architecture {
    rankdir=LR;
    Input [shape=box];
    Process [shape=ellipse];
    Output [shape=box];

    Input -> Process -> Output;
}
```

### Hierarchy
```dot
digraph Tree {
    Root [shape=box];
    Child1 [shape=ellipse];
    Child2 [shape=ellipse];

    Root -> Child1;
    Root -> Child2;
}
```

## Figure Quality Checklist

- [ ] File format is PDF or high-resolution PNG/JPG
- [ ] Dimensions fit single or double column
- [ ] Text is legible at print size (min 8pt)
- [ ] Colors work in grayscale (for print journals)
- [ ] Caption is informative but concise
- [ ] Figure is referenced in main text
- [ ] Labels are clear (a), (b), etc. for subfigures

## Usage Examples

- `/figure 生成实验流程图`
- `/figure create a comparison table`
- `/figure 帮助我添加一个性能对比图`
