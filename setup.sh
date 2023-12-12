#!/bin/bash

find $(cd $(dirname $0);pwd)/sources -maxdepth 1 -type f -print0 |
    while read -d $'\0' file; do
        ln -s $file $HOME
    done

mkdir -p $HOME/.emacs.d
find $(cd $(dirname $0);pwd)/sources/.emacs.d -mindepth 1 -maxdepth 1 -print0 |
    while read -d $'\0' file; do
        ln -s $file $HOME/.emacs.d
    done

mkdir -p $HOME/.config/tint2
find $(cd $(dirname $0);pwd)/sources/.config/tint2 -mindepth 1 -maxdepth 1 -print0 |
    while read -d $'\0' file; do
        ln -s $file $HOME/.config/tint2
    done
