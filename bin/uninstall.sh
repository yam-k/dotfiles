#!/bin/bash

BIN_DIR=$(cd $(dirname $0); pwd)
SRC_DIR=$(cd $BIN_DIR/../src; pwd)
SRCS=$(cd $SRC_DIR; ls -A)

for SRC in $SRCS; do
    rm $HOME/$SRC
    mv $HOME/$SRC.original $HOME/$SRC
done
