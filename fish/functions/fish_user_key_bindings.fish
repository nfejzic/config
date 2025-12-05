function fish_user_key_bindings
    fish_vi_key_bindings

    # unbind Ctrl-D, it's useful for scrolling in TUI programs such as neovim:
    bind -e --preset ctrl-d
    bind -e --preset -M insert ctrl-d
    bind -e --preset -M normal ctrl-d
    bind -e --preset -M visual ctrl-d
end
