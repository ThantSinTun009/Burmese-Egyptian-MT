#!/bin/bash

# ==========================================
# Assignment 6
# Model Ensemble: S2S + Transformer
# Hiero -> Myanmar
# ==========================================

DATA="/home/thant_syn/exp/nmt/assignment-6/myhi_data"

S2S_MODEL="/home/thant_syn/exp/nmt/assignment-6/model.s2s.syl.hi-my/model.npz"
TF_MODEL="/home/thant_syn/exp/nmt/assignment-6/model.transformer.syl.hi-my/model.npz"

VOCAB="${DATA}/vocab/vocab.syl.yml"

SRC="${DATA}/test.hi"
REF="${DATA}/syllable_segmented/syl_test.my"

OUT="/home/thant_syn/exp/nmt/assignment-6/model.ensemble.s2s-tf.hi-my"

mkdir -p "${OUT}"

echo "=========================================="
echo "Model Ensemble: S2S + Transformer"
echo "Hiero -> Myanmar"
echo "=========================================="

marian-decoder \
    -m "${S2S_MODEL}" "${TF_MODEL}" \
    -v "${VOCAB}" "${VOCAB}" \
    -i "${SRC}" \
    -o "${OUT}/hyp.ensemble.my" \
    --beam-size 4 \
    --normalize 0.6 \
    --max-length 50 \
    --quiet

echo ""
echo "=========================================="
echo "Ensemble BLEU Score"
echo "=========================================="

/home/thant_syn/mosesdecoder/scripts/generic/multi-bleu.perl \
    "${REF}" < "${OUT}/hyp.ensemble.my"
