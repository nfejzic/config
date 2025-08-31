require("user.core")
require("user.plugins")

local work_plugins_path = vim.fn.stdpath('config') .. '/lua/user/work_plugins'

if vim.uv.fs_stat(work_plugins_path) ~= nil then
	require("user.work_plugins")
end

vim.cmd("colo colorize")
