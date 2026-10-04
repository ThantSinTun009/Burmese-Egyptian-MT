# Myanmar ↔ Hiero Neural Machine Translation

A Neural Machine Translation (NMT) project for **Myanmar ↔ Hiero** translation using the **Marian NMT framework**. This project explores sequence-to-sequence (S2S), lightweight Transformer, and model ensemble approaches at syllable level unit.

## Project Overview

The main objective of this project is to investigate neural machine translation between **Myanmar language and Hiero** using different NMT architectures.

The experiments include:

* S2S (Sequence-to-Sequence) model
* Lightweight Transformer model
* S2S + Transformer architecture ensemble
* Myanmar → Hiero translation
* Hiero → Myanmar translation
* BLEU-based evaluation

The project also investigates whether combining different model architectures through ensemble decoding can improve translation performance.

---

## Dataset Structure

The project uses parallel Myanmar–Hiero data with both word-level and syllable-level preprocessing.

```text
myhi_data/
├── syllable_segmented/
│   ├── syl_train.my
│   ├── syl_valid.my
│   └── syl_test.my
│
├── word_segmented/
│   ├── word_train.my
│   ├── word_valid.my
│   └── word_test.my
│
├── train.hi
├── valid.hi
├── test.hi
│
└── vocab/
    ├── vocab.syl.yml
    └── vocab.word.yml
```

### Data Direction

**Myanmar → Hiero**

```text
syl_train.my → train.hi
syl_valid.my → valid.hi
syl_test.my  → test.hi
```

**Hiero → Myanmar**

```text
train.hi → syl_train.my
valid.hi → syl_valid.my
test.hi  → syl_test.my
```

---

## Models

### 1. Sequence-to-Sequence (S2S)

A recurrent neural network based encoder-decoder architecture was trained using Marian.

The lightweight S2S configuration uses:

* Bidirectional encoder
* GRU cells
* 128-dimensional embeddings
* 128-dimensional RNN states
* 1 encoder layer
* 1 decoder layer
* Dropout: 0.1
* Maximum sequence length: 50

---

### 2. Lightweight Transformer

A smaller Transformer architecture was used to reduce computational requirements while maintaining the main Transformer structure.

Configuration:

| Parameter           |  Value |
| ------------------- | -----: |
| Encoder layers      |      1 |
| Decoder layers      |      1 |
| Attention heads     |      2 |
| Embedding dimension |    128 |
| FFN dimension       |    256 |
| Dropout             |    0.1 |
| Maximum length      |     50 |
| Beam size           |      4 |
| Workspace           |   8 MB |
| Label smoothing     |    0.1 |
| Learning rate       | 0.0003 |

This lightweight architecture was selected to make training feasible with limited computational resources.

---

## Model Ensemble

In addition to evaluating individual models, an **architecture-level ensemble** was explored by combining the trained S2S and Transformer models during decoding.

```text
                 ┌──────────────┐
                 │     S2S      │
Input ──────────►│              │
                 └──────┬───────┘
                        │
                        ├────► Ensemble Decoder ───► Output
                        │
                 ┌──────┴───────┐
                 │ Transformer  │
                 └──────────────┘
```

No additional training was required for the ensemble experiment. The already-trained S2S and Transformer models were combined during decoding.

---

## Experimental Results

BLEU scores were calculated using `multi-bleu.perl`.

### Myanmar → Hiero

| Model                          |      BLEU |
| ------------------------------ | --------: |
| S2S                            |     24.04 |
| Lightweight Transformer        |     29.13 |
| **S2S + Transformer Ensemble** | **32.50** |

### Hiero → Myanmar

| Model                          |      BLEU |
| ------------------------------ | --------: |
| S2S                            |     47.02 |
| Lightweight Transformer        |     45.23 |
| **S2S + Transformer Ensemble** | **50.06** |

### Overall Comparison

```text
Myanmar → Hiero

S2S                    24.04
Transformer            29.13
S2S + Transformer      32.50


Hiero → Myanmar

S2S                    47.02
Transformer            45.23
S2S + Transformer      50.06
```

The ensemble achieved the highest BLEU score in both translation directions.

---

## Qualitative Analysis

The experimental results indicate that combining S2S and Transformer models can improve translation performance compared with using either model independently.

For **Myanmar → Hiero**, the S2S model achieved 24.04 BLEU and the Transformer achieved 29.13 BLEU, while the ensemble reached 32.50 BLEU.

For **Hiero → Myanmar**, S2S achieved 47.02 BLEU and Transformer achieved 45.23 BLEU, while the ensemble achieved 50.06 BLEU.

This suggests that the two architectures can produce complementary predictions. By combining them during decoding, the ensemble can benefit from information captured by both models.

---

## Evaluation

The main evaluation metric is **BLEU (Bilingual Evaluation Understudy)**.

Example:

```text
BLEU = 32.50, 58.6/35.1/25.4/22.6
```

The values represent modified n-gram precision for:

```text
1-gram / 2-gram / 3-gram / 4-gram
```

The evaluation also reports:

* Brevity Penalty (BP)
* Hypothesis length
* Reference length
* Length ratio

### Evaluation Note

`multi-bleu.perl` reports a tokenizer-dependent BLEU score. Therefore, the scores in this project are primarily used for **consistent internal comparison between the experiments**.

For publication-quality evaluation, detokenized output with a standardized evaluation script should be considered.

---

## Framework

This project uses:

* **Marian NMT**
* Bash
* Linux
* `multi-bleu.perl`

Marian is used for both model training and decoding.

---

## Main Model Directories

```text
model.s2s.syl.my-hi/
    └── Myanmar → Hiero S2S

model.s2s.syl.hi-my/
    └── Hiero → Myanmar S2S

model.transformer.syl.my-hi/
    └── Myanmar → Hiero Transformer

model.transformer.syl.hi-my/
    └── Hiero → Myanmar Transformer

model.ensemble.s2s-tf/
    └── Myanmar → Hiero Ensemble

model.ensemble.s2s-tf.hi-my/
    └── Hiero → Myanmar Ensemble
```

---

## Running the Experiments

### Train S2S

```bash
bash train-s2s.sh
```

### Train Transformer

```bash
bash train-transformer.sh
```

### Test a trained model

```bash
bash test-eval.sh
```

### Run S2S + Transformer Ensemble

```bash
bash test-ensemble.sh
```

The ensemble does not require additional training because it combines already-trained models during decoding.

---

## Reproducibility

The experiments use fixed random seeds where applicable and consistent vocabulary files for the Myanmar and Hiero data.

Important experimental settings include:

```text
Maximum sequence length : 50
Transformer embedding   : 128
Transformer heads       : 2
Transformer FFN         : 256
Transformer dropout     : 0.1
Beam size               : 4
Workspace               : 8 MB
Learning rate           : 0.0003
Random seed             : 1111
```

---

## Conclusion

This project compared S2S and lightweight Transformer architectures for Myanmar ↔ Hiero neural machine translation.

The experiments showed that:

1. The lightweight Transformer outperformed S2S for **Myanmar → Hiero**.
2. S2S slightly outperformed the Transformer for **Hiero → Myanmar**.
3. The **S2S + Transformer ensemble achieved the highest BLEU score in both directions**.
4. Ensemble decoding improved the Myanmar → Hiero score from 29.13 to **32.50 BLEU** compared with the individual Transformer.
5. For Hiero → Myanmar, the ensemble improved the score to **50.06 BLEU**, compared with 47.02 for S2S and 45.23 for Transformer.

Overall, the results demonstrate that combining different NMT architectures can provide complementary information and improve translation performance.

---

## 👤 Author: Thant Sin Tun

**Assignment 6 — Neural Machine Translation**

Framework: **Marian NMT**

Task: **Myanmar ↔ Hiero Translation**

Approaches: **S2S · Transformer · Architecture Ensemble**
