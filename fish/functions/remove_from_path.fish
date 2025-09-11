# This function is used interactively
# @fish-lsp-disable-next-line 4004
function remove_from_path
    set -l value $argv[1]
    echo "Trying to remove $value from PATH, fish_user_path"

    if set -l index (contains -i $value $PATH)
        echo "Removing \$PATH[$index] = $value"
        set -e PATH[$index]
    end

    if set -l index (contains -i $value $fish_user_paths)
        echo "Removing \$fish_user_paths[$index] = $value"
        set -e fish_user_paths[$index]
    end
end
