# Uncomment to profile
# zmodload zsh/zprof

#                               
#  _   ___      _____ _ __ ___  
# | | | \ \ /\ / / __| '_ ` _ \ 
# | |_| |\ V  V /\__ \ | | | | |
#  \__,_| \_/\_/ |___/_| |_| |_|
#                               
# If using TTY1 login UWSM hyprland
if tty="/dev/tty1"; then
  if uwsm check may-start; then
    exec uwsm start hyprland.desktop
  fi
fi

#  _                          _                       
# | |__   ___  _ __ ___   ___| |__  _ __ _____      __
# | '_ \ / _ \| '_ ` _ \ / _ \ '_ \| '__/ _ \ \ /\ / /
# | | | | (_) | | | | | |  __/ |_) | | |  __/\ V  V / 
# |_| |_|\___/|_| |_| |_|\___|_.__/|_|  \___| \_/\_/  
#                                                     
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#      _       _ _   
#  ___(_)_ __ (_) |_ 
# |_  / | '_ \| | __|
#  / /| | | | | | |_ 
# /___|_|_| |_|_|\__|
#                    
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
# Zinit Packages
zinit wait lucid light-mode for \
  pick"async.sh" src"pure.zsh" wait"!0" sindresorhus/pure \
  zsh-users/zsh-syntax-highlighting \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  Aloxaf/fzf-tab \
  jeffreytse/zsh-vi-mode \
  trystan2k/zsh-tab-title 
  # blockf atload"zicompinit; zicdreplay"  zsh-users/zsh-completions

#  _   _ _     _                   
# | | | (_)___| |_ ___  _ __ _   _ 
# | |_| | / __| __/ _ \| '__| | | |
# |  _  | \__ \ || (_) | |  | |_| |
# |_| |_|_|___/\__\___/|_|   \__, |
#                            |___/ 
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

#   ____                      _      _   _               ____  _           _     
#  / ___|___  _ __ ___  _ __ | | ___| |_(_) ___  _ __   | __ )(_)_ __   __| |___ 
# | |   / _ \| '_ ` _ \| '_ \| |/ _ \ __| |/ _ \| '_ \  |  _ \| | '_ \ / _` / __|
# | |__| (_) | | | | | | |_) | |  __/ |_| | (_) | | | | | |_) | | | | | (_| \__ \
#  \____\___/|_| |_| |_| .__/|_|\___|\__|_|\___/|_| |_| |____/|_|_| |_|\__,_|___/
#                      |_|                                                       
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no 
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd $realpath'

#  ____                 
# |  _ \ _   _ _ __ ___ 
# | |_) | | | | '__/ _ \
# |  __/| |_| | | |  __/
# |_|    \__,_|_|  \___|
#                       
# Hex color support
zmodload zsh/nearcolor
# Pure Prompt
export PURE_PROMPT_SYMBOL=""
export PURE_CMD_MAX_EXEC_TIME=0
zstyle :prompt:pure:git:arrow color "#f16c75"
zstyle :prompt:pure:git:branch color "#04d1f9"
zstyle :prompt:pure:path color "#37f499"
zstyle :prompt:pure:prompt:error color "#f16c75"
zstyle :prompt:pure:prompt:success color "#37f499"
zstyle :prompt:pure:prompt:continuation color "#f7c67f"
zstyle :prompt:pure:suspended_jobs color "#f16c75"
zstyle :prompt:pure:user color "#a48cf2"
zstyle :prompt:pure:user:root color "#f1fc79"


#  _____                       _       
# | ____|_  ___ __   ___  _ __| |_ ___ 
# |  _| \ \/ / '_ \ / _ \| '__| __/ __|
# | |___ >  <| |_) | (_) | |  | |_\__ \
# |_____/_/\_\ .__/ \___/|_|   \__|___/
#            |_|                       
export ZSH_DISABLE_COMPFIX="true"
# NodeJS memory limit
export NODE_OPTIONS=--max-old-space-size=8192
# PATH exports
export PATH=$PATH:$(pyenv root)/shims
export PATH=$PATH:$HOME/.yarn/bin #yarn
export PATH=$PATH:~/.cargo/bin # Rust
export PATH=$PATH:~/.rd/bin # Rancher
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/home/USER/.pyenv/bin:$PATH"
export PATH="$PATH:$HOME/dev/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"
# ZSH Tab title for kitty stuff
export DISABLE_AUTO_TITLE="true"
export ZSH_TAB_TITLE_DISABLE_AUTO_TITLE=false
export ZSH_TAB_TITLE_ONLY_FOLDER=true
export ZSH_TAB_TITLE_CONCAT_FOLDER_PROCESS=true
# FZF
export FZF_PREVIEW_ADVANCED="bat"
export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#282a36,hl:#37f499 --color=fg+:#ebfafa,bg+:#212337,hl+:#37f499 --color=info:#f7c67f,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449 --height 80% --layout reverse --border'
export FZF_PATH="$HOME/.config/fzf"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

#     _    _ _              ___     _____                 _   _                 
#    / \  | (_) __ _ ___   ( _ )   |  ___|   _ _ __   ___| |_(_) ___  _ __  ___ 
#   / _ \ | | |/ _` / __|  / _ \/\ | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#  / ___ \| | | (_| \__ \ | (_>  < |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
# /_/   \_\_|_|\__,_|___/  \___/\/ |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#                                                                               
alias hypr="cd ~/.config/hypr"
alias yay="paru" #replace yay with paru incase we copy paste commands from onlines sources using yay
alias dev="cd ~/dev"
alias findsyms="find . -type l -ls"
alias findhere="find . -name"
# Deletes all files/folders with a given name recursively
# Usage: deleteall node_modules
function deleteall() {
  find . -name $1 -exec rm -rf {} \;
}
alias e="nvim"
if command -v lazygit &> /dev/null; then
  alias l="lazygit"
  if command -v yadm &> /dev/null; then
    alias ly='lazygit --use-config-file "$HOME/.config/yadm/lazygit.yml,$HOME/Library/Application Support/lazygit/config.yml" --work-tree ~ --git-dir ~/.local/share/yadm/repo.git'
  fi
fi
# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
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
    kitten @ send-text --match-tab state:focused cd $1 && kitten @ send-key --match-tab state:focused Enter
  }
fi
# if lsd, replace ls
if command -v lsd &> /dev/null; then
  alias ls="lsd "
  alias lsa="lsd -al"
fi
# if bat, replace cat
if command -v bat &> /dev/null; then
  alias cat="bat"
fi
# if htop, replace btop
if command -v btop &> /dev/null; then
  alias htop="btop"
  alias top="btop"
fi
# Update Brew packages and backup to brew folder
if command -v brew &> /dev/null; then
  alias brewup="brew upgrade && cd ~/.config/brew && ./brewbackup.sh"
fi
# Update neovim lazy packages headless
if command -v nvim &> /dev/null; then
  alias eup="nvim --headless '+Lazy! sync' +qa && cd ~/.config/nvim && git add . && git commit -m 'upd' && git push"
fi

# Yubikey handler, use if SSH isn't accepting yubikey automatically
reload-ssh() {
  ssh-add -e /usr/local/lib/opensc-pkcs11.so >> /dev/null
  if [ $? -gt 0 ]; then
      echo "Failed to remove previous card"
  fi
  ssh-add -s /usr/local/lib/opensc-pkcs11.so
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
# GH CLI Copilot Chat
COPILOT_CLI=~/.local/share/gh/extensions/gh-copilot/gh-copilot
if [ -f "$COPILOT_CLI" ]; then
  # ghcs = gh copilot suggest
  # ghce = gh copilot explain
  eval "$(gh copilot alias -- zsh)"
else
  # otherwise install extension
  gh extension install github/gh-copilot
fi
# GH CLI gh-clone-org
# gh clone-org ORGNAME
CLONE_ORG=~/.local/share/gh/extensions/gh-clone-org/gh-clone-org
if [ ! -f "$CLONE_ORG" ]; then
  gh extension install matt-bartel/gh-clone-org
fi
# If fastfetch then call on profile load
if command -v fastfetch &> /dev/null; then
  fastfetch
fi

#  _____            _    ___     ____                           
# | ____|_   ____ _| |  ( _ )   / ___|  ___  _   _ _ __ ___ ___ 
# |  _| \ \ / / _` | |  / _ \/\ \___ \ / _ \| | | | '__/ __/ _ \
# | |___ \ V / (_| | | | (_>  <  ___) | (_) | |_| | | | (_|  __/
# |_____| \_/ \__,_|_|  \___/\/ |____/ \___/ \__,_|_|  \___\___|
#                                                               
# thefuck
eval $(thefuck --alias fk)
# .env 
set -a; source ~/.env; set +a
# Zoxide
export _ZO_EXCLUDE_DIRS="/Applications/**:**/node_modules"
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init zsh --cmd cd --hook pwd)"
# FZF
# Define fzf-file-widget just in case
export FZF_CTRL_T_COMMAND=""
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# fnm
export PATH="/home/neonvoid/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd --shell zsh)"
# SSH agent start if necessary
if [ -z $SSH_AGENT_PID ] && [ -z $SSH_TTY ]; then  # if no agent & not in ssh
  eval `ssh-agent -s` > /dev/null
fi

# Uncomment to profile
# zprof
