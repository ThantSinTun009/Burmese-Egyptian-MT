# Burmese-Egyptian-MT
Machine Translation: Burmese → Egyptian language written in Egyptian hieroglyphic script

**Assignment 6 — Neural Machine Translation (NMT)**

## Overview

This project implements a **Neural Machine Translation (NMT)** system for translating between **Myanmar and Hiero** using the **Marian NMT framework**.

The project is based on the workflow and concepts demonstrated in the following reference notebooks:

* `ALT-Corpus-Translation-Tutorial.ipynb`
* `NMT-Tutorial-with-myContradict.ipynb`

The main goal is to experiment with different NMT architectures, preprocessing methods, hyperparameters, and translation directions.

---

## Translation Directions

Both translation directions are implemented:

```text
Myanmar → Hiero
Hiero → Myanmar
```

The same parallel corpus is used while keeping the source-target sentence pairs aligned.

---

## Project Workflow

```text
                    myhi_data
                       │
              Myanmar ↔ Hiero
                       │
                Parallel Corpus
                       │
                 Preprocessing
                       │
             Train / Valid / Test
                       │
                  Vocabulary
                       │
        ┌──────────────┴──────────────┐
        │                             │
      Seq2Seq                     Transformer
        │                             │
   ┌────┴────┐                   ┌────┴────┐
   │         │                   │         │
 MY → HI   HI → MY             MY → HI   HI → MY
   │         │                   │         │
   └─────────┴───────────────────┴─────────┘
                       │
                Hyperparameter
                    Tuning
                       │
                    Testing
                       │
              BLEU / PPL / CE
                       │
              Qualitative Examples
                       │
                Model Comparison
                       │
              Optional Ensemble
```

---

# 1. Dataset

The project uses the `myhi_data` parallel corpus containing paired:

* Myanmar sentences
* Hiero sentences

The parallel sentence alignment is maintained throughout preprocessing and dataset splitting.

The dataset is divided into:

```text
Train
Validation
Test
```

A fixed random seed is used so that the experiments are reproducible.

---

# 2. Preprocessing

Preprocessing is an important part of this project because the quality of the input data can significantly affect NMT performance.

The preprocessing pipeline includes:

```text
Raw Corpus
    ↓
Cleaning
    ↓
Normalization
    ↓
Sentence Filtering
    ↓
Tokenization / Segmentation
    ↓
Train / Validation / Test
```

Depending on the dataset, preprocessing may include:

* Removing unnecessary sentence IDs
* Cleaning unwanted characters
* Normalizing text
* Removing empty sentences
* Filtering excessively long sentences
* Myanmar segmentation/tokenization
* Hiero tokenization/segmentation

The preprocessing method follows the general approach demonstrated in the reference Marian NMT notebooks.

---

# 3. Train / Validation / Test Split

The parallel corpus is divided into:

```text
70% → Training
20% → Validation
10% → Testing
```

A fixed random seed is used to make the split reproducible.

It is important that Myanmar and Hiero sentences remain aligned during splitting.

For example:

```text
Myanmar sentence 1 ↔ Hiero sentence 1
Myanmar sentence 2 ↔ Hiero sentence 2
Myanmar sentence 3 ↔ Hiero sentence 3
```

The corresponding source and target sentences must always remain together.

---

# 4. Vocabulary

Marian NMT vocabulary files are created using `marian-vocab`.

Separate vocabularies are created for the two languages:

```text
Myanmar vocabulary
Hiero vocabulary
```

The vocabulary is constructed from the processed training/validation/test text according to the workflow used in the reference notebooks.

Example:

```bash
cat train.my valid.my test.my | marian-vocab > my_vocab.yml
```

```bash
cat train.hi valid.hi test.hi | marian-vocab > hi_vocab.yml
```

The exact filenames may vary depending on the final dataset structure.

---

# 5. Seq2Seq Models

Marian NMT is used to train Seq2Seq-style NMT models.

Two translation directions are tested.

### 5.1 Myanmar → Hiero

```text
Source: Myanmar
Target: Hiero
```

### 5.2 Hiero → Myanmar

```text
Source: Hiero
Target: Myanmar
```

The two directions are trained and evaluated independently.

---

# 6. Transformer Models

Transformer-based NMT models are also implemented using Marian NMT.

Two translation directions are tested.

### 6.1 Myanmar → Hiero

```text
Source: Myanmar
Target: Hiero
```

### 6.2 Hiero → Myanmar

```text
Source: Hiero
Target: Myanmar
```

The Transformer configuration is based on the Marian NMT examples provided in the reference notebooks.

---

# 7. Hyperparameter Tuning

Hyperparameter experiments are performed to investigate how model configuration affects translation performance.

Possible parameters include:

```text
Encoder depth
Decoder depth
Transformer heads
Dropout
Learning rate
Batch size
Early stopping
Beam size
Label smoothing
```

For example, different Transformer configurations can be compared:

```text
Experiment A
Encoder depth = 2
Decoder depth = 2
Transformer heads = 8

Experiment B
Encoder depth = 3
Decoder depth = 3
Transformer heads = 8

Experiment C
Encoder depth = 3
Decoder depth = 3
Transformer heads = 10
```

The exact configurations and results will be reported after the experiments are completed.

---

# 8. Evaluation

The trained models are evaluated using several metrics.

## BLEU

BLEU is used to measure the similarity between generated translations and reference translations.

In general:

```text
Higher BLEU → better similarity to the reference translation
```

BLEU scores are calculated using consistent preprocessing/tokenization between the hypothesis and reference translations.

---

## Cross-Entropy

Cross-Entropy (CE) is used to evaluate how well the model predicts the target sequence.

In general:

```text
Lower Cross-Entropy → better
```

---

## Perplexity

Perplexity (PPL) measures the model's uncertainty when predicting the target sequence.

In general:

```text
Lower Perplexity → better
```

---

# 9. Model Comparison

The main experiments compare:

| Model       | Direction       |
| ----------- | --------------- |
| Seq2Seq     | Myanmar → Hiero |
| Seq2Seq     | Hiero → Myanmar |
| Transformer | Myanmar → Hiero |
| Transformer | Hiero → Myanmar |

The final results will be summarized using:

| Model       | Direction | BLEU |  CE | PPL |
| ----------- | --------- | ---: | --: | --: |
| Seq2Seq     | MY → HI   |  TBD | TBD | TBD |
| Seq2Seq     | HI → MY   |  TBD | TBD | TBD |
| Transformer | MY → HI   |  TBD | TBD | TBD |
| Transformer | HI → MY   |  TBD | TBD | TBD |

`TBD` will be replaced with the actual experimental results.

---

# 10. Qualitative Evaluation

In addition to numerical evaluation, several translation examples are examined manually.

Example format:

| # | Source           | Reference       | Seq2Seq | Transformer |
| - | ---------------- | --------------- | ------- | ----------- |
| 1 | Myanmar sentence | Hiero reference | Output  | Output      |
| 2 | Myanmar sentence | Hiero reference | Output  | Output      |
| 3 | Myanmar sentence | Hiero reference | Output  | Output      |

The reverse direction is also evaluated:

| # | Source         | Reference         | Seq2Seq | Transformer |
| - | -------------- | ----------------- | ------- | ----------- |
| 1 | Hiero sentence | Myanmar reference | Output  | Output      |
| 2 | Hiero sentence | Myanmar reference | Output  | Output      |
| 3 | Hiero sentence | Myanmar reference | Output  | Output      |

These examples help analyze translation quality and identify common translation errors that may not be obvious from BLEU alone.

---

# 11. Optional Ensemble

An optional ensemble experiment may be performed after the individual models are successfully trained.

Possible ensemble approaches include:

```text
Seq2Seq + Transformer
```

or multiple models of the same architecture:

```text
Seq2Seq-1 + Seq2Seq-2
```

```text
Transformer-1 + Transformer-2
```

The ensemble experiment is considered an additional experiment and is not required before completing the main Seq2Seq and Transformer experiments.

---

# 12. Project Structure

The project can be organized as follows:

```text
Assignment-6/
│
├── README.md
│
├── data/
│   └── myhi_data/
│
├── preprocessing/
│
├── vocab/
│   ├── my_vocab.yml
│   └── hi_vocab.yml
│
├── models/
│   ├── seq2seq_my_hi/
│   ├── seq2seq_hi_my/
│   ├── transformer_my_hi/
│   └── transformer_hi_my/
│
├── scripts/
│   ├── train_seq2seq.sh
│   ├── train_transformer.sh
│   └── translate.sh
│
├── results/
│   ├── bleu/
│   ├── translations/
│   └── comparisons/
│
└── notebooks/
    └── Assignment-6-NMT.ipynb
```

---

# 13. Notebook Structure

The main Jupyter Notebook follows this structure:

```text
Assignment-6-NMT.ipynb

01. Introduction
02. Environment Setup
03. Dataset Preparation
04. Dataset Exploration
05. Preprocessing
06. Train / Validation / Test Split
07. Tokenization / Segmentation
08. Vocabulary Construction

09. Seq2Seq Model
    09.1 Myanmar → Hiero
    09.2 Hiero → Myanmar

10. Transformer Model
    10.1 Myanmar → Hiero
    10.2 Hiero → Myanmar

11. Hyperparameter Tuning

12. Evaluation
    12.1 BLEU
    12.2 Cross-Entropy
    12.3 Perplexity

13. Qualitative Evaluation

14. Model Comparison

15. Optional Ensemble

16. Conclusion
```

---

# 14. Reference Notebooks

This project is developed with reference to:

```text
ALT-Corpus-Translation-Tutorial.ipynb
NMT-Tutorial-with-myContradict.ipynb
```

These notebooks are used as references for the Marian NMT workflow, including:

* Corpus preparation
* Preprocessing
* Train/validation/test splitting
* Myanmar segmentation
* Vocabulary construction
* Marian training
* Seq2Seq experiments
* Transformer experiments
* Hyperparameter configuration
* Translation testing
* BLEU evaluation
* Model comparison

The Assignment 6 implementation is adapted to the `myhi_data` Myanmar–Hiero parallel corpus.

---

# 15. Final Goal

The main goal of this project is to investigate Neural Machine Translation between Myanmar and Hiero using Marian NMT.

The project compares:

```text
Seq2Seq vs Transformer
```

in both directions:

```text
Myanmar → Hiero
Hiero → Myanmar
```

The experiments evaluate the effect of preprocessing and model configuration using:

```text
BLEU
Cross-Entropy
Perplexity
Qualitative Translation Examples
```

The final results are used to compare the different NMT configurations and understand their translation behavior.

---

## Requirements

The project requires:

* Python
* Jupyter Notebook / Google Colab
* Marian NMT
* `marian`
* `marian-vocab`
* BLEU evaluation tools
* The `myhi_data` parallel corpus

---

## Submission

The final Jupyter Notebook and experiment files should be submitted under:

```text
assignment-6/submission/
```

If uploading to the submission folder is not possible, the completed notebook can be submitted to the instructor by email.
