#!/bin/bash

DATA="/home/thant_syn/exp/nmt/assignment-6/myhi_data"
MODEL_DIR="/home/thant_syn/exp/nmt/assignment-6/model.s2s.syl.my-hi"

VOCAB="${DATA}/vocab/vocab.syl.yml"
TEST_SRC="${DATA}/syllable_segmented/syl_test.my"
TEST_TGT="${DATA}/test.hi"

> eval-result.txt

# Best BLEU model
MODEL="./model.npz.best-bleu.npz"
HYP="./hyp.best-bleu.hi"

marian-decoder \
    -m "${MODEL}" \
    -v "${VOCAB}" "${VOCAB}" \
    --devices 0 \
    --output "${HYP}" \
    < "${TEST_SRC}"

echo "Evaluation with ${HYP}, Best BLEU model:" >> eval-result.txt

perl /home/ye/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl \
    "${TEST_TGT}" \
    < "${HYP}" >> eval-result.txt


# Best CE model
MODEL="./model.npz.best-ce-mean-words.npz"
HYP="./hyp.best-ce-mean-words.hi"

marian-decoder \
    -m "${MODEL}" \
    -v "${VOCAB}" "${VOCAB}" \
    --devices 0 \
    --output "${HYP}" \
    < "${TEST_SRC}"

echo "Evaluation with ${HYP}, Best CE model:" >> eval-result.txt

perl /home/ye/tool/mosesbin/ubuntu-17.04/moses/scripts/generic/multi-bleu.perl \
    "${TEST_TGT}" \
    < "${HYP}" >> eval-result.txt


# Final model
MODEL="./model.npz"
HYP="./hyp.final.hi"

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
