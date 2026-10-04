#!/bin/bash

data_path="/home/thant_syn/exp/nmt/assignment-6/myhi_data"
vocab_path="${data_path}/vocab"

src="my"
tgt="hi"

model_folder="/home/thant_syn/exp/nmt/assignment-6/model.s2s.syl.my-hi"

mkdir -p "${model_folder}"

marian \
  --type s2s \
  --train-sets \
    "${data_path}/syllable_segmented/syl_train.my" \
    "${data_path}/train.hi" \
  --max-length 50 \
  --valid-sets \
    "${data_path}/syllable_segmented/syl_valid.my" \
    "${data_path}/valid.hi" \
  --vocabs \
    "${vocab_path}/vocab.syl.yml" \
    "${vocab_path}/vocab.syl.yml" \
  --model "${model_folder}/model.npz" \
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
  --log "${model_folder}/train.log" \
  --valid-log "${model_folder}/valid.log" \
  --devices 0 \
  --overwrite

echo "Training completed."
