#!/bin/bash

DATA="/home/thant_syn/exp/nmt/assignment-6/myhi_data"
VOCAB="${DATA}/vocab"

SRC="hi"
TGT="my"

MODEL_DIR="/home/thant_syn/exp/nmt/assignment-6/model.s2s.syl.hi-my"

mkdir -p "${MODEL_DIR}"

marian \
  --type s2s \
  --train-sets \
    "${DATA}/train.hi" \
    "${DATA}/syllable_segmented/syl_train.my" \
  --max-length 50 \
  --valid-sets \
    "${DATA}/valid.hi" \
    "${DATA}/syllable_segmented/syl_valid.my" \
  --vocabs \
    "${VOCAB}/vocab.syl.yml" \
    "${VOCAB}/vocab.syl.yml" \
  --model "${MODEL_DIR}/model.npz" \
  --dim-emb 128 \
  --dim-rnn 128 \
  --enc-type bidirectional \
  --enc-cell gru \
  --enc-depth 1 \
  --dec-cell gru \
  --dec-depth 1 \
  --dropout-rnn 0.1 \
  --dropout-src 0.1 \
  --dropout-trg 0.1 \
  --mini-batch 64 \
  --learn-rate 0.0005 \
  --valid-freq 1000 \
  --save-freq 1000 \
  --disp-freq 500 \
  --valid-metrics ce-mean-words bleu \
  --early-stopping 5 \
  --keep-best \
  --seed 42 \
  --log "${MODEL_DIR}/train.log" \
  --valid-log "${MODEL_DIR}/valid.log" \
  --overwrite

echo "Training completed."
