#!/bin/bash

DATA="/home/thant_syn/exp/nmt/assignment-6/myhi_data"

VOCAB="${DATA}/vocab/vocab.syl.yml"
TEST_SRC="${DATA}/test.hi"
TEST_TGT="${DATA}/syllable_segmented/syl_test.my"

> eval-result.txt

# ==============================
# Best BLEU model
# ==============================

MODEL="./model.npz.best-bleu.npz"
HYP="./hyp.best-bleu.my"

marian-decoder \
    -m "${MODEL}" \
    -v "${VOCAB}" "${VOCAB}" \
    --devices 0 \
    --output "${HYP}" \
    < "${TEST_SRC}"

echo "Evaluation with ${HYP}, Best BLEU model:" >> eval-result.txt

perl /home/thant_syn/mosesdecoder/scripts/generic/multi-bleu.perl \
    "${TEST_TGT}" \
    < "${HYP}" >> eval-result.txt


# ==============================
# Best CE model
# ==============================

MODEL="./model.npz.best-ce-mean-words.npz"
HYP="./hyp.best-ce-mean-words.my"

marian-decoder \
    -m "${MODEL}" \
    -v "${VOCAB}" "${VOCAB}" \
    --devices 0 \
    --output "${HYP}" \
    < "${TEST_SRC}"

echo "Evaluation with ${HYP}, Best CE model:" >> eval-result.txt

perl /home/thant_syn/mosesdecoder/scripts/generic/multi-bleu.perl \
    "${TEST_TGT}" \
    < "${HYP}" >> eval-result.txt


# ==============================
# Final model
# ==============================

MODEL="./model.npz"
HYP="./hyp.final.my"

marian-decoder \
    -m "${MODEL}" \
    -v "${VOCAB}" "${VOCAB}" \
    --devices 0 \
    --output "${HYP}" \
    < "${TEST_SRC}"

echo "Evaluation with ${HYP}, Final model:" >> eval-result.txt

perl /home/thant_syn/mosesdecoder/scripts/generic/multi-bleu.perl \
    "${TEST_TGT}" \
    < "${HYP}" >> eval-result.txt
