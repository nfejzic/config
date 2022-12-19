if not require("mason-registry").is_installed("sql-formatter") then
    print "sql-formatter not installed. Will be install now using Mason"
    local pkg = require('mason-registry').get_package("sql-formatter")
    pkg:install()
end

local embedded_sql = vim.treesitter.parse_query(
    "typescript",
    [[
(pair
    key: (property_identifier) @_key (#eq? @_key "sql")
    value: (template_string) @sql
    (#offset! @sql 0 1 0 -1))
    ]]
)

local run_sql_formatter = function(input)
    local res
    local id = vim.fn.jobstart({ "sql-formatter" }, {
        stdout_buffered = true,
        on_stdout = function(_, output)
            res = output
        end,
    })

    vim.fn.chansend(id, input)
    vim.fn.chanclose(id, 'stdin')
    vim.fn.jobwait({ id })

    return res
end

local get_root = function(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, "typescript", {})
    local tree = parser:parse()[1]
    return tree:root()
end

local format_sql = function(opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local start_line = opts.line1 or 1
    local end_line = opts.line2 or -1

    if start_line == end_line then
        start_line = 0
        end_line = -1
    end

    if vim.bo[bufnr].filetype ~= "typescript" then
        vim.notify "can only be used in typescript"
        return
    end

    local root = get_root(bufnr)

    local changes = {}
    for id, node in embedded_sql:iter_captures(root, bufnr, start_line, end_line) do
        local name = embedded_sql.captures[id]
        if name == "sql" then
            -- { start_row, start_col, end_row, end_col }
            local range = { node:range() }
            local indentation = string.rep(" ", range[2])

            local text = vim.treesitter.get_node_text(node, bufnr)
            text = string.sub(text, 2, -2)

            local formatted = run_sql_formatter(text)

            for idx, line in ipairs(formatted) do
                if line ~= "" then
                    formatted[idx] = indentation .. line
                end
            end

            if formatted[#formatted] == "" then
                table.remove(formatted)
            end

            -- remove last line if empty
            table.insert(changes, 1, {
                start = range[1] + 1,
                final = range[3],
                formatted = formatted
            })
        end
    end

    for _, change in ipairs(changes) do
        vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
    end
end

local augroup = vim.api.nvim_create_augroup("SqlFormatting", {})
vim.api.nvim_clear_autocmds({ group = augroup })
vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "*.ts",
    callback = function()
        vim.api.nvim_buf_create_user_command(0, 'FormatSql', format_sql, { nargs = 0, range = true })
    end
})
