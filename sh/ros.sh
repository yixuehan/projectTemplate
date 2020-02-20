#!/bin/bash

sudo sh -c '. /etc/lsb-release && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

sudo apt update
sudo apt install -y ros-kinetic-desktop-full
sudo apt install -y ros-kinetic-navigation
# sudo apt install python3-rosinstall python3-rosinstall-generator pythone3-wstool build-essential
sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential

sudo mkdir -p /etc/ros/rosdep/sources.list.d
sudo rosdep init
sed 's@raw.githubusercontent.com@raw.github.com@g' /etc/ros/rosdep/sources.list.d/20-default.list -i
rosdep update
