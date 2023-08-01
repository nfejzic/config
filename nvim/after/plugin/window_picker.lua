require 'window-picker'.setup({
    autoselect_one = true,
    hint = 'floating-big-letter',
    -- include_current = true,
    filter_rules = {
        include_current_win = false,
        -- filter using buffer options
        bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'neo-tree', "neo-tree-popup", "notify" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal', "quickfix" },
        },
    },
})
