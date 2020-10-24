#!/bin/bash

## Install miniconda
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh
bash miniconda.sh -b || exit 1;
grep -q miniconda ~/.bashrc;
if [[ ${?} -ne 0 ]]; then
    echo "export PATH=\"${HOME}/miniconda3/bin:\${PATH}\"">>~/.bashrc
fi

export PATH=${HOME}/miniconda3/bin:${PATH}

source ~/.bashrc

conda info || exit 1;
rm miniconda.sh || exit 1;

conda install mamba -c conda-forge
