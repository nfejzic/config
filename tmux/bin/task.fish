#!/usr/bin/env fish

# Quick-capture a task into taskwarrior.
# Auto-tags the current git repo as the project, so worktree tasks group.
read -P 'task ▶ ' -a args

if test -n "$args"
    set -l extra
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    test -n "$root"; and set extra "project:"(basename "$root")" "

    # NOTE: make sure $extra comes before $args, so that `project:...` from $args overrides
    #       the project in $extra
    command task add $extra $args
    printf '\n✓ added\n'
    sleep 0.5
end

tmux refresh-client -S
