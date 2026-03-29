if status is-interactive
    starship init fish | source
end

# NOTE: this disables fish greeting
# @fish-lsp-disable-next-line 4004
set fish_greeting

builtin source "$HOME/.config/fish/user/abbr.fish"
builtin source "$HOME/.config/fish/user/env.fish"

if status is-interactive; and test "$hostname" = zenith
    builtin source "$HOME/.config/fish/user/rectangle.fish"
end

set -gx GPG_TTY (tty)

if status is-interactive; and test -d $HOME/Developer/nix-template
    source $HOME/Developer/nix-template/config/fish/init.fish
end
