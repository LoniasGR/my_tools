#!/usr/bin/env bash

case $1 in
    -all)       install=0;;
    -basic)     install=1;;
    -conda)     install=2;;
    -condafst)  install=3;;
    -openfst)   install=4;;
    -fstkaldi)  install=5;;
    -kaldi)     install=6;;
esac

release="$(cat /etc/*-release | grep PRETTY_NAME=)"
case "${release}" in
    *CentOS*)    distro=CentOS;;
    *Ubuntu*)    distro=Ubuntu;;
    *Debian*)    distro=Debian;;
    *)      distro="Other";
esac

echo 'Linux distribution is' ${release}

# Change to HOME
cd ~

# Get basic dependencies
if [ "${install}" -lt "2" ]; then 

    # CentOS server - my default
    if [ "${distro}" = "CentOS" ]; then

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
    fi

    # Debian server - the wise choice
    if [ "${distro}" = "Ubuntu" ] || [ "${distro}" = "Debian" ]; then

        ## Update everything to latest version
        sudo apt-get update
        sudo apt-get upgrade

        sudo apt-get install -y patch bzip2 curl git moreutils gawk tmux htop python2 gcc g++ make python-dev libz-dev zip automake autoconf sox libtool subversion wget gfortran zlib1g-dev
    fi
fi


if [ "${install}" -lt "4" -a "${install}" -ne "1" ]; then 
    ## Install miniconda
    bash my_tools/install_miniconda.sh

    ## Install important python packages
    conda install -y numpy matplotlib jupyter jupyterlab scikit-learn nltk scipy pandas scikit-image tqdm
    conda install -y -c conda-forge visdom librosa seaborn

    ## Install important NLTK libraries
    python -m nltk.downloader popular

    ## Install pytorch no-CUDA
    conda install -y pytorch torchvision cpuonly -c pytorch
fi


if [ "${install}" -lt "6" -a "${install}" -ne "2" -a "${install}" -ne "1" ]; then 
    ## Install open-fst
    NUM_CPUS=`cat /proc/cpuinfo | grep proc | wc -l`
    OPENFST_VERSION=1.6.1

    echo 'Working with ' ${NUM_CPUS} ' CPUs.'
    echo 'Installing OpenFST.'
    sleep 15
    bash my_tools/install_openfst.sh ${NUM_CPUS} ${OPENFST_VERSION}
fi

if [ "${install}" -lt "7" -a "${install}" -ne "2" -a "${install}" -ne "1" -a "${install}" -ne "4" ]; then 
    ## Install kaldi
    echo 'Installing kaldi.'
    sleep 15
    bash my_tools/install_kaldi.sh ${NUM_CPUS}
fi


