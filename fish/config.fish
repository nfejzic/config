builtin source "$HOME/.config/fish/user/init.fish"

function fish_title
    # set -q argv[1]; or set argv fish
    # # Looks like ~/Developer/config/fish: git log
    # # or /etc/apt: fish
    # echo (fish_prompt_pwd_full_dirs=3 prompt_pwd): $argv

    set max_width 11
    set current_command $_
    set dir (basename "$(prompt_pwd)")

    # # we assume both current_command and current_dir are always available!
    # # we have command + () + dir, must fit in max_width
    set occupied_len (math "$(string length $current_command) + 2")
    set space_for_dir (math "max($max_width - $occupied_len, 3)")

    set dir (string shorten -c . -m $space_for_dir $dir)

    echo "$current_command($dir)"
end
