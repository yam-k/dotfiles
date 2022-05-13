#!/bin/bash

BIN_DIR=$(cd $(dirname $0); pwd)
SRC_DIR=$(cd $BIN_DIR/../src; pwd)
SRCS=$(cd $SRC_DIR; ls -A)

for SRC in $SRCS; do
    if [ -e $HOME/$SRC.original ]; then
        mv -i $HOME/$SRC.original $HOME/$SRC;
    else
        rm -i $HOME/$SRC
    fi
done
