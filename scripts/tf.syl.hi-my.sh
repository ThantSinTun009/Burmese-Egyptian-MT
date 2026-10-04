#!/bin/bash

# ==========================================
# Assignment 6
# Lightweight Transformer
# Hiero -> Myanmar
# ==========================================

DATA="/home/thant_syn/exp/nmt/assignment-6/myhi_data"
VOCAB="${DATA}/vocab"

SRC="hi"
TGT="my"

MODEL_DIR="/home/thant_syn/exp/nmt/assignment-6/model.transformer.syl.hi-my"

mkdir -p "${MODEL_DIR}"

marian \
    --model "${MODEL_DIR}/model.npz" \
    --type transformer \
    --train-sets \
        "${DATA}/train.hi" \
        "${DATA}/syllable_segmented/syl_train.my" \
    --max-length 50 \
    --vocabs \
        "${VOCAB}/vocab.syl.yml" \
        "${VOCAB}/vocab.syl.yml" \
    --mini-batch-fit -w 8 \
    --maxi-batch 50 \
    --early-stopping 5 \
    --valid-freq 1000 \
    --save-freq 1000 \
    --disp-freq 500 \
    --valid-metrics cross-entropy perplexity bleu \
    --valid-sets \
        "${DATA}/valid.hi" \
        "${DATA}/syllable_segmented/syl_valid.my" \
    --valid-translation-output \
        "${MODEL_DIR}/valid.${SRC}-${TGT}.output" \
    --quiet-translation \
    --valid-mini-batch 16 \
    --beam-size 4 \
    --normalize 0.6 \
    --log "${MODEL_DIR}/train.log" \
    --valid-log "${MODEL_DIR}/valid.log" \
    --enc-depth 1 \
    --dec-depth 1 \
    --transformer-heads 2 \
    --transformer-dim-ffn 256 \
    --dim-emb 128 \
    --transformer-dropout 0.1 \
    --label-smoothing 0.1 \
    --learn-rate 0.0003 \
    --lr-warmup 0 \
    --lr-decay-inv-sqrt 16000 \
    --lr-report \
    --clip-norm 5 \
    --tied-embeddings \
    --devices 0 \
    --sync-sgd \
    --seed 1111 \
    --exponential-smoothing \
    --dump-config > "${MODEL_DIR}/${SRC}-${TGT}.config.yml"

time marian \
    -c "${MODEL_DIR}/${SRC}-${TGT}.config.yml" \
    2>&1 | tee "${MODEL_DIR}/tf.${SRC}-${TGT}.log"
