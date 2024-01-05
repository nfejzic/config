starship init fish | source
set fish_greeting

function import -a path
    set pwd (dirname (status -f))
    source "$pwd/$path"
end

# ADD IMPORTS HERE

import "./theme.fish"
import "./abbr.fish"
import "./setup_brew.fish"
import "./editor.fish"

functions --erase import
# NO IMPORTS AFTER THIS LINE
set -gx GPG_TTY (tty)

set_theme "Catppuccin Macchiato"