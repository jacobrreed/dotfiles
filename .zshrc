# Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Zinit
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.local/share}/zinit"
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
declare -A ZINIT
ZINIT[BIN_DIR]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/bin"
ZINIT[HOME_DIR]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
ZINIT[MAN_DIR]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/man"
ZINIT[PLUGINS_DIR]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/plugins"
ZINIT[COMPLETIONS]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/completions"
ZINIT[SNIPPETS]="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/snippets"
source "${ZINIT_HOME}/zinit.zsh"
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
# Snippets
zinit snippet OMZP::archlinux # pacin = sudo pacman -S, pacupg = sudo pacman -Syu, paclist = list all explicitly installed packages
zinit snippet OMZP::brew # bcubc = upgrade and clean
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::cp
# dbl = docker build, dcls = docker container ls, dr = docker container run, drs = docker container restart, drm = docker container rm, dvprune = docker volume prune
zinit snippet OMZP::docker 
zinit snippet OMZP::docker-compose # dcupd = docker-compose up -d, dcdn = docker-compose down
zinit snippet OMZP::fnm
zinit snippet OMZP::fzf
# ga = git add, gaa = git add all, gco = git checkout, gcb = git checkout -b, gcmsg = git commit -m, gd = git diff, glo = git log oneline decorate, gp = git push, gpf! = git push --force
zinit snippet OMZP::git 
zinit snippet OMZP::gh
# Press esc twice to thefuck last command
zinit snippet OMZP::thefuck
# y = yarn, ya = yarn add, yad = yarn add --dev, yst=yarn start, yt = yarn test
zinit snippet OMZP::yarn

autoload -Uz compinit && compinit
zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUPE=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Keybinds
# Emacs binds
bindkey -e
bindkey '^j' history-search-backward
bindkey '^k' history-search-forward

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no 
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd $realpath'

# FZF Plugin
export FZF_PREVIEW_ADVANCED="bat"
export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#282a36,hl:#37f499 --color=fg+:#ebfafa,bg+:#212337,hl+:#37f499 --color=info:#f7c67f,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'
export FZF_PATH="$HOME/.config/fzf"

# Hex color support
zmodload zsh/nearcolor

# Pure Prompt
export PURE_PROMPT_SYMBOL="›"
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
# Node memory limit
export NODE_OPTIONS=--max-old-space-size=8192
# PATHS
export PATH=$PATH
export PATH=$PATH:$HOME/.yarn/bin #yarn
export PATH=$PATH:~/.cargo/bin # Rust
export PATH=$PATH:~/.rd/bin # Rancher
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/home/USER/.pyenv/bin:$PATH"

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
alias copilot="gh copilot"
alias findsyms="find . -type l -ls"
alias findhere="find . -name"
alias e="nvim"
alias vim="nvim"
alias vi="nvim"
alias oil="~/.local/bin/oil-ssh.sh"
# Kitty & Kitten aliases
alias icat="kitten icat"
alias s="kitten ssh"
alias d="kitten diff"
# Workspaces aliases
alias dev="cd ~/dev"
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
  function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi
# WSL Browser
if command -v wslu &> /dev/null; then
  export BROWSER=wslview
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
### END Aliases and functions

# SSH agent start if necessary
if [ -z $SSH_AGENT_PID ] && [ -z $SSH_TTY ]; then  # if no agent & not in ssh
  eval `ssh-agent -s` > /dev/null
fi

# fnm
export PATH="/home/neonvoid/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# FZF
eval "$(fzf --zsh)"

# TheFuck
eval $(thefuck --alias fk)

# Zoxide
export _ZO_EXCLUDE_DIRS="/Applications/**:**/node_modules"
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init zsh --cmd cd --hook pwd)"

# Fastfetch
if command -v fastfetch &> /dev/null; then
  fastfetch
fi
