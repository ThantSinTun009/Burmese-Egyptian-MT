#!/bin/bash

DATA="/home/thant_syn/exp/nmt/assignment-6/myhi_data"
MODEL_DIR="/home/thant_syn/exp/nmt/assignment-6/model.transformer.syl.my-hi"
VOCAB="${DATA}/vocab/vocab.syl.yml"

SRC="${DATA}/syllable_segmented/syl_test.my"
REF="${DATA}/test.hi"

echo "=========================================="
echo "Transformer Myanmar -> Hiero"
echo "=========================================="

# Generate translation
marian-decoder \
    -m "${MODEL_DIR}/model.npz" \
    -v "${VOCAB}" "${VOCAB}" \
    -i "${SRC}" \
    -o "${MODEL_DIR}/hyp.final.hi" \
    --beam-size 4 \
    --normalize 0.6 \
    --max-length 50 \
    --quiet

echo ""
echo "=========================================="
echo "BLEU Score"
echo "=========================================="

/home/thant_syn/mosesdecoder/scripts/generic/multi-bleu.perl \
    "${REF}" < "${MODEL_DIR}/hyp.final.hi"
