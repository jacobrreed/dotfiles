#!/usr/bin/env bash

#  ____    _    ____  _   _     ___ _____
# | __ )  / \  / ___|| | | |   |_ _|_   _|
# |  _ \ / _ \ \___ \| |_| |    | |  | |
# | |_) / ___ \ ___) |  _  |    | |  | |
# |____/_/   \_\____/|_| |_|___|___| |_|
#                         |_____|
# If not running interactively, don't do anything
case "$-" in
*i*) ;;
*) return ;;
esac

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location "$BASH_IT"/themes/
# https://bash-it.readthedocs.io/en/latest/themes-list/barbuk/
export BASH_IT_THEME='barbuk'

# Some themes can show whether `sudo` has a current token or not.
# Set `$THEME_CHECK_SUDO` to `true` to check every prompt:
#THEME_CHECK_SUDO='true'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
# export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
# export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# If your theme use command duration, uncomment this to
# enable display of last command duration.
export BASH_IT_COMMAND_DURATION=true
# You can choose the minimum time in seconds before
# command duration is displayed.
export COMMAND_DURATION_MIN_SECONDS=1

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# Load Bash It
source "$HOME/.bash_it/bash_it.sh"

#  _   _                  ____             __
# | | | |___  ___ _ __   / ___|___  _ __  / _|
# | | | / __|/ _ \ '__| | |   / _ \| '_ \| |_
# | |_| \__ \  __/ |    | |__| (_) | | | |  _|
#  \___/|___/\___|_|     \____\___/|_| |_|_|
#

# Fastfetch
if command -v fastfetch &>/dev/null; then
  fastfetch
fi
# If using TTY1 login UWSM hyprland
if [ "$(tty)" = "/dev/tty1" ]; then
  if uwsm check may-start; then
    exec uwsm start hyprland.desktop
  fi
fi

# User Configuration
# Exports
# NodeJS memory limit
export NODE_OPTIONS=--max-old-space-size=8192
# PATHS
PY_ENV_ROOT=$(pyenv root)
export PATH="$PATH:$PY_ENV_ROOT/shims"
export PATH="$PATH:$HOME/.yarn/bin"  #yarn
export PATH="$PATH:$HOME/.cargo/bin" # Rust
export PATH="$PATH:$HOME/.rd/bin"    # Rancher
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/home/USER/.pyenv/bin:$PATH"
export PATH="$PATH:$HOME/dev/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"

# Source .env file
if [ -f ~/.env ]; then
  . .env
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

########
# Alias Functions
########
alias hypr="cd ~/.config/hypr"
alias findsyms="find . -type l -ls"
alias findhere="find . -name"
alias yay="paru"
# Deletes all files/folders with a given name recursively
# Usage: deleteall node_modules
function deleteall() {
  find . -name "$1" -exec rm -rf {} \;
}
alias e="nvim"
alias vim="nvim"
alias vi="nvim"
if command -v lazygit &>/dev/null; then
  alias l="lazygit"
  if command -v yadm &>/dev/null; then
    alias ly='lazygit --use-config-file "$HOME/.config/yadm/lazygit.yml,$HOME/Library/Application Support/lazygit/config.yml" --work-tree ~ --git-dir ~/.local/share/yadm/repo.git'
  fi
fi
# Yazi
function y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd" || exit
  fi
  rm -f -- "$tmp"
}
# Kitty & Kitten aliases
if [[ "$TERM" == "xterm-kitty" ]]; then
  alias cat="kitten icat"
  alias s="kitten ssh"
  alias icat="kitten icat"
  alias ssh="kitten ssh"
  alias d="kitten diff"
  function kcd() {
    kitten @ send-text --match-tab state:focused cd "$1" && kitten @ send-key --match-tab state:focused Enter
  }
fi
alias dev="cd ~/dev"
if command -v lsd &>/dev/null; then
  alias ls="lsd "
  alias lsa="lsd -al"
fi
if command -v bat &>/dev/null; then
  alias cat="bat"
fi
if command -v btop &>/dev/null; then
  alias htop="btop"
fi
# Update Brew packages
if command -v brew &>/dev/null; then
  alias brewup="brew upgrade && cd ~/.config/brew && ./brewbackup.sh"
fi
if command -v nvim &>/dev/null; then
  alias eup="nvim --headless '+Lazy! sync' +qa && cd ~/.config/nvim && git add . && git commit -m 'upd' && git push"
fi

# Yubikey handler, use if SSH isn't accepting yubikey automatically
reload-ssh() {
  if ! ssh-add -e /usr/local/lib/opensc-pkcs11.so >>/dev/null; then
    echo "Failed to remove previous card"
  fi
  ssh-add -s /usr/local/lib/opensc-pkcs11.so
}
# Yazi file manager
if command -v yazi &>/dev/null; then
  function yy() {
    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd" || exit
    fi
    rm -f -- "$tmp"
  }
fi

# Copilot
COPILOT_CLI=~/.local/share/gh/extensions/gh-copilot/gh-copilot
if [ -f "$COPILOT_CLI" ]; then
  eval "$(gh copilot alias -- bash)"
else
  gh extension install github/gh-copilot
fi
### END Aliases and functions

# SSH agent start if necessary
if [ -z "$SSH_AGENT_PID" ] && [ -z "$SSH_TTY" ]; then # if no agent & not in ssh
  eval "$(ssh-agent -s)" >/dev/null
fi

# fnm
export PATH="/home/neonvoid/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# Zoxide
export _ZO_EXCLUDE_DIRS="/Applications/**:**/node_modules"
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
