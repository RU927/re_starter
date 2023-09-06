#! /bin/bash
# launcher.sh - Rofi App Launcher, is a dmenu like graphical app launcher
# @author umutsevdi
# @requires rofi
[ "$ROFI_APPLETS_PATH" = "" ] && ROFI_APPLETS_PATH=$HOME/.config/rofi/applets
theme="config"
dir="${ROFI_APPLETS_PATH}/launcher"
rofi -no-lazy-grab -show combi -combi-modi drun -theme "$dir/$theme" -show-combi
