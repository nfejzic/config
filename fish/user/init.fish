function import -a path
    set pwd (dirname (status -f))
    source "$pwd/$path"
end

# ADD IMPORTS HERE

import "./setup_brew.fish"
import "./utils.fish"
import "./theme.fish"
import "./abbr.fish"
import "./editor.fish"
import "./env.fish"
import "./rectangle.fish"

functions --erase import

# NO IMPORTS AFTER THIS LINE
set -gx GPG_TTY (tty)

# NOTE: - this is used externally
# @fish-lsp-disable-next-line 4004
function reload_config
    source ~/.config/fish/config.fish
end

starship init fish | source

# NOTE: this disables fish greeting
# @fish-lsp-disable-next-line 4004
set fish_greeting

if test -d $HOME/Developer/nix-template
    source $HOME/Developer/nix-template/config/fish/init.fish
end
