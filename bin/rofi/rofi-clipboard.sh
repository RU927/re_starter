#!/bin/bash

[ "$ROFI_PATH" = "" ] && ROFI_PATH=$HOME/.config/rofi
theme="list"

rofi -theme "$ROFI_PATH/format/$theme" -modi "clipboard:greenclip print" -show clipboard
