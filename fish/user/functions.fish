# wrap taskwarrior 'task' command such that we immediately refresh tmux
function task
    command task $argv
    tmux refresh-client -S 2>/dev/null # no-op outside tmux
end
