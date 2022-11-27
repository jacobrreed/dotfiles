#!/bin/bash
# Restore sources.list
sudo cp ./sources.bak /etc/apt/source.list
# Restore keys
sudo apt-key add ./repository_keys
# Update source list
sudo apt-get update
# Restore installed packages
sudo dpkg --clear-selections
sudo dpkg --set-selections < ./installed_packages.log && sudo apt-get dselect-upgrade 
