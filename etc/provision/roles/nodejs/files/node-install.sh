#!/usr/bin/env bash

NODEJS_VER=$1
NVM_DIR=$2
NODEJS_INSTALLED=${NVM_DIR}/.node-${NODEJS_VER}

source ${NVM_DIR}/nvm.sh

if [ ! -f ${NODEJS_INSTALLED} ]; then
  nvm install ${NODEJS_VER}
  nvm use ${NODEJS_VER}
  nvm alias default ${NODEJS_VER}
  touch ${NODEJS_INSTALLED}
  nvm current | tee ~/.node-version
fi
