#!/bin/bash

#perform cleanup and exit
if ! swww query; then
    swww init
fi

swww img "/home/neonvoid/pics/anime-village.png" 
