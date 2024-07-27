starship init fish | source
set fish_greeting

function import -a path
    set pwd (dirname (status -f))
    source "$pwd/$path"
end

# ADD IMPORTS HERE

import "./env.fish"
import "./utils.fish"
import "./theme.fish"
import "./abbr.fish"
import "./setup_brew.fish"
import "./editor.fish"
import "./rectangle.fish"

if test (uname -s) = "Linux"
    import "./gnome.fish"
end

functions --erase import
# NO IMPORTS AFTER THIS LINE
set -gx GPG_TTY (tty)

if set -q CLI_THEME
    set_theme $CLI_THEME
else
    set_theme "Catppuccin Macchiato"
end
