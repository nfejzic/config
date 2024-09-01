builtin source "$HOME/.config/fish/user/init.fish"

function fish_title
    set -q argv[1]; or set argv fish
    # Looks like ~/Developer/config/fish: git log
    # or /etc/apt: fish
    echo (fish_prompt_pwd_full_dirs=3 prompt_pwd): $argv;
end
