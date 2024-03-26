# Antigen plugin manager
source ~/antigen.zsh
antigen use oh-my-zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle unixorn/fzf-zsh-plugin@main
antigen bundle sindresorhus/pure --branch=main
antigen theme pure
antigen apply

# FZF Plugin
export FZF_PREVIEW_ADVANCED="bat"
export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#282a36,hl:#37f499 --color=fg+:#ebfafa,bg+:#212337,hl+:#37f499 --color=info:#f7c67f,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'

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
export HOMEBREW_GITHUB_API_TOKEN=

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
alias config="cd ~/.config"
alias python="/opt/homebrew/Cellar/python@3.10/3.10.13_2/bin/python3.10"
alias copilot="gh copilot"
alias findsyms="find . -type l -ls"
alias findhere="find . -name"
alias notes="cd ~/dev/notes && e"
alias e="nvim"
alias vim="nvim"
alias vi="nvim"
# Workspaces aliases
alias dev="cd ~/dev"
if command -v lsd &> /dev/null; then
  alias ls="lsd"
  alias lsa="lsd -al"
  alias lst="lsd --tree"
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

# Neofetch
neofetch

# fnm
export PATH="/home/neonvoid/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# FZF
eval "$(fzf --zsh)"
