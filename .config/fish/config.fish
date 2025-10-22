if status is-interactive
    #                               
    #  _   ___      _____ _ __ ___  
    # | | | \ \ /\ / / __| '_ ` _ \ 
    # | |_| |\ V  V /\__ \ | | | | |
    #  \__,_| \_/\_/ |___/_| |_| |_|
    #                               
    # For a DE/WM selector instead use below
    set -l os (uname)
    if test "$os" = Linux
        if type -q uwsm
            set -l tty (tty)
            if test "$tty" = /dev/tty1
                set -l may-start (uwsm check may-start)
                if test "$may-start"
                    exec uwsm start hyprland.desktop
                end
            end
        end
    end
    #  ____   _  _____ _   _ 
    # |  _ \ / \|_   _| | | |
    # | |_) / _ \ | | | |_| |
    # |  __/ ___ \| | |  _  |
    # |_| /_/   \_\_| |_| |_|
    #                        
    fish_add_path /opt/homebrew/bin/
    # fish_add_path $(pyenv root)/shims
    fish_add_path $HOME/.yarn/bin #yarn
    fish_add_path $HOME/.cargo/bin # Rust
    fish_add_path $HOME/.rd/bin # Rancher
    fish_add_path $HOME/.cargo/bin
    # fish_add_path $HOME/.pyenv/bin
    fish_add_path $HOME/dev/bin
    fish_add_path $HOME/.local/bin
    fish_add_path $HOME/go/bin

    # Preferred editor for local and remote sessions
    if test $SSH_CONNECTION
        set EDITOR nvim
        set VISUAL nvim
    else
        set EDITOR vim
        set VISUAL vim
    end
    # # SSH agent start if necessary
    # if test -z "$SSH_AGENT_PID" -a -z "$SSH_TTY" # if no agent & not in ssh
    #     eval (ssh-agent -c) >/dev/null
    # end

    #     _    _     _                    _       _   _                 
    #    / \  | |__ | |__  _ __ _____   _(_) __ _| |_(_) ___  _ __  ___ 
    #   / _ \ | '_ \| '_ \| '__/ _ \ \ / / |/ _` | __| |/ _ \| '_ \/ __|
    #  / ___ \| |_) | |_) | | |  __/\ V /| | (_| | |_| | (_) | | | \__ \
    # /_/   \_\_.__/|_.__/|_|  \___| \_/ |_|\__,_|\__|_|\___/|_| |_|___/
    #                                                                   
    abbr --add e nvim
    abbr --add hypr "e ~/.config/hypr/hyprland.conf"
    abbr --add yay paru
    abbr --add dev "cd ~/dev"
    abbr --add findsyms "find . -type l -ls"
    abbr --add findhere "find . -name"
    abbr --add cd z
    abbr --add ys "yarn start"

    #  _____      
    # |  ___| __  
    # | |_ | '_ \ 
    # |  _|| | | |
    # |_|  |_| |_|
    #             
    # delete all recursively
    function deleteall
        find . -name $1 -exec rm -rf {} \;
    end
    # Lazygit
    if type -q lazygit
        abbr --add lg lazygit
    end
    # YADM
    if type -q yadm
        abbr --add ly 'lazygit --use-config-file "$HOME/.config/yadm/lazygit.yml" --work-tree ~ --git-dir ~/.local/share/yadm/repo.git'
    end
    # Fastfetch
    if type -q fastfetch
        abbr --add ff fastfetch
    end
    # FFMPEG
    if type -q ffmpeg
        # Convert high res .mov files to smaller file size to retain quality
        function movconvert
            set output (string replace -r '\.mov$' '' $argv[1])
            ffmpeg -i "$argv[1]" -c:v libx264 -c:a copy -crf 20 "$output-small.mov"
        end
    end
    # Yazi
    function y
        set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end
    # Kitty
    if test "$TERM" = xterm-kitty
        abbr --add cat "kitten icat"
        abbr --add s "kitten ssh"
        abbr --add icat "kitten icat"
        abbr --add ssh "kitten ssh"
        abbr --add d "kitten diff"
        function kk
            kitten @ send-text --match-tab state:focused $1 && kitten @ send-key --match-tab state:focused Enter
        end
    end
    # if lsd, replace ls
    if type -q lsd
        abbr --add ls lsd
        abbr --add l "lsd -Al"
        abbr --add lt "lsd --tree"
    end
    # if bat, replace cat
    if type -q bat
        abbr --add cat bat
    end
    # pacq for fzf package installed search
    if type -q pacman
        abbr --add pacq "pacman -Qq | fzf --preview 'pacman -Qil {}' --layout reverse --bind 'enter:execute(pacman -Qil {} | less)'"
    end
    # if htop, replace btop
    if type -q btop
        abbr --add htop btop
        abbr --add top btop
    end
    # Update Brew packages and backup to brew folder
    if type -q brew
        abbr --add brewup "brew upgrade && cd ~/.config/brew && ./brewbackup.sh"
    end
    # Update neovim lazy packages headless
    if type -q nvim
        abbr --add eup "nvim --headless '+Lazy! sync' +qa && cd ~/.config/nvim && git add . && git commit -m 'upd' && git push"
    end
    # Yubikey handler, use if SSH isn't accepting yubikey automatically
    function reload-ssh
        ssh-add -e /usr/local/lib/opensc-pkcs11.so >>/dev/null
        if test $status -gt 0
            echo "Failed to remove previous card"
        end
        ssh-add -s /usr/local/lib/opensc-pkcs11.so
    end
    # WSL Browser
    if type -q wslu
        set BROWSER wslview
    end
    # GH CLI Copilot Chat
    set -l COPILOT_CLI ~/.local/share/gh/extensions/gh-copilot/gh-copilot
    if not test -e "$COPILOT_CLI"
        gh extension install github/gh-copilot --force
    end
    # GH CLI gh-clone-org
    # gh clone-org ORGNAME
    set -l CLONE_ORG ~/.local/share/gh/extensions/gh-clone-org/gh-clone-org
    if not test -e "$CLONE_ORG"
        gh extension install matt-bartel/gh-clone-org --force
    end
    # If fastfetch then call on profile load
    if type -q fastfetch
        fastfetch
    end

    #  _____            _ 
    # | ____|_   ____ _| |
    # |  _| \ \ / / _` | |
    # | |___ \ V / (_| | |
    # |_____| \_/ \__,_|_|
    #                     
    thefuck --alias | source
    direnv hook fish | source
    fnm env --shell fish | source

    #  _____ _     _       ____                  _  __ _      
    # |  ___(_)___| |__   / ___| _ __   ___  ___(_)/ _(_) ___ 
    # | |_  | / __| '_ \  \___ \| '_ \ / _ \/ __| | |_| |/ __|
    # |  _| | \__ \ | | |  ___) | |_) |  __/ (__| |  _| | (__ 
    # |_|   |_|___/_| |_| |____/| .__/ \___|\___|_|_| |_|\___|
    #                           |_|                           
    # Vi Mode
    set -g fish_key_bindings fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    # MOTD for fish 
    set fish_greeting

    #                                  _   
    #  _ __  _ __ ___  _ __ ___  _ __ | |_ 
    # | '_ \| '__/ _ \| '_ ` _ \| '_ \| __|
    # | |_) | | | (_) | | | | | | |_) | |_ 
    # | .__/|_|  \___/|_| |_| |_| .__/ \__|
    # |_|                       |_|        
    # Pure Prompt
    set --universal pure_check_for_new_release false
    set --universal pure_symbol_prompt ""
    set --universal pure_separate_prompt_on_error false
    set --universal pure_threshold_command_duration 0
    set --universal pure_show_subsecond_command_duration true
    set --universal pure_reverse_prompt_symbol_in_vimode true # Reverse prompt char in vi mode
    set --universal pure_symbol_ssh_prefix "󰣀 "
    set --universal pure_symbol_git_stash "󰘓 "
    set --universal pure_symbol_git_unpulled_commits " "
    set --universal pure_symbol_git_unpushed_commits " "
    set --universal pure_symbol_git_dirty "  "
    set --universal pure_color_git_dirty green

    #  _____                 _   _                 
    # |  ___|   _ _ __   ___| |_(_) ___  _ __  ___ 
    # | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
    # |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
    # |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
    #                                              
    function last_history_item
        echo $history[1]
    end
    abbr -a !! --position anywhere --function last_history_item
    # Git squash master to one commit, pass true as first param to use yadm instead of git
    function squashdown -a use_yadm
        # Default to git if parameter not provided
        set -q use_yadm; or set use_yadm false

        # Choose command based on parameter
        set cmd git
        if test "$use_yadm" = true
            set cmd yadm
        end

        $cmd checkout --orphan squashed master
        $cmd commit -m "Squashed down 🎉️"
        $cmd branch -M squashed master
    end

    #   __     __         _             _       
    #  / _|___/ _|  _ __ | |_   _  __ _(_)_ __  
    # | ||_  / |_  | '_ \| | | | |/ _` | | '_ \ 
    # |  _/ /|  _| | |_) | | |_| | (_| | | | | |
    # |_|/___|_|   | .__/|_|\__,_|\__, |_|_| |_|
    #              |_|            |___/         
    fzf_configure_bindings --directory=\cf --git_log=\cg --history=\cr --processes=\cp$pure_shorten_window_title_current_directory_length
end
