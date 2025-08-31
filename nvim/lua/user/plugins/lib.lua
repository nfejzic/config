local M = {
	--- @param repo string the 'username/repo-name' string
	--- @return string
	github = function(repo)
		return string.format("https://github.com/%s", repo)
	end
}

return M
