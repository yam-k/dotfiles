#!/bin/bash

BIN_DIR=$(cd $(dirname $0); pwd)
SRC_DIR=$(cd $BIN_DIR/../fonts; pwd)
FONT_DIR=$HOME/.local/share/fonts

if [ -e $FONT_DIR ]; then
    if [ ! -e $FONT_DIR.original ]; then
        mv $FONT_DIR $FONT_DIR.original
    fi
fi
ln -s $SRC_DIR $FONT_DIR
