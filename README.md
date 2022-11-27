# Dotfiles

Contains configuration for all my systems, Windows 11, MacOS, and Arch.

Dotfiles managed using [YADM](https://yadm.io/docs/getting_started#)

### Bundled (not inclusive of everything)

- Neovim using [LazyVim](https://www.lazyvim.org/) (sub repo: https://github.com/jacobrreed/nvim)
- ZSH w/ OhMyZsh and plugin manager using Antigen
- Tmux
- Waybar
- Hyprland
- Kitty
- WezTerm
- bat (better cat)
- lsd (better ls)
- Homebrew package backups
- Pacman package backups
- btop (better htop)
- dunst (notifications for wayland)
- flameshot (screenshot util)
- Karabiner (macOS keyboard remapping)
- Neofetch (system info)
- SpotifyTui (Spotify in terminal)
- Wofi (rofi for wayland)

#### Notes

- Arch:
  - Pacman packages and AUR packages backed up under .config/pacman
  - .config/slash contains mappings to configs for root directory, i.e .config/slash/etc/pacman.d/hooks should be copied to /etc/pacman.d/hooks/
- Mac:
  - Homebrew packages can be installed by going to .config/brew and running `brew bundle`
- Ubuntu & WSL Ubuntu
  - Apt backup/restore can be found in ~/.config/apt
