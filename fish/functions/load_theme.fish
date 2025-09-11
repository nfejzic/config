# NOTE: we make sure to load theme once universally and then stop
# @fish-lsp-disable 2003
function load_theme
    logit --level=INFO "Loading theme"

    # FZF
    set -Ux FZF_DEFAULT_OPTS --color=fg+:-1,bg+:black,gutter:-1,hl+:1,hl:1,pointer:6,marker:6,spinner:6,prompt:6,info:6

    # BAT
    set -Ux BAT_THEME ansi

    # Fish
    yes | fish_config theme save transparent

    # prevent from loading again
    set -U CLI_THEME_LOADED true
end
