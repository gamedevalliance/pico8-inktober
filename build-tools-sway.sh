#!/bin/bash

result=`
i=0
for f in $1/*.lua; do
    ((i++)) && ((i!=1)) && echo "-->8";
    cat $f;
    echo;
done`
project_name=`basename "$1"`.p8

sd -f gsm "(?:__lua__)(.*)(?:__gfx__)" "__lua__\n${result}\n__gfx__" "$HOME/.lexaloffle/pico-8/carts/$project_name"

sleep 0.1

swaymsg '[class="pico8"] focus' && ydotool key ctrl+r && swaymsg '[class="code-oss"] focus'
