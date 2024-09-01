starship init fish | source
set fish_greeting

function import -a path
    set pwd (dirname (status -f))
    source "$pwd/$path"
end

# ADD IMPORTS HERE

import "./utils.fish"
import "./theme.fish"
import "./abbr.fish"
import "./setup_brew.fish"
import "./editor.fish"
import "./env.fish"
import "./rectangle.fish"

functions --erase import

# NO IMPORTS AFTER THIS LINE
set -gx GPG_TTY (tty)

function reload_config
    source ~/.config/fish/config.fish
end
