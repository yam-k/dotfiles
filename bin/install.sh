#!/bin/bash

BIN_DIR=$(cd $(dirname $0); pwd)
SRC_DIR=$(cd $BIN_DIR/../src; pwd)
SRCS=$(cd $SRC_DIR; ls -A)

for SRC in $SRCS; do
    if [ ! -e $HOME/$SRC.original ]; then
        mv $HOME/$SRC $HOME/$SRC.original
    fi
    ln -s $SRC_DIR/$SRC $HOME/$SRC
done
