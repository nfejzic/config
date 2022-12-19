require('neo-tree').setup({
    popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
    source_selector = {
        winbar = true, -- toggle to show selector on winbar
    },
    filesystem = {
        follow_current_file = false, -- This will find and focus the file in the active buffer every time
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
    },
    buffers = {
        bind_to_cwd = true,
        follow_current_file = true, -- This will find and focus the file in the active buffer every time
        -- the current file is changed while the tree is open.
    },
})
