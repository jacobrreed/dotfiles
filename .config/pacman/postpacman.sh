#!/bin/bash

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer

# Services
sudo systemctl enable greetd --now
sudo systemctl enable bluetooth --now
sudo systemctl enable keyd --now
sudo systemctl enable paccache.timer --now
systemctl --user enable pipewire --now
