#!/bin/bash

BIN_DIR=$(cd $(dirname $0); pwd)
SRC_DIR=$(cd $BIN_DIR/../fonts; pwd)
FONT_DIR=$HOME/.local/share/fonts

if [ -e $FONT_DIR.original ]; then
    mv -i $FONT_DIR.original $FONT_DIR;
else
    rm -i $FONT_DIR
fi
