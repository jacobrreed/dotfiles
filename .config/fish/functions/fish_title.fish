function fish_title \
    --description "Set title to current folder and shell name" \
    --argument-names last_command

    set --local current_folder (fish_prompt_pwd_dir_length=$pure_shorten_window_title_current_directory_length prompt_pwd)
    set --local current_command (status current-command 2>/dev/null; or echo $_)

    # Replace "fish" with "x" in current_command if it matches
    if test "$current_command" = fish
        set current_command "󰈺"
    end

    set --local prompt "$current_command $pure_symbol_title_bar_separator $current_folder"

    if test -z "$last_command"
        set prompt "$current_command $pure_symbol_title_bar_separator $current_folder"
    end

    echo $prompt
end
