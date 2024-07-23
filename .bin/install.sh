#!/bin/bash

install_dotfiles() {
   echo -e "\u001b[7m Installing Dotfiles \u001b[0m"
   git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

   function dotfiles {
      /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
   }

   dotfiles config --local status.showUntrackedFiles no

   dotfiles checkout --force
}

declare -a common_packages=(
   bat curl git htop vim wget zsh
)

get_system_info() {
    [ -e /etc/os-release ] && source /etc/os-release && echo "${ID:-Unknown}" && return
    [ -e /etc/lsb-release ] && source /etc/lsb-release && echo "${DISTRIB_ID:-Unknown}" && return
    [ "$(uname)" == "Darwin" ] && echo "mac" && return
}

install_packages_for_arch() {
   sudo pacman -S "${common_packages[@]}"
}

install_packages_for_debian() {
   sudo apt install "${common_packages[@]}"
}

install_packages_for_fedora() {
   sudo dnf install "${common_packages[@]}"
}

install_packages_for_mac() {
   brew install "${common_packages[@]}"
}

install_packages_for_suse() {
   echo "Not implemented yet!"
}


install_package() {
   package_name=$1

   echo -e "\033[32;1m -> \033[34;1mInstalling $package_name\033[0m"

   case $system_info in
      manjaro) sudo pacman -S $package_name ;;
      arch) sudo pacman -S $package_name ;;
      ubuntu) sudo apt-get install $package_name ;;
      debian) sudo apt-get install $package_name ;;
      mac) brew install $package_name ;;
      *) echo "Unknown system!" && exit 1 ;;
   esac
}

install_oh_my_posh() {
   package_name="oh my posh"

   echo -e "\033[32;1m -> \033[34;1mInstalling $package_name\033[0m"

   curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.bin
}

install_packages() {
   system_info=$(get_system_info)
   echo -e "\033[37;44;1m Installing packages for $system_info \033[0m"

   install_package bat
   install_package git
   install_package htop
   install_package vim
   install_package wget
   install_package zsh
   install_oh_my_posh
}

install_everything() {
   install_dotfiles
   install_packages
}

show_menu() {
   echo -e " 0 Install everything"
   echo -e " 1 Install dotfiles"
   echo -e " 2 Install packages"

   read -r option
   case $option in
      0) install_everything ;;
      1) install_dotfiles ;;
      2) install_packages ;;
      *) exit 0 ;;
   esac
}

main() {
   case "$1" in
      -a | --all | a | all) setup_everything ;;
      -id | --install-dotfiles) install_dotfiles ;;
      -ip | --install-packages) install_packages ;;
      *) show_menu ;;
   esac
   exit 0
}

main "$@"
