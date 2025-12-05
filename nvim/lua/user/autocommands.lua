local group = vim.api.nvim_create_augroup("nfejzic", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "*.component.html",
	group = group,
	callback = function()
		vim.o.filetype = "htmlangular"
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.html5",
	group = group,
	callback = function()
		vim.bo.filetype = "html"
		vim.bo.syntax = "php"
	end
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.php",
	group = group,
	callback = function()
		vim.bo.filetype = "html"
		vim.bo.syntax = "php"
	end
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.scss",
	group = group,
	callback = function()
		vim.bo.syntax = "scss"
	end
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.Justfile",
	group = group,
	callback = function()
		vim.bo.filetype = "just"
	end
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = group,
	callback = function() vim.hl.on_yank() end,
})

-- jump to last edit position on opening file
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
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
