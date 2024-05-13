# Antigen plugin manager
source ~/antigen.zsh
antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle sindresorhus/pure --branch=main
# antigen theme spaceship-prompt/spaceship-prompt
antigen theme pure
antigen apply

# FZF Plugin
export FZF_PREVIEW_ADVANCED="bat"
export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#282a36,hl:#37f499 --color=fg+:#ebfafa,bg+:#212337,hl+:#37f499 --color=info:#f7c67f,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'
export FZF_PATH="$HOME/.config/fzf"

# Node memory limit
export NODE_OPTIONS=--max-old-space-size=8192

# Pure Prompt
zmodload zsh/nearcolor
zstyle :prompt:pure:git:arrow color "#f16c75"
zstyle :prompt:pure:git:branch color "#04d1f9"
zstyle :prompt:pure:path color "#37f499"
zstyle :prompt:pure:prompt:error color "#f16c75"
zstyle :prompt:pure:prompt:success color "#37f499"
zstyle :prompt:pure:prompt:continuation color "#f7c67f"
zstyle :prompt:pure:suspended_jobs color "#f16c75"
zstyle :prompt:pure:user color "#a48cf2"
zstyle :prompt:pure:user:root color "#f1fc79"

# Spaceship Prompt
SPACESHIP_CONFIG="$HOME/.config/spaceship/spaceship.zsh"

# User Configuration
# Exports
export ZSH_DISABLE_COMPFIX="true"
# PATHS
export PATH=$PATH
export PATH=$PATH:$HOME/.yarn/bin #yarn
export PATH=$PATH:~/.cargo/bin # Rust
export PATH=$PATH:~/.rd/bin # Rancher
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/home/USER/.pyenv/bin:$PATH"
export PATH="/Applications/flameshot.app/Contents/MacOS/:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/nvim/bin:$PATH"
if command -v brew &> /dev/null; then
  export HOMEBREW_GITHUB_API_TOKEN=
  export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"
fi

# Options
# turn off autocd, so if you type a directory name it doesnt auto cd into it, gets annoying when commands have same name as folder
unsetopt autocd
setopt ignore_eof

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
alias ociproxycli="/Users/jrreed/dev/ociproxycli/build/main.js"
alias copilot="gh copilot"
alias findsyms="find . -type l -ls"
alias findhere="find . -name"
alias e="nvim"
alias vim="nvim"
alias vi="nvim"
alias ys="yarn start"
# Kitty & Kitten aliases
alias icat="kitten icat"
alias s="kitten ssh"
alias d="kitten diff"
# Workspaces aliases
alias dev="cd ~/dev"
alias lb="cd ~/dev/load-balancer-maui-plugin/"
if command -v lsd &> /dev/null; then
  alias ls="lsd "
  alias lsa="lsd -al"
fi
if command -v bat &> /dev/null; then
  alias cat="bat"
fi
if command -v btop &> /dev/null; then
  alias htop="btop"
fi
# Git Aliases
alias master="git checkout master && git pull origin master"
alias gitlog="git log --pretty=oneline"
# Automatic quick rebase/squashing
# Usage: if currently on branch 'y' and want to rebase to 'x'
# rebase x
# This will checkout x, pull origin x, checkout previous branch i.e y
# then it will open interactive rebase
# from there if you have no conflicts you can
# squash all commits but one, save file and quit
# Then delete all commit messages except the one you want to keep
rebase() {
  git commit -am "prerebase commit (automated)"
	git checkout $1
  git pull origin $1
  git checkout -
  git rebase -i $1
}
# Yubikey handler, use if SSH isn't accepting yubikey automatically
reload-ssh() {
  ssh-add -e /usr/local/lib/opensc-pkcs11.so >> /dev/null
  if [ $? -gt 0 ]; then
      echo "Failed to remove previous card"
  fi
  ssh-add -s /usr/local/lib/opensc-pkcs11.so
}
# Deletes all files/folders with a given name recursively
# Usage: deleteall node_modules
deleteall() {
  find . -name $1 -exec rm -rf {} \;
}
# Check ZSH plugin load times
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}
# Yazi file manager
if command -v yazi &> /dev/null; then
  yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi
# Yabai Sudo Reset
if command -v yabai &> /dev/null; then
  function suyabai() {
    local sha256
    sha256=$(shasum -a 256 "$(which yabai)" | awk "{print \$1;}")
    if [ -f "/private/etc/sudoers.d/yabai" ]; then
      sudo sed -i '' -e 's/sha256:[[:alnum:]]*/sha256:'"${sha256}"'/' /private/etc/sudoers.d/yabai
    else
      echo "sudoers file does not exist yet. creating one now"
      echo "$(whoami) ALL=(root) NOPASSWD: sha256:${sha256} $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
    fi
  }
fi
# WSL Browser
if command -v wslu &> /dev/null; then
  export BROWSER=wslview
fi
### END Aliases and functions

# SSH agent start if necessary
if [ -z $SSH_AGENT_PID ] && [ -z $SSH_TTY ]; then  # if no agent & not in ssh
  eval `ssh-agent -s` > /dev/null
fi

# zsh-autosuggestions iterate through suggestions based on current substring using up/down arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Fastfetch
if command -v fastfetch &> /dev/null; then
  fastfetch
fi

# fnm
export PATH="/home/neonvoid/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# FZF
eval "$(fzf --zsh)"

# The Fuck
eval $(thefuck --alias fk)

# Zoxide
export _ZO_EXCLUDE_DIRS="/Applications/**:**/node_modules"
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init zsh --cmd cd --hook pwd)"
