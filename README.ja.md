# GSDAW — Get Shit Done Academic Writing

**仕様主導の学術論文執筆フレームワーク。** 実証済みのパイプラインで AI エージェントを連携：質問 → 研究 → 方法論 → 計画 → 執筆 → 引用 → 図表 → 要旨 → コンパイル。

---

## ワンコマンドインストール

```bash
npm install -g @2p1c/harness-writing
```

インストール後、Claude Code セッションを再起動してください。 全スキルが自動検出されます。

---

## 前提環境

GSDAW の動作には LaTeX が必要であり、PDF 抽出には markitdown（任意）をインストールしてください。

### LaTeX（必須）

**macOS：**
```bash
brew install --cask mactex
```

**Linux（Debian/Ubuntu）：**
```bash
sudo apt install texlive-latex-base latexmk
```

**Windows（WSL2 を推奨）：**
```bash
# WSL2 内
sudo apt install texlive-latex-base latexmk
```
> または Windows 側に [TeX Live](https://www.tug.org/texlive/) をネイティブインストール。

### markitdown — PDF 抽出（任意）

markitdown は PDF をクリーンな Markdown に変換し、文献調査に使用します。

**macOS：**
```bash
conda install -c conda-forge markitdown
# または
brew install --cask mambaforge && conda install -c conda-forge markitdown
```

**Linux：**
```bash
conda install -c conda-forge markitdown
# または
wget "https://github.com/daltonmatos/markitdown/releases/latest/download/markitdown-x86_64-linux.tar.gz" \
  && tar -xzf markitdown-x86_64-linux.tar.gz && sudo mv markitdown /usr/local/bin/
```

**Windows：**
```powershell
# conda/mamba の場合
conda install -c conda-forge markitdown

# GitHub releases からバイナリをダウンロードして PATH に追加
```

---

## 使い方

```
/aw-init
```

5 類の問題に回答（研究問題、研究思路、方法論、制約条件、参考资料）→ 研究ブリーフを生成。

---

## フルパイプライン

```
/aw-init              → 研究ブリーフ
       ↓
/aw-execute          → 全セクション執筆（wave 並列）
       ↓
/aw-cite             → 引用検証
       ↓
/aw-table            → テーブル生成（CSV 提供）
/aw-figure           → 図生成（PlantUML + matplotlib）
       ↓
/aw-abstract         → 250 語要旨執筆
       ↓
/aw-finalize         → make paper — コンパイル＆検証
```

---

## 各ステップの説明

### `/aw-init`
- 執筆開始前に 5 カテゴリで深掘り質問
- 既存の研究ブリーフを自動検出 → 継続か新規か確認
- `--quick` ですべての Discuss チェックポイントをスキップ

### `/aw-execute`
- ROADMAP を読み込み → 依存関係で wave にグループ化
- Wave 1：依存なしタスク → 並列実行
- Wave 2+：先行 wave に依存 → wave ごとに並列
- 各 wave 終了時：品質ゲートチェック（継続/修正/一時停止）
- 手動コンパイル：準備できたら各自 `make paper` を実行

### `/aw-cite`
- すべての `\cite{}` を `references.bib` と照合
- `literature.md` から不足エントリを自動修復
- セクション編集で引用を追加するたびに実行

### `/aw-table`
- 各テーブルについて CSV データを要求（データセット、ベースライン、ablation 、結果）
- CSV なし → セクションに `\placeholder{tab:name}` を挿入
- 正しい位置に `\input{tables/{name}}` を自動挿入

### `/aw-figure`
- パイプライン図 → PlantUML `.tex`
- 結果プロット → Python matplotlib `.pdf`
- データなし → `\placeholder{fig:name}`
- 正しい位置に `\input{figures/fig-name}` を自動挿入

### `/aw-abstract`
- 全セクション草稿を読み込み
- 250 語 IMRAD 形式要旨を総合
- 要旨内に引用・図表番号なし
- 全セクション完了後に実行

### `/aw-finalize`
- `make paper` — フルコンパイル
- チェック：未定義参照、未解決引用、文字数、要旨存在
- STATE.md を "ready for submission" に更新

---

## 執筆順序

方法論 → 結果 → 序論 → 考察 → 結論 → 要旨

---

## 全コマンド

| コマンド | フェーズ | 説明 |
|----------|----------|------|
| `/aw-init` | Init | 新規論文を開始 — 質問 → ブリーフ |
| `/aw-execute` | Phase 2 | wave プランを実行 — 全セクション執筆 |
| `/aw-cite` | Phase 3 | 引用解決を検証 |
| `/aw-table` | Phase 3 | CSV からテーブル生成 |
| `/aw-figure` | Phase 3 | 図を生成 |
| `/aw-abstract` | Phase 3 | 要旨を執筆 |
| `/aw-finalize` | Phase 3 | コンパイル＆検証 |
| `/aw-review` | Any | セクション品質レビュー |
| `/aw-wave-planner` | Manual | ROADMAP から wave を再計画 |
| `/aw-pause` | Any | 執筆セッションを保存（休憩前） |
| `/aw-resume` | Any | チェックポイントから再開 |

---

## ワークフロー概要

```
/aw-init
    │
    ├── aw-questioner → research-brief.json
    ├── aw-discuss-1 → ブリーフを確認
    ├── [research + methodology] → literature.md + methodology.md（並列）
    ├── aw-discuss-2 → 一貫性チェック
    ├── aw-planner → ROADMAP.md + STATE.md
    └── aw-discuss-3 → 計画を承認

/aw-execute
    │
    ├── aw-wave-planner → wave-plan.md
    ├── Wave 1（並列） → aw-write-*
    ├── aw-review → 品質ゲート
    ├── Wave 2（並列） → aw-write-*
    ├── ...
    └── phase merge → sections/{chapter}.tex

/aw-cite → /aw-table → /aw-figure → /aw-abstract → /aw-finalize

/aw-pause  →  休憩前にチェックポイントを保存
/aw-resume →  チェックポイントから再開
```

---

## プロジェクト構造

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

段落ファイル（`sections/{chapter}/{task-id}.tex`）は独立ユニット — タスクごとに 1 段落、wave executor が章の `.tex` ファイルにマージ。

---

## トラブルシューティング

| 問題 | 解决方法 |
|------|----------|
| ログに `Undefined reference` | `/aw-cite` を実行して不足キーを検出 |
| 引用が `[?]` と表示 | `make clean && make paper` |
| `elsarticle.cls not found` | `tlmgr install elsarticle` |
| `/aw-init` が見つからない | npm インストール後に Claude Code を再起動 |
| markitdown が見つからない | 上記の OS 別インストール手順を参照 |

---

## スキル数

3 フェーズ + セッション管理で計 24 スキル。

| フェーズ | スキル |
|---------|--------|
| Phase 1 — オーケストレーション | aw-questioner, aw-discuss-1/2/3, aw-research, aw-methodology, aw-planner, aw-orchestrator |
| Phase 2 — 実行 | aw-wave-planner, aw-execute, aw-review, aw-write-intro, aw-write-related, aw-write-methodology, aw-write-experiment, aw-write-results, aw-write-discussion, aw-write-conclusion |
| Phase 3 — ポリッシュ | aw-cite, aw-table, aw-figure, aw-abstract, aw-finalize |
| セッション管理 | aw-pause, aw-resume |

---

## License

MIT
