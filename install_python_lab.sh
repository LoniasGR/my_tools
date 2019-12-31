#!/usr/bin/env bash

## This is for CentOS server. Adapt accordingly.

## Make sure you have the latest version.
sudo dnf -y check-update
sudo dnf -y update

## Install Extra Packages for Enterprise Linux repository
sudo dnf -y install epel-release

## Enable PowerTools repository
sudo dnf -y config-manager --set-enabled PowerTools

## Download and install the CERT Forensics tools rpm
sudo dnf -y install wget
cd ~
wget https://forensics.cert.org/cert-forensics-tools-release-el8.rpm
sudo rpm -i ./cert-forensics-tools-release-el8.rpm
rm ./cert-forensics-tools-release-el8.rpm

## Make sure all repos are up-to-date
sudo dnf -y check-update
sudo dnf -y update

## Install important packages
sudo dnf install -y patch bzip2 curl git moreutils gawk tmux htop python2 gcc gcc-c++ gcc-gfortran make platform-python-devel zlib-devel zip automake autoconf sox libtool subversion

## Install miniconda
bash install_miniconda.sha

## Install important python packages
conda install -y numpy matplotlib jupyter jupyterlab scikit-learn nltk scipy pandas scikit-image tqdm
conda install -y -c conda-forge visdom librosa seaborn

## Install important NLTK libraries
python -m nltk.downloader popular

## Install pytorch no-CUDA
conda install -y pytorch torchvision cpuonly -c pytorch

## Install open-fst
NUM_CPUS=`cat /proc/cpuinfo | grep proc | wc -l`
OPENFST_VERSION=1.6.1

echo 'Working with ' ${NUM_CPUS} ' CPUs.'
echo 'Installing OpenFST.'
sleep 15
bash install_openfst.sh ${NUM_CPUS} ${OPENFST_VERSION}

## Install kaldi
echo 'Installing kaldi.'
sleep 15
bash install_kaldi.sh ${NUM_CPUS}
