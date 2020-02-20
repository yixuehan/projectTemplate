#!/bin/bash

# chrome
sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -
sudo apt update

# gnome
sudo apt install -y google-chrome-stable gnome

# sudo apt install openvpn network-manager-openvpn network-manager-openvpn-gnome

# input method
sudo apt install -y fcitx-table-wubi fcitx-frontend-qt5

#
# ppa.launchpad.net
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt upgrade -y
