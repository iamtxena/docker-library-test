#!/bin/bash

set -e
set -u

# if [ ! $# -eq 2 ]; then
#   echo "Error: github_user and github_token parameters are required."
#   exit 2
# fi

echo "Installing qibo from local source"
cd /usr/src
git clone https://github.com/qilimanjaro-tech/qibo.git
cd qibo
git checkout qilimanjaro-backend
pip install .
echo "Qibo successfully installed!"

# echo "Installing qilimanjaroq from local source"
# cd /usr/src
# github_user=$1
# github_token=$2

# git clone https://$github_user:$github_token@github.com/qilimanjaro-tech/qili-qibo-backend.git
# cd qili-qibo-backend
# git checkout QIBO30-qqs-connection
# pip install -e .
# echo "qilimanjaroq successfully installed!"
