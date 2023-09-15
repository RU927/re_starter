#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'
WHITE='[37;1m'

RV='\u001b[7m'

this_dir="$(dirname "$(realpath "$0")")"
dot_config=$this_dir/config
dot_home=$this_dir/home
config_dir=$HOME/.config

mkdir -p "$config_dir"

configExists() {
	[[ -e "$1" ]] && [[ ! -L "$1" ]]
}

command_exists() {
	command -v "$1" >/dev/null 2>&1
}

checkEnv() {
	## Check Package Handeler
	PACKAGEMANAGER='apt dnf'
	for pgm in ${PACKAGEMANAGER}; do
		if command_exists "${pgm}"; then
			PACKAGER=${pgm}
			echo -e "${RV}Using ${pgm}"
		fi
	done

	if [ -z "${PACKAGER}" ]; then
		echo -e "${RED}Can't find a supported package manager"
		exit 1
	fi

	## Check if the current directory is writable.
	PATHs="$this_dir $config_dir"
	for path in $PATHs; do
		if [[ ! -w ${path} ]]; then
			echo -e "${RED}Can't write to ${path}${RC}"
			exit 1
		fi
	done

	## Check SuperUser Group
	SUPERUSERGROUP='wheel sudo'
	for sug in ${SUPERUSERGROUP}; do
		if groups | grep "${sug}"; then
			SUGROUP=${sug}
			echo -e "Super user group ${SUGROUP}"
		fi
	done

	## Check if member of the sudo group.
	if ! groups | grep "${SUGROUP}" >/dev/null; then
		echo -e "${RED}You need to be a member of the sudo group to run me!"
		exit 1
	fi
}

checkEnv

install_depend() {
	## Check for dependencies.
	DEPENDENCIES='rofi dmenu \
    surfraw surfraw-extra newsboat \
    dex'
	echo -e "${YELLOW}Installing dependencies...${RC}"
	sudo "${PACKAGER}" install -yq "${DEPENDENCIES}"
}

sudoers() {
	sudoers_dirs="etc/sudoers.d"
	for s in $(command ls "$this_dir/$sudoers_dirs"); do
		sudo rm -f "/$sudoers_dirs/$s"
		sudo cp "$this_dir/$sudoers_dirs/$s" "/$sudoers_dirs/$s"
	done
}

function back_sym {
	# перед создание линков делает бекапы только тех пользовательских конфикураций,
	# файлы которых есть в ./config ./home
	echo -e "\u001b${YELLOW} Backing up existing files... ${RC}"
	for config in $(command ls "${dot_config}"); do
		if configExists "${config_dir}/${config}"; then
			echo -e "${YELLOW}Moving old config ${config_dir}/${config} to ${config_dir}/${config}.old${RC}"
			if ! mv "${config_dir}/${config}" "${config_dir}/${config}.old"; then
				echo -e "${RED}Can't move the old config!${RC}"
				exit 1
			fi
			echo -e "${WHITE} Remove backups with 'rm -ir ~/.*.old && rm -ir ~/.config/*.old' ${RC}"
		fi
		echo -e "${GREEN}Linking ${dot_config}/${config} to ${config_dir}/${config}${RC}"
		if ! ln -snf "${dot_config}/${config}" "${config_dir}/${config}"; then
			echo echo -e "${RED}Can't link the config!${RC}"
			exit 1
		fi
	done

	applist="$this_dir/local/share/applications"

	for ma in $(command ls "${applist}"); do
		echo -e "${GREEN}Linking ${applist}/${ma} to $HOME/.local/share/applications/${ma} ${RC}"
		ln -snf "$applist/$ma" "$HOME/.local/share/applications/$ma"
	done

	# for config in $(command ls "${dot_home}"); do
	# 	if configExists "$HOME/.${config}"; then
	# 		echo -e "${YELLOW}Moving old config ${HOME}/.${config} to ${HOME}/.${config}.old${RC}"
	# 		if ! mv "${HOME}/.${config}" "${HOME}/.${config}.old"; then
	# 			echo -e "${RED}Can't move the old config!${RC}"
	# 			exit 1
	# 		fi
	# 		echo -e "${WHITE} Remove backups with 'rm -ir ~/.*.old && rm -ir ~/.config/*.old' ${RC}"
	# 	fi
	# 	echo -e "${GREEN}Linking ${dot_home}/${config} to ${HOME}/.${config}${RC}"
	# 	if ! ln -snf "${dot_home}/${config}" "${HOME}/.${config}"; then
	# 		echo echo -e "${RED}Can't link the config!${RC}"
	# 		exit 1
	# 	fi
	# done
	#
	#xdg-mime query default application/pdf
	# xdg-mime default nbrowser.desktop x-scheme-handler/https x-scheme-handler/http x-scheme-handler/browser
	# xdg-mime query filetype pathTofileYourInterestedIn
	# xdg-mime default xpdf.desktop application/pdf
	# xdg-mime default Thunar.desktop inode/directory
	#
	# find /usr/share/applications ~/.local/share/applications -iname '*.desktop' -print0 | while IFS= read -r -d $'\0' d; do
	# for m in $(grep MimeType "$d" | cut -d= -f2 | tr ";" " "); do
	#   echo xdg-mime default "'$d'" "'$m'"
	# done
}

function install_greenclip {
	echo -e "${RV} Installing greenclip ${RC}"
	#Greenclip (rofi clipboard manager)
	wget https://github.com/erebe/greenclip/releases/download/v4.2/greenclip
	mkdir -p ~/.local/bin
	mv greenclip ~/.local/bin
	chmod 775 ~/.local/bin/greenclip
}

function all {
	echo -e "\u001b[7m Setting up Dotfiles... \u001b[0m"
	install_depend
	back_sym
	install_greenclip
	sudoers
	echo -e "\u001b[7m Done! \u001b[0m"
}

if [ "$1" = "--backsym" ] || [ "$1" = "-b" ]; then
	back_sym
	exit 0
fi

if [ "$1" = "--all" ] || [ "$1" = "-a" ]; then
	all
	exit 0
fi

# Menu TUI
echo -e "\u001b[32;1m Setting up Dotfiles...\u001b[0m"

echo -e " \u001b[37;1m\u001b[4mSelect an option:\u001b[0m"
echo -e "  \u001b[34;1m (a) ALL \u001b[0m"
echo -e "  \u001b[34;1m (d) dependencies \u001b[0m"
echo -e "  \u001b[34;1m (b) back_sym \u001b[0m"
echo -e "  \u001b[34;1m (g) greenclip \u001b[0m"
echo -e "  \u001b[34;1m (s) sudoers \u001b[0m"

echo -e "  \u001b[31;1m (*) Anything else to exit \u001b[0m"

echo -en "\u001b[32;1m ==> \u001b[0m"

read -r option

case $option in

"a")
	all
	;;

"d")
	install_depend
	;;

"b")
	back_sym
	;;

"g")
	install_greenclip
	;;

"s")
	sudoers
	;;
*)
	echo -e "\u001b[31;1m Invalid option entered, Bye! \u001b[0m"
	exit 0
	;;
esac

exit 0
