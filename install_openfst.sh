#!/bin/bash

NUM_CPUS=$1
OPENFST_VERSION=$2
# max number of jobs is ncpus - 1
NUM_JOBS=$(($NUM_CPUS - 1))

wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-${OPENFST_VERSION}.tar.gz
tar -xvf openfst-${OPENFST_VERSION}.tar.gz openfst-${OPENFST_VERSION}

cd openfst-${OPENFST_VERSION}
./configure --enable-static=yes --enable-shared=no --with-pic=yes --enable-far

make -j${NUM_JOBS}
sudo make install

cd ..
rm openfst-${OPENFST_VERSION}.tar.gz

echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib" >> ~/.bashrc
source ~/.bashrc

fstinfo --help
