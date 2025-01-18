if vim.loop.os_uname().sysname ~= "Darwin" then
	return {}
end

local which_ghostty = vim.system({ 'which', 'ghostty' }, { text = true }):wait()

if string.len(which_ghostty.stdout) == 0 then
	return {}
end

local resources_dir = "/Applications/Ghostty.app/Contents/Resources/nvim/site/"

return {
	"ghostty",
	dir = resources_dir,
	lazy = false,
}
