#!/bin/bash

# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.

set -e # stop if any tests fail
cd ../examples/
python display_data.py -t babi:task1k:1
python base_train.py -t babi:task1k:1
python display_data.py -t babi:task1k:1,squad -n 100
python eval_model.py -m ir_baseline -t "#moviedd-reddit" -dt valid -n 10
python display_model.py -m ir_baseline -t "#moviedd-reddit" -dt valid -n 10
python build_dict.py -t babi:task1k:1 --dict-savepath /tmp/dict.tsv

# TODO: this one breaks when done in scripts due to some environment variable issues
#python memnn_luatorch_cpu/full_task_train.py -t babi:task10k:1 -n 8 --num_examples 100 --num_its 1

# if this returns without an error code, you're good!
python drqa/train.py -t squad -b 32 & sleep 60 ; kill $!
