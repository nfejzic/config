builtin source "$HOME/.config/fish/user/init.fish"

function gen_title
    set cmd_name $argv[1]
    set dir $argv[2]
    set max_width 11

    # # we assume both current_command and current_dir are always available!
    # # we have command + () + dir, must fit in max_width
    set occupied_len (math "$(string length $cmd_name) + 2")
    set space_for_dir (math "max($max_width - $occupied_len, 3)")

    set dir (string shorten -c . -m $space_for_dir $dir)

    echo "$cmd_name($dir)"
end

function fish_title
    # set -q argv[1]; or set argv fish
    # # Looks like ~/Developer/config/fish: git log
    # # or /etc/apt: fish
    # echo (fish_prompt_pwd_full_dirs=3 prompt_pwd): $argv

    if test -e ./.git
        # git repository, do it slightly differently
        # NOTE: this might not work great, let's test for a while
        set dir (git remote -vv | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}' | head -n 1)
    else
        set dir (basename "$(prompt_pwd)")
    end

    gen_title $_ $dir
end
