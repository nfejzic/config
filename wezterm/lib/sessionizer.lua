local M = {}

local cached = {}

--- @param fd string
--- @param paths table<string, string>,
--- @param wezterm table
local function createToggleFn(fd, paths, wezterm)
	local act = wezterm.action

	--- @param window table
	--- @param pane table
	return function(window, pane)
		wezterm.log_info("toggle sessionizer")
		if next(cached) == nil then
			for _, path in pairs(paths) do
				local success, stdout, stderr = wezterm.run_child_process({
					fd,
					"-H",
					"-I",
					"-td",
					"^.git$",
					path,
				})

				if not success then
					wezterm.log_error("Failed to run fd: " .. stderr)
					return
				end

				for line in stdout:gmatch("([^\n]*)\n?") do
					local project = line:gsub("/.git/$", "")
					local label = project
					local id = project:gsub(".*/", "")
					table.insert(cached, { label = tostring(label), id = tostring(id) })
				end
			end
		end
		window:perform_action(
			act.InputSelector({
				action = wezterm.action_callback(function(win, _, id, label)
					if not id and not label then
						wezterm.log_info("Cancelled")
					else
						wezterm.log_info("Selected " .. label)
						win:perform_action(act.SwitchToWorkspace({ name = id, spawn = { cwd = label } }), pane)
					end
				end),
				fuzzy = true,
				title = "Select project",
				choices = cached,
			}),
			pane
		)
	end
end

--- @param wezterm table
--- @param toggleFn function(window: table, pane: table)
local function createResetCacheAndToggleFn(wezterm, toggleFn)
	return function(window, pane)
		wezterm.log_info("toggle sessionizer cache clear")
		cached = {}
		toggleFn(window, pane)
	end
end

---@class Sessionizer
---@field toggle function(window: table, pane: table)
---@field resetCacheAndToggle function(window: table, pane: table)
local Sessionizer = setmetatable({}, {
	__name = "HostConfig",
})

---@class SessionizerConfig
---@field program_paths ProgramPaths
---@field paths table<string, string>,
---@field wezterm table
local SessionizerConfig = setmetatable({}, {
	__name = "HostConfig",
})

--- @param sessionizer SessionizerConfig
--- @return Sessionizer
M.setup = function(sessionizer)
	local fd = sessionizer.program_paths.fd
	local paths = sessionizer.paths

	local wezterm = require("wezterm")

	local toggleFn = createToggleFn(fd, paths, wezterm)
	local resetCacheAndToggleFn = createResetCacheAndToggleFn(wezterm, toggleFn)

	return {
		toggle = toggleFn,
		resetCacheAndToggle = resetCacheAndToggleFn,
	}
end

return M
