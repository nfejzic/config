local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("nfejzic", { clear = true })

autocmd("FileType", {
	pattern = { "typescript", "javascript", "vue" },
	group = group,
	callback = function(ev)
		if string.match(ev.file, "idana") then
			vim.o.colorcolumn = "100,+1"
			vim.o.textwidth = 120
		end
	end,
})

autocmd("FileType", {
	pattern = { "markdown" },
	group = group,
	callback = function()
		vim.o.textwidth = 80

		local buf_name = vim.api.nvim_buf_get_name(0)
		if string.match(buf_name, "idana") then
			-- text width 120 in work projects
			vim.o.colorcolumn = "+1"
			vim.o.textwidth = 120
		else
			vim.o.textwidth = 80
		end
	end,
})

-- set colorcolumn for rust files to 100 (as that's the default in rustfmt)
autocmd("FileType", {
	pattern = "rust",
	group = group,
	callback = function()
		vim.o.colorcolumn = "+1"
	end,
})

autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "*.component.html",
	group = group,
	callback = function()
		vim.o.filetype = "htmlangular"
	end,
})

autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "config",
	group = group,
	callback = function(ev)
		if string.match(ev.file, "ghostty/.*/config") then
			-- Ghostty config file, e.g. ~/Developer/config/ghostty/zenith-tmux/config
			--			   matches with:                    ghostty/     .*    /config
			vim.o.filetype = "config"
			vim.o.colorcolumn = "+1"
			vim.o.textwidth = 80
		end
	end,
})

autocmd({ "BufEnter" }, {
	pattern = "*.php",
	group = group,
	callback = function(_)
		vim.o.syntax = "php"
	end,
})

autocmd({ "BufEnter" }, {
	pattern = "*.scss",
	group = group,
	callback = function(_)
		vim.o.syntax = "scss"
	end,
})

autocmd({ "BufEnter" }, {
	pattern = "*.vue",
	group = group,
	callback = function(_)
		vim.o.shiftwidth = 2
	end,
})

autocmd({ "BufEnter" }, {
	pattern = "*.Justfile",
	group = group,
	callback = function(_)
		vim.o.filetype = "just"
	end,
})

-- Highlight on yank
autocmd("TextYankPost", {
	pattern = "*",
	group = group,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- jump to last edit position on opening file
autocmd("BufReadPost", {
	pattern = "*",
	group = group,
	callback = function()
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			-- except for in git commit messages
			-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
			if not vim.fn.expand("%:p"):find(".git", 1, true) then
				vim.cmd('exe "normal! g\'\\""')
			end
		end
	end,
})
