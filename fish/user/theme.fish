function __theme_fzf
    set -gx FZF_DEFAULT_OPTS --color=fg+:-1,bg+:black,gutter:-1,hl+:1,hl:1,pointer:6,marker:6,spinner:6,prompt:6,info:6
end

function __theme_bat
    set -gx BAT_THEME ansi
end

function __theme_fish
    set -l fish_transparent "fish default"

    if test (fish_config theme list | rg transparent)
        set fish_transparent transparent
    end

    yes | fish_config theme save "$fish_transparent" # works better than solarized theme
end

__theme_fish
__theme_fzf
__theme_bat
