#!/bin/bash

dpkg --get-selects > ~/.config/apt/installed_packages.log
sudo cp /etc/apt/sources.list ~/.config/apt/sources.bak
sudo apt-key exportall > ~/.config/apt/repositories.keys
