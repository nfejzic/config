local M = {}

M.setup_github_cmp = function(cmp, PlenaryJob)
	local source = {}

	source.new = function()
		local self = setmetatable({ cache = {} }, { __index = source })

		return self
	end

	local ItemType = {
		PR = 0,
		Issue = 1,
	}

	local Job = PlenaryJob

	local function setup_gh_job(buffer, item_type, callback)
		local cmd = { command = "gh", args = {} }

		if item_type == ItemType.PR then
			cmd.args = { "pr", "list", "--limit", "1000", "--json", "title,number,body" }
		elseif item_type == ItemType.Issue then
			cmd.args = { "issue", "list", "--limit", "1000", "--json", "title,number,body" }
		end

		return Job:new({
			-- Uses `gh` executable to request the issues from the remote repository.
			command = cmd.command,
			args = cmd.args,
			on_exit = function(job)
				local result = job:result()
				local result_str = table.concat(result, "")

				local ok, parsed = pcall(vim.json.decode, result_str)
				if not ok and string.len(result_str) > 0 then
					print("Failed to parse gh result")
					return
				elseif string.len(result_str) == 0 then
					return
				end

				for _, gh_item in ipairs(parsed) do
					gh_item.body = string.gsub(gh_item.body or "", "\r", "")

					local label_str = ""

					if item_type == ItemType.PR then
						label_str = string.format("PR #%s: %s", gh_item.number, gh_item.title)
					elseif item_type == ItemType.Issue then
						label_str = string.format("Issue #%s: %s", gh_item.number, gh_item.title)
					end

					table.insert(buffer, {
						label = label_str,
						insertText = string.format("#%s", gh_item.number),
						documentation = {
							kind = "markdown",
							value = string.format("# %s\n\n%s", gh_item.title, gh_item.body),
						},
					})
				end

				if callback ~= nil then
					callback({ items = buffer, isIncomplete = false })
				end
			end,
		})
	end

	local function getCompletions(self, _, bufnr, callback)
		-- This just makes sure that we only hit the GH API once per session.
		if not self.cache[bufnr] then
			self.cache[bufnr] = {} -- make sure it's empty
			local issues_job = setup_gh_job(self.cache[bufnr], ItemType.Issue, nil)
			local prs_job = setup_gh_job(self.cache[bufnr], ItemType.PR, callback)

			Job.chain(issues_job, prs_job)
		else
			callback({ items = self.cache[bufnr], isIncomplete = false })
		end
	end

	source.complete = function(self, _, callback)
		local bufnr = vim.api.nvim_get_current_buf()

		Job:new({
			command = "git",
			args = { "remote", "-vv" },
			on_exit = function(job)
				local result = job:result()

				if result[1] ~= nil and string.find(result[1], "github") then
					getCompletions(self, _, bufnr, callback)
				end
			end,
		}):start()
	end

	source.get_trigger_characters = function()
		return { "#" }
	end

	source.is_available = function()
		return vim.bo.filetype == "gitcommit"
	end

	cmp.register_source("gh_issues", source.new())
end

return M
