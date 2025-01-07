#!/bin/sh
# Submodules
echo "Updating submodules..."
cd $HOME
yadm submodule update --recursive --init
yadm submodule foreach git checkout master
yadm submodule foreach git pull origin master
