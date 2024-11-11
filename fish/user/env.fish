set -gx EMAIL 'nadir@notfloor.com'

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# set -gx fish_cursor_default "block"
# set -gx fish_cursor_insert "line" "blink"
# set -gx fish_cursor_external "line" "blink"
# set -gx fish_cursor_replace_one "underscore"
# set -gx fish_cursor_visual "block"

set -gx fish_cursor_default block
set -gx fish_cursor_insert block blink
set -gx fish_cursor_external block blink
set -gx fish_cursor_replace_one underscore
set -gx fish_cursor_visual block

if status is-interactive
    if string match -q -r -- '.*ghostty.*|xterm-256color' $TERM
        set -g fish_vi_force_cursor 1
    end
end

if string match -q -- percolation $hostname
    set --export BUN_INSTALL "$HOME/.bun"
    set --export PATH $BUN_INSTALL/bin $PATH
end
