function __theme_fzf -a scheme
    switch $scheme
    case "gruvbox_dark*"
        set --export FZF_DEFAULT_OPTS "--height 75% --border --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
        --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54"

    case "catppuccin_latte"
        echo "Setting fzf to catppuccin latte"
        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
        --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
        --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"

    case "catppuccin_frappe"
        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
        --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
        --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

    case "catppuccin_macchiato"
        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
        --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
        --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

    case "catppuccin_mocha"
        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

    case "solarized_dark"
        # bg=bg; fg=fg; info=green; prompt=blue; pointer=red; marker=cyan; spinner=red
        # hl=magenta; hl+=magenta; fg+=bg; bg+=bg-of-dark
        set -Ux FZF_DEFAULT_OPTS "\
        --color fg:#839496,bg:#002B36,hl:#D33682,hl+:#D33682,fg+:#002B36,bg+:#FDF6E3 \
        --color info:#859900,prompt:#268BD2,spinner:#DC322F,pointer:#DC322F,marker:#2AA198"

    case "solarized_light"
        # bg=bg; fg=fg; info=green; prompt=blue; pointer=red; marker=cyan; spinner=red
        # hl=magenta; hl+=magenta; fg+=bg; bg+=bg-of-dark
        set -Ux FZF_DEFAULT_OPTS "\
        --color fg:#657B83,bg:#FDF6E3,hl:#D33682,fg+:#FDF6E3,bg+:#002B36,hl+:#D33682 \
        --color info:#859900,prompt:#268BD2,pointer:#DC322F,marker:#2AA198,spinner:#DC322F"

    case "nord"
        set -Ux FZF_DEFAULT_OPTS "\
        --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C \ 
        --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B"

    case "rose_pine"
        set -Ux FZF_DEFAULT_OPTS "
        --color=fg:#908caa,bg:,hl:#ebbcba
        --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
        --color=border:#403d52,header:#31748f,gutter:#191724
        --color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
        --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

    case "*"
        # use themes from fish theme
        set bg "" # transparent bg
        set fg $(echo "$fish_color_normal" | awk '{print $1}') # text 
        set cyan $(echo "$fish_color_command" | awk '{print $1}') # text
        set bgplus $(echo "$fish_color_selection" | awk -F '=' '{print $2}' | awk '{print $1}')
        set red $(echo "$fish_color_error" | awk '{print $1}')
        set orange $(echo "$fish_color_end" | awk '{print $1}')
        set yellow $(echo "$fish_color_quote" | awk '{print $1}')
        set selection $(echo "$fish_pager_color_progress" | awk '{print $1}')

        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#$bgplus,bg:$bg,spinner:#$red,hl:#$orange \
        --color=fg:#$fg,header:#$cyan,info:#$yellow,pointer:#$red \
        --color=marker:#$yellow,fg+:$bg,prompt:#$yellow,hl+:#$orange"
    end
end

function __theme_bat -a theme
    switch $theme
    case "catppuccin_latte"
        set -gx BAT_THEME "Catppuccin-latte"

    case "catppuccin_frappe"
        set -gx BAT_THEME "Catppuccin-frappe"

    case "catppuccin_macchiato"
        set -gx BAT_THEME "Catppuccin-macchiato"

    case "catppuccin_mocha"
        set -gx BAT_THEME "Catppuccin-mocha"

    case "solarized_dark"
        set -gx BAT_THEME "Solarized (dark)"

    case "solarized_light"
        set -gx BAT_THEME "Solarized (light)"

    case "gruvbox_dark_hard"
        set -gx BAT_THEME "gruvbox-dark"

    case "kanagawa"
        set -gx BAT_THEME "kanagawa"

    case "rose_pine"
        set -gx BAT_THEME "rose-pine"

    case "*"
        set -gx BAT_THEME "ansi"
    end
end

function __theme_fish -a theme
    switch $theme
    case "catppuccin_latte"
        yes | fish_config theme save "Catppuccin Latte"

    case "catppuccin_frappe"
        yes | fish_config theme save "Catppuccin Frappe"

    case "catppuccin_macchiato"
        yes | fish_config theme save "Catppuccin Macchiato"

    case "catppuccin_mocha"
        yes | fish_config theme save "Catppuccin Mocha"

    case "solarized_dark"
        yes | fish_config theme save "Solarized Dark"

    case "solarized_light"
        yes | fish_config theme save "Solarized Light"

    case "gruvbox_dark_hard"
        yes | fish_config theme save "Gruvbox Dark Hard"

    case "rose_pine"
        yes | fish_config theme save "Rosé Pine"

    case "kanagawa"
        yes | fish_config theme save "Kanagawa"
    end
end

function __list_themes
    for theme in $themes
        __print "$theme"
    end
end

function __help
    __print "Usage: set_theme \"[theme name]\""
    __print "Example: set_theme \"Catppuccin Macchiato\""
    __print ""
    __print -i 0 "Function to set theme of fish shell, fzf (fuzzy finder), bat and delta"
    __print -i 0 ""
    __print -i 0 "Options:\n"

    __print -i 1 -- '-h --help'
    __print -i 2 -- "Show this help message.\n"

    __print -i 1 -- "-l --list"
    __print -i 2 -- "Show list of available themes"
end

function __cleanup -a name
    set -l cleaned (string replace -r -a '[- ]+' '_' $name)
    set -l cleaned (string replace -r -a '[()]+' '' $cleaned)
    set -l cleaned (string lower $cleaned)
    echo $cleaned
end

function __is_theme_supported -a name
    for theme in $themes
        set -l supported (__cleanup $theme)

        if test $name = $supported
            echo 1
            return 1
        end
    end

    echo 0
    return 0
end

function set_theme
    set -g themes 'Catppuccin Frappe' 'Catppuccin Latte' 'Catppuccin Macchiato' 'Catppuccin Mocha' 'Gruvbox Dark Hard' 'Solarized Light' 'Solarized Dark' 'Kanagawa' 'Rose Pine'

    argparse 'h/help' 'l/list' -- $argv
    or return

    if set -ql _flag_help
        __help
        return
    else if set -ql _flag_list
        __list_themes
        return
    end

    if count $argv > /dev/null
        set theme $argv[1]
    else
        echo "No theme name passed, using default: $default_theme"
        set theme $default_theme
    end

    set -l cleaned (__cleanup "$theme")

    set -l supported (__is_theme_supported $cleaned)

    if not test $supported = 1
        __print -e "Theme '$theme' is not supported"
        return
    end

    __theme_fish $cleaned
    __theme_fzf $cleaned
    __theme_bat $cleaned

    set -U CLI_THEME $cleaned

    set -e themes
end
