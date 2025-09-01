return {
	root_dir = function(bufnr, on_dir) on_dir(require("lazydev").find_workspace(bufnr)) end,
}
