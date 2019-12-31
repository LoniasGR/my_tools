#!/bin/bash

NUM_CPUS=$1
# max number of jobs is ncpus - 1
NUM_JOBS=$(($NUM_CPUS - 1))

git clone https://github.com/kaldi-asr/kaldi
cd kaldi/tools

bash extras/check_dependencies.sh
sleep 3

# Setting Python3 as default python
rm -rf ./python/*
touch ./python/.use_default_python

bash extras/check_dependencies.sh

sleep 3
make -j${NUM_JOBS}

bash extras/install_irstlm.sh
bash extras/install_openblas.sh

mv openfst-*/ openfst/

cd ../src

./configure --shared --openblas-root=../tools/OpenBLAS/install || exit 1;

make depend -j${NUM_JOBS} || exit 1;

make -j${NUM_JOBS} || exit 1;

cd ../egs/yesno/s5
bash ./run.sh

cd ~
