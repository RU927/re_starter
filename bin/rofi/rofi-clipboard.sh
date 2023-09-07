#!/bin/bash

theme="$HOME/.config/rofi/config"
rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; height: 480px; width: 960px;}' \
	-theme-str 'mainbox {children: [ "inputbar", "message", "listview", "mode-switcher" ];}' \
	-theme-str 'listview {columns: 1; spacing: 1px;}' \
	-theme-str 'element-text {horizontal-align: 0;}' \
	-theme-str 'textbox {horizontal-align: 0;}' \
	-theme "$theme" -modi "clipboard:greenclip print" -show clipboard

# rofi -theme "$theme" -modi "clipboard:greenclip print" -show clipboard
