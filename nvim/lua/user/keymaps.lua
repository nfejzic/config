local M = {}

--- @param mappings { [1]: string|string[], [2]: string, [3]: fun()|string, [4]: string|nil }[]
function M.set_keys(mappings)
	for _, mapping in pairs(mappings) do
		local modes = mapping[1]
		local keys = mapping[2]
		local execute = mapping[3]
		local description = mapping[4]
		vim.keymap.set(modes, keys, execute, { desc = description })
	end
end

local wk = require("which-key")

---@diagnostic disable-next-line: missing-fields
wk.setup({
	preset = "modern",
	disable = {
		ft = {
			"TelescopePrompt",
			"neo-tree",
			"NeoTree",
		},
		bt = {
			"prompt",
		},
	},
})

wk.add({
	{ "<leader>B", group = "Buffer" },
	{ "<leader>d", group = "Debug / DAP" },
	{ "<leader>f", group = "Find/File" },
	{ "<leader>g", group = "Git" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>s", group = "Search" },
	{ "<leader>w", group = "Lsp Workspace" },
})

-- Buffer
M.set_keys({
	{ "n", "<leader>Bc",      "<cmd>BufferClose<CR>",  "Close buffer" },
	{ "n", "<leader>BC",      "<cmd>BufferClose!<CR>", "Close buffer, ignore changes" },
	{ "n", "<leader><space>", "<C-^>",                 "Switch to previous buffer" },
	{ "n", "]b",              "<cmd>bnext<CR>",        "Go to next buffer" },
	{ "n", "[b",              "<cmd>bprevious<CR>",    "Go to previous buffer" },
})

--- @param direction 'next'|'prev'
local go_quickfix = function(direction)
	return function()
		local count = vim.v.count or 1

		if direction == 'next' then
			pcall(function(command) vim.cmd(command) end, count .. "cn")
		elseif direction == 'prev' then
			pcall(function(command) vim.cmd(command) end, count .. "cp")
		end
	end
end

-- Quickfix
M.set_keys({
	{ "n", "]q",    go_quickfix('next'), "Next quickfix entry",     expr = true },
	{ "n", "[q",    go_quickfix('prev'), "Previous quickfix entry", expr = true },
	{ "n", "<C-j>", go_quickfix('next'), "Next quickfix entry",     expr = true },
	{ "n", "<C-k>", go_quickfix('prev'), "Previous quickfix entry", expr = true },
})

-- Move lines using Ctrl = J|K (down|up) in visual mode
M.set_keys({
	{ "v", "<C-j>", ":m '>+1<CR>gv=gv" },
	{ "v", "<C-k>", ":m '<-2<CR>gv=gv" },
})

return M
