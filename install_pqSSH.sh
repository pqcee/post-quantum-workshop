#!/bin/bash

# This script automates the installation steps for post-quantum SSH.
#
# To use this script, please
#
# 1.  Download "pqSSH_0.6.5_Ubuntu_2204_LTS_x64.tar.gz", in the GitHub
#     repository's Release section, to your home directory.
#
# 2.  Run this script in the same directory as
#     "pqSSH_0.6.5_Ubuntu_2204_LTS_x64.tar.gz".
#

TARBALL="pqSSH_0.6.5_Ubuntu_2204_LTS_x64.tar.gz"
INSTALL_DIR="/opt/pqcee"
SSH_DIR="${INSTALL_DIR}/openssh"
CLIENT_BIN="${SSH_DIR}/bin"

# Remember current directory
CURRENT_DIR=$(pwd)

# Check if the pqSSH tarball exists
if [[ ! -f "${TARBALL}" ]]; then
    echo "File not found: ${TARBALL}"
    exit 1
fi

# Extract the binaries into /opt/pqcee
sudo cp "./${TARBALL}" /opt
cd /opt || exit
sudo rm -rf pqcee
sudo tar -xzvf "./${TARBALL}"

# Cleanup
sudo rm -rf "./${TARBALL}"

# Return to home directory and add ssh bin paths to bash
cd "${HOME}" || exit
echo "export PATH=${CLIENT_BIN}"':$PATH' >> .bashrc

# Return to current directory
cd "${CURRENT_DIR}" || exit
