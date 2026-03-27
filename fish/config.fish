builtin source "$HOME/.config/fish/user/init.fish"

function gen_title
    set cmd_name $argv[1]
    set dir $argv[2]
    set max_width 15

    set occupied_len (math "$(string length $cmd_name) + 2")
    set space_for_dir (math "max($max_width - $occupied_len, 3)")

    if set -q argv[3]
        set -l avail (math "$space_for_dir - 1")
        set -l half (math "ceil($avail / 2)")
        set dir (string shorten -c "" -m $half $dir):(string shorten -c '' -m (math "$avail - $half") $argv[3])
    else
        set dir (string shorten -c . -m $space_for_dir $dir)
    end

    echo "$cmd_name($dir)"
end

function fish_title
    set -l cmd (test -n "$argv[1]"; and echo $argv[1]; or echo fish)
    set -l cmd (string split " " "$cmd")[1]

    if git rev-parse --is-inside-work-tree &>/dev/null
        set -l repo (git remote -vv 2>/dev/null \
            | awk '{print $2}' \
            | awk -F '/' '{print $NF}' \
            | awk -F '.' '{print $1}' \
            | head -n 1)

        set -l gitdir (git rev-parse --git-dir 2>/dev/null)
        set -l commondir (git rev-parse --git-common-dir 2>/dev/null)
        if test (realpath "$gitdir") != (realpath "$commondir")
            gen_title $cmd $repo $(git branch --show-current)
        else
            gen_title $cmd $repo
        end
    else
        gen_title $cmd (basename "$(prompt_pwd)")
    end
end
