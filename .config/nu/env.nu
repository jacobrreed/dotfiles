$env.PROMPT_COMMAND = {||
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

$env.PROMPT_COMMAND_RIGHT = {||
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# NodeJS memory limit
$env.NODE_OPTIONS = "--max-old-space-size=8192"

# Update PATH environment variable
$env.path ++= ["/opt/homebrew/bin"]
$env.path ++= [(pyenv root) + "/shims"]
$env.path ++= [$"($env.HOME)/.yarn/bin"]
$env.path ++= [$"($env.HOME)/.cargo/bin"]
$env.path ++= [$"($env.HOME)/.rd/bin"]
$env.path ++= [$"($env.HOME)/.pyenv/bin"]
$env.path ++= [$"($env.HOME)/.local/bin"]
$env.path ++= ["/Applications/flameshot.app/"]

# FZF
$env.FZF_PREVIEW_ADVANCED = "bat"
$env.FZF_DEFAULT_OPTS = '--color=fg:#ebfafa,bg:#282a36,hl:#37f499 --color=fg+:#ebfafa,bg+:#212337,hl+:#37f499 --color=info:#f7c67f,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449 --height 80% --layout reverse --border'
$env.FZF_PATH = $"($env.HOME)/.config/fzf"

zoxide init nushell --cmd cd | save -f ~/.zoxide.nu
