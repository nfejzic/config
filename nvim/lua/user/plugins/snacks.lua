---@diagnostic disable-next-line: unused-local
local dropdown_preset = {
	preset = "dropdown",
	layout = { width = 0.85, height = 0.9 },
}

---@diagnostic disable-next-line: unused-local
local ivy_preset = {
	preset = "ivy",
	preview = "main",
	-- layout = { width = 0.85, height = 0.9 },
}

local layout_preset = ivy_preset

local instance = nil
local M = {}

local function setup(snacks)
	snacks.setup({
		bigfile = { enabled = false },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = false },
		image = {
			enabled = true,
			formats = {
				"png",
				"jpg",
				"jpeg",
				"gif",
				"bmp",
				"webp",
				"tiff",
				"heic",
				"avif",
				"mp4",
				"mov",
				"avi",
				"mkv",
				"webm",
				-- "pdf",
			},

		},
		picker = {
			enabled = true,
			ui_select = true,
			layout = layout_preset,
			sources = {
				select = {
					layout = {
						preset = "select",
						layout = {
							relative = "cursor",
							width = 0.5,
						},
					},
				},
			},
		},
		notifier = { enabled = false },
		quickfile = { enabled = false },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = false },
		gitbrowse = { enabled = true },
	})

end

function M.instance()
	if instance ~= nil and instance.did_setup then
		return instance
	else
		instance = require("snacks")
		setup(instance)
		return instance
	end
end

local picker = function() return M.instance().picker end
local gitbrowse = function() return M.instance().gitbrowse end

vim.notify("Preparing keymaps")
require("user.core.keymaps").set_keys({
	{ "n", "<leader>ff", picker().files,                                                   "Find file" },
	-- Ctrl-P make it be the same
	{ "n", "<C-p>",      picker().files,                                                   "Find file (in git repository)" },
	-- TODO: how to find hidden files?
	{ "n", "<leader>fa", function() picker().files({ hidden = true, ignored = true }) end, "Find all files, including hidden" },

	-- vim.keymap.set("n", "<leader>fd", snacks.picker.todo_comments, { desc = "Todo / Fixme etc" })
	{ "n", "<leader>fg", picker().git_diff,                                                "git - modified files" },
	{ "n", "<leader>;",  picker().buffers,                                                 "Telescope search buffers" },

	{ "n", "<leader>ss", picker().treesitter,                                              "Search treesitter symbols" },

	{ "n", "<leader>b",  picker().buffers,                                                 "Telescope search buffers" },

	-- Search menu for which-key
	{ "n", "<leader>s",  "",                                                             "Search" },

	-- NOTE: don't search in files such as 'Cargo.lock'
	{ "n", "<leader>sl", function()
		picker().grep({ exclude = { "*.lock", } })
	end, "Live grep string" },

	{ "n", "<leader>sL", function()
		picker().grep({
			args = { "--case-sensitive" },
		})
	end, "Live grep string, case sensitive" },

	{ "n", "<leader>sg", function()
		picker().grep({
			hidden = true,
		})
	end, "Live grep string, including hidden" },

	{ "n", "<leader>go", gitbrowse().open, "Open current repository in browser" },
})

return M
