# GSDAW — Get Shit Done Academic Writing

**Framework de rédaction académique piloté par les spécifications.** Chaînez des agents IA à travers un pipeline éprouvé : question → recherche → méthodologie → plan → rédaction → citation → figure → abstract → compilation.

---

## Installation (une commande)

```bash
npm install -g @2p1c/harness-writing
```

Redémarrez votre session Claude Code après l'installation. Tous les skills sont découverts automatiquement.

---

## Prérequis

GSDAW nécessite LaTeX et optionnellement markitdown pour l'extraction PDF. Installez-les avant la première utilisation.

### LaTeX (requis)

**macOS :**
```bash
brew install --cask mactex
```

**Linux (Debian/Ubuntu) :**
```bash
sudo apt install texlive-latex-base latexmk
```

**Windows (WSL2 recommandé) :**
```bash
# Dans WSL2
sudo apt install texlive-latex-base latexmk
```
> Ou installez [TeX Live](https://www.tug.org/texlive/) nativement sur Windows.

### markitdown — Extraction PDF (optionnel)

markitdown convertit les PDF en Markdown propre pour la revue de littérature.

**macOS :**
```bash
conda install -c conda-forge markitdown
# ou
brew install --cask mambaforge && conda install -c conda-forge markitdown
```

**Linux :**
```bash
conda install -c conda-forge markitdown
# ou
wget "https://github.com/daltonmatos/markitdown/releases/latest/download/markitdown-x86_64-linux.tar.gz" \
  && tar -xzf markitdown-x86_64-linux.tar.gz && sudo mv markitdown /usr/local/bin/
```

**Windows :**
```powershell
# Avec conda/mamba
conda install -c conda-forge markitdown

# Ou téléchargez le binaire depuis GitHub releases et ajoutez-le au PATH
```

---

## Démarrer

```
/aw-init
```

Répondez à 5 catégories de questions (problème de recherche, approche, méthodologie, contraintes, références) → Génère le brief de recherche.

---

## Pipeline Complet

```
/aw-init              → Brief de recherche
       ↓
/aw-execute          → Rédiger toutes les sections (ondes parallèles)
       ↓
/aw-cite             → Vérifier les citations
       ↓
/aw-table            → Construire les tableaux (fournir CSV)
/aw-figure           → Générer les figures (PlantUML + matplotlib)
       ↓
/aw-abstract         → Rédiger l'abstract de 250 mots
       ↓
/aw-finalize         → make paper — compiler & vérifier
```

---

## Notes par Étape

### `/aw-init`
- Questionnement approfondi en 5 catégories avant le début de la rédaction
- Détecte automatiquement un brief de recherche existant — demande si réutiliser ou recommencer
- Flag `--quick` : sauter tous les points de contrôle Discuss

### `/aw-execute`
- Lit ROADMAP → groupe les tâches en ondes ordonnées par dépendances
- Onde 1 : tâches sans dépendances → parallèle
- Onde 2+ : tâches dépendant des ondes précédentes → séquentiel par onde
- Après chaque onde : point de contrôle qualité (continuer / modifier / suspendre)
- Compilation manuelle : lancez `make paper` vous-même quand prêt

### `/aw-cite`
- Scanne toutes les clés `\cite{}` contre `references.bib`
- Corrige automatiquement les entrées manquantes depuis `literature.md`
- Lancez après tout ajout de citation dans une section

### `/aw-table`
- Demande les données CSV par tableau (dataset, baseline, ablation, résultats)
- Pas de CSV → laisse `\placeholder{tab:name}` dans la section
- Insère automatiquement `\input{tables/{name}}` à l'emplacement correct

### `/aw-figure`
- Diagrammes de pipeline → PlantUML `.tex`
- Graphiques de résultats → Python matplotlib `.pdf`
- Données indisponibles → `\placeholder{fig:name}`
- Insère automatiquement `\input{figures/fig-name}` à l'emplacement correct

### `/aw-abstract`
- Lit tous les brouillons de sections
- Synthétise un abstract structuré IMRAD de 250 mots
- Aucune citation dans l'abstract
- Lancez après que toutes les sections soient complètes

### `/aw-finalize`
- `make paper` — compilation complète
- Vérifie : refs indéfinies, citations non résolues, nombre de mots, abstract présent
- Met à jour STATE.md en "ready for submission"

---

## Ordre de Rédaction

Méthodologie → Résultats → Introduction → Discussion → Conclusion → Abstract

---

## Toutes les Commandes

| Commande | Phase | Description |
|----------|-------|-------------|
| `/aw-init` | Init | Démarrer un nouveau papier — questionneur → brief |
| `/aw-execute` | Phase 2 | Exécuter le plan d'ondes — rédiger toutes les sections |
| `/aw-cite` | Phase 3 | Vérifier la résolution des citations |
| `/aw-table` | Phase 3 | Construire les tableaux depuis CSV |
| `/aw-figure` | Phase 3 | Générer les figures |
| `/aw-abstract` | Phase 3 | Rédiger l'abstract |
| `/aw-finalize` | Phase 3 | Compiler & vérifier |
| `/aw-review` | Any | Revue de qualité de section |
| `/aw-wave-planner` | Manual | Replanifier les ondes depuis ROADMAP |
| `/aw-pause` | Any | Sauvegarder la session (avant pause) |
| `/aw-resume` | Any | Reprendre depuis le point de contrôle |

---

## Récapitulatif du Workflow

```
/aw-init
    │
    ├── aw-questioner → research-brief.json
    ├── aw-discuss-1 → confirmer le brief
    ├── [research + methodology] → literature.md + methodology.md (parallèle)
    ├── aw-discuss-2 → vérification de cohérence
    ├── aw-planner → ROADMAP.md + STATE.md
    └── aw-discuss-3 → approuver le plan

/aw-execute
    │
    ├── aw-wave-planner → wave-plan.md
    ├── Onde 1 (parallèle) → aw-write-*
    ├── aw-review → porte de qualité
    ├── Onde 2 (parallèle) → aw-write-*
    ├── ...
    └── fusion de phase → sections/{chapter}.tex

/aw-cite → /aw-table → /aw-figure → /aw-abstract → /aw-finalize

/aw-pause  →  Sauvegarder avant pause
/aw-resume →  Reprendre depuis le point de contrôle
```

---

## Structure du Projet

```
manuscripts/
└── {paper-slug}/
    ├── project.yaml
    ├── references.bib
    ├── main.tex
    └── sections/
        ├── intro/
        │   ├── 1-1-background.tex
        │   └── ...
        ├── related-work/
        ├── methodology/
        ├── experiment/
        ├── results/
        ├── discussion/
        ├── conclusion/
        └── tables/
```

Les fichiers de paragraphe (`sections/{chapter}/{task-id}.tex`) sont des unités indépendantes — un par tâche, fusionnées par l'exécuteur d'ondes en fichiers `.tex` de chapitre.

---

## Dépannage

| Problème | Solution |
|----------|----------|
| `Undefined reference` dans le log | Lancez `/aw-cite` pour trouver les clés manquantes |
| Citation `[?]` | `make clean && make paper` |
| `elsarticle.cls not found` | `tlmgr install elsarticle` |
| `/aw-init` introuvable | Redémarrez Claude Code après npm install |
| markitdown introuvable | Voir les instructions d'installation ci-dessus pour votre OS |

---

## Nombre de Skills

24 skills à travers 3 phases + gestion de session.

| Phase | Skills |
|-------|--------|
| Phase 1 — Orchestration | aw-questioner, aw-discuss-1/2/3, aw-research, aw-methodology, aw-planner, aw-orchestrator |
| Phase 2 — Exécution | aw-wave-planner, aw-execute, aw-review, aw-write-intro, aw-write-related, aw-write-methodology, aw-write-experiment, aw-write-results, aw-write-discussion, aw-write-conclusion |
| Phase 3 — Polissage | aw-cite, aw-table, aw-figure, aw-abstract, aw-finalize |
| Session | aw-pause, aw-resume |

---

## License

MIT
