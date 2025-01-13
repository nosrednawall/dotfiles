#!/bin/bash

killall dwmblocks; 
export PATH=$PATH:$HOME/.config/suckless/scripts/dwmblocks 
$HOME/.config/suckless/dwmblocks-async/build/dwmblocks &
