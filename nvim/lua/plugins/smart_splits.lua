local utils = require("user.utils")

if utils.is_llm_prompt() then
	return
end

local config = function()
	local smart_splits = require("smart-splits")
	local keymaps = require("user.keymaps")

	keymaps.set_keys({
		{ "n", "<A-h>", smart_splits.move_cursor_left, "Move cursor to window on the left" },
		{ "n", "<A-j>", smart_splits.move_cursor_down, "Move cursor to window on the left" },
		{ "n", "<A-k>", smart_splits.move_cursor_up, "Move cursor to window on the left" },
		{ "n", "<A-l>", smart_splits.move_cursor_right, "Move cursor to window on the left" },

		{ "n", "<A-H>", smart_splits.resize_left, "Move cursor to window on the left" },
		{ "n", "<A-J>", smart_splits.resize_down, "Move cursor to window on the left" },
		{ "n", "<A-K>", smart_splits.resize_up, "Move cursor to window on the left" },
		{ "n", "<A-L>", smart_splits.resize_right, "Move cursor to window on the left" },

		{ "n", "<A-w>", "<CMD>quit<CR>", "Close the currently focused window" },
	})

	-- Re-assert `@pane-is-vim=1` on this pane whenever nvim regains
	-- focus. Works around smart-splits' on_exit using
	-- `display-message -p '#{pane_id}'`, which from inside a tmux
	-- popup resolves to the *underlying* pane and clobbers its flag
	-- when a popup nvim exits. Without this, M-hjkl in the outer
	-- nvim silently start hitting tmux's `select-pane` fallback
	-- because tmux thinks the pane is no longer vim.
	vim.api.nvim_create_autocmd("FocusGained", {
		group = vim.api.nvim_create_augroup("SmartSplitsResyncPaneIsVim", { clear = true }),
		callback = function()
			local pane_id = os.getenv("TMUX_PANE")
			if not pane_id then return end
			vim.fn.jobstart(
				{ "tmux", "set-option", "-pt", pane_id, "@pane-is-vim", "1" },
				{ detach = true }
			)
		end,
	})
end

config()
