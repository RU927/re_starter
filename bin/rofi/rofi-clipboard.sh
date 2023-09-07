#!/bin/bash

themedir="$HOME/.config/rofi"
themename="config"
rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; height: 480px; width: 960px;}' \
	-theme-str 'mainbox {children: [ "inputbar", "message", "listview", "mode-switcher" ];}' \
	-theme-str 'listview {columns: 1; spacing: 1px;}' \
	-theme-str 'element-text {horizontal-align: 0;}' \
	-theme-str 'textbox {horizontal-align: 0;}' \
	-theme "$themedir/$themename" -modi "clipboard:greenclip print" -show clipboard

# rofi -theme "$themedir/format/$themename" -modi "clipboard:greenclip print" -show clipboard
