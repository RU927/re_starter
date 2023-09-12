#!/usr/bin/env bash
# author: unknown
# sentby: MoreChannelNoise (https://www.youtube.com/user/MoreChannelNoise)
# editby: gotbletu (https://www.youtube.com/user/gotbletu)

# demo: https://www.youtube.com/watch?v=kxJClZIXSnM
# info: this is a script to launch other rofi scripts,
#       saves us the trouble of binding multiple hotkeys for each script,
#       when we can just use one hotkey for everything.

declare -A LABELS
declare -A COMMANDS

###
# List of defined 'bangs'

COMMANDS["grub-reboot"]="rofi-grub-reboot"
LABELS["grub-reboot"]=""

# open bookmarks
COMMANDS["bookmarks"]="rofi-bookmarks.sh"
LABELS["bookmarks"]=""

# search local files
COMMANDS["locate"]="rofi-locate.sh"
LABELS["locate"]=""

COMMANDS["files"]="rofi-files"
LABELS["files"]=""

# open custom web searches
COMMANDS["websearch"]="rofi-surfraw-websearch.sh"
LABELS["websearch"]=""

#recordrofi
COMMANDS["record"]="recordrofi.sh"
LABELS["record"]=""

COMMANDS["pass"]="pass-rofi-gui"
LABELS["pass"]=""

COMMANDS["systemd"]="rofi-systemd"
LABELS["systemd"]=""

COMMANDS["json"]='rofi -modi config:"rofi-json.sh config.json","json:rofi-json.sh my_apps.json" -show json'
# COMMANDS["json"]='rofi -modi "json:rofi-json.sh my_apps.json" -show json'
LABELS["json"]=""

# launch programs
# COMMANDS["apps"]="rofi -combi-modi window,drun -show combi"
# LABELS["apps"]=""

# # source: https://bitbucket.org/pandozer/rofi-clipboard-manager/overview
# COMMANDS["clipboard"]='rofi -modi "clipboard:mclip.py menu" -show clipboard && mclip.py paste'
# LABELS["clipboard"]=""

# # greenclip clipboard history
# COMMANDS["clipboard"]="rofi-clipboard.sh"
# LABELS["clipboard"]=""

################################################################################
# do not edit below
################################################################################
##
# Generate menu
##
function print_menu() {
	for key in "${!LABELS[@]}"; do
		echo "$key ${LABELS[$key]}"
		# my top version just shows the first field in labels row, not two words side by side
	done
}

##
# Show rofi.
##
theme="$HOME/.config/rofi/config.rasi"
function rofs() {
	rofi \
		-theme-str 'window {location: center; anchor: center; fullscreen: false; height: 240px; width: 480px;}' \
		-theme-str 'mainbox {children: [ "inputbar", "message", "listview", "mode-switcher" ];}' \
		-theme-str 'listview {columns: 1; spacing: 1px; border: 0px 1px 1px;}' \
		-theme-str 'entry {enabled: false;}' \
		-theme-str 'element-text {horizontal-align: 0;}' \
		-theme-str 'textbox {horizontal-align: 0;}' \
		-theme "$theme" \
		-dmenu
	# -mesg ">>> launch your collection of rofi scripts"
}

function start() {
	print_menu | sort | rofs
}

# Run it
value="$(start)"

# Split input.
# grab upto first space.
choice=${value%%\ *}
# graph remainder, minus space.
input=${value:$((${#choice} + 1))}

##
# Cancelled? bail out
##
if test -z "${choice}"; then
	exit
fi

# check if choice exists
if test "${COMMANDS[$choice]+isset}"; then
	# Execute the choice
	eval echo "Executing: ${COMMANDS[$choice]}"
	eval "${COMMANDS[$choice]}"
else
	eval "$choice" | rofi
	# prefer my above so I can use this same script to also launch apps like geany or leafpad etc (DK)
	#   echo "Unknown command: ${choice}" | rofi -dmenu -p "error"
fi
