--- @type vim.lsp.Config
return {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "tf" },
	root_markers = { '.terraformignore', '.git' },
}
