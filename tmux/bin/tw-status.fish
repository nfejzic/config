#!/usr/bin/env fish

# taskwarrior tmux segment: WIP + actionable TODO, colored to nudge not nag.

# --- labels -----------------------------------------------------------------
# Nerd Font glyphs (Ghostty falls back to its bundled symbols font).
# Set unquoted so fish expands the \u escape. Swap to text any time:
#   set -l LBL_WIP wip; set -l LBL_TODO todo; set -l LBL_OVER !
set -l LBL_WIP \uf04b # nf-fa-play   (in progress)
set -l LBL_TODO \uf0ae # nf-fa-tasks  (to do)
set -l LBL_OVER \uf06d # nf-fa-fire   (overdue)
# ----------------------------------------------------------------------------

function tw
    command task rc.verbose=nothing rc.confirmation=off $argv 2>/dev/null | tr -cd 0-9
end

set -l wip (tw +ACTIVE count)
set -l todo (tw +PENDING -WAITING count)
set -l over (tw +OVERDUE count)
test -n "$wip"; or set wip 0
test -n "$todo"; or set todo 0
test -n "$over"; or set over 0

# WIP color: idle / focused / overstretched
set -l wc
if test "$wip" -eq 0
    set wc brightblack
else if test "$wip" -le 2
    set wc green
else
    set wc red
end

# TODO color: overdue > count thresholds
set -l tc
if test "$over" -gt 0
    set tc red
else if test "$todo" -eq 0
    set tc white
else if test "$todo" -le 3
    set tc yellow
else
    set tc red
end

set -l seg "#[fg=$wc]$LBL_WIP $wip#[fg=default] #[fg=$tc]$LBL_TODO $todo"
test "$over" -gt 0; and set seg "$seg #[fg=red]$LBL_OVER $over"

printf '%s#[default]' "$seg"
