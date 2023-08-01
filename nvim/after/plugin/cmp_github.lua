local plenary_exists, Job = pcall(require, "plenary.job")
if not plenary_exists then
  print("Plenary does not exist")
  return
end

local source = {}

source.new = function()
  local self = setmetatable({ cache = {} }, { __index = source })

  return self
end

local function getCompletions(self, _, bufnr, callback)
  -- This just makes sure that we only hit the GH API once per session.
  --
  -- You could remove this if you wanted, but this just makes it so we're
  -- good programming citizens.
  if not self.cache[bufnr] then
    local issues_job = Job
        :new({
          -- Uses `gh` executable to request the issues from the remote repository.
          "gh",
          "issue",
          "list",
          "--limit",
          "1000",
          "--json",
          "title,number,body",
          on_exit = function(job)
            local result = job:result()
            local ok, parsed = pcall(vim.json.decode, table.concat(result, ""))
            if not ok then
              vim.notify("Failed to parse gh result")
              return
            end

            self.cache[bufnr] = {}
            for _, gh_item in ipairs(parsed) do
              gh_item.body = string.gsub(gh_item.body or "", "\r", "")

              table.insert(self.cache[bufnr], {
                label = string.format("Issue #%s: %s", gh_item.number, gh_item.title),
                insertText = string.format("#%s", gh_item.number),
                documentation = {
                  kind = "markdown",
                  value = string.format("# %s\n\n%s", gh_item.title, gh_item.body),
                },
              })
            end
          end,
        })

    local prs_job = Job
        :new({
          -- Uses `gh` executable to request the issues from the remote repository.
          "gh",
          "pr",
          "list",
          "--limit",
          "1000",
          "--json",
          "title,number,body",
          on_exit = function(job)
            local result = job:result()
            local ok, parsed = pcall(vim.json.decode, table.concat(result, ""))
            if not ok then
              vim.notify("Failed to parse gh result")
              return
            end

            -- local items = {}
            for _, gh_item in ipairs(parsed) do
              gh_item.body = string.gsub(gh_item.body or "", "\r", "")

              table.insert(self.cache[bufnr], {
                label = string.format("PR #%s: %s", gh_item.number, gh_item.title),
                insertText = string.format("#%s", gh_item.number),
                documentation = {
                  kind = "markdown",
                  value = string.format("# %s\n\n%s", gh_item.title, gh_item.body),
                },
              })
            end

            callback { items = self.cache[bufnr], isIncomplete = false }
          end,
        })

    Job.chain(issues_job, prs_job)
  else
    callback { items = self.cache[bufnr], isIncomplete = false }
  end
end

source.complete = function(self, _, callback)
  local bufnr = vim.api.nvim_get_current_buf()

  Job:new({
    "git",
    "remote",
    "-vv",
    on_exit = function(job)
      local result = job:result()

      if result[1] ~= nil and string.find(result[1], "github") then
        getCompletions(self, _, bufnr, callback)
      end
    end
  }):start()
end

source.get_trigger_characters = function()
  return { "#" }
end

source.is_available = function()
  return vim.bo.filetype == "gitcommit"
end

require("cmp").register_source("gh_issues", source.new())
