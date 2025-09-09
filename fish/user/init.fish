starship init fish | source

# NOTE: this disables fish greeting
# @fish-lsp-disable-next-line 4004
set fish_greeting

builtin source "$HOME/.config/fish/user/abbr.fish"
builtin source "$HOME/.config/fish/user/env.fish"

if not set -q CLI_THEME_LOADED
    load_theme
end

if string match -q -- zenith $hostname
    builtin source "$HOME/.config/fish/user/rectangle.fish"
end

set -gx GPG_TTY (tty)

if test -d $HOME/Developer/nix-template
    source $HOME/Developer/nix-template/config/fish/init.fish
end
