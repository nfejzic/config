local M = {
	table = {}
}

---Perform a deep copy of a table.
---@param table table Table that we want to make a deep copy of.
function M.table.copy(table)
	local t2 = {};
	for k, v in pairs(table) do
		if type(v) == "table" then
			t2[k] = M.table.copy(v);
		else
			t2[k] = v;
		end
	end
	return t2;
end

---@param command string Command to execute in the user's default shell
function M.execute(command)
	local shell = os.getenv("SHELL")
	local pipe = io.popen(shell .. " --command '" .. command .. "'")

	if pipe then
		local command_output = pipe:read("*a")
		return string.gsub(command_output, "%s+", "")
	else
		return ""
	end
end

M.events = {
	WORKSPACE_SWITCHED = 'workspace_switch',
	SWITCH_TO_LAST_WORKSPACE = 'switch-to-last-workspace',
}

function M.workspace_switch_event(wezterm)
	wezterm.emit(M.events.WORKSPACE_SWITCHED)
end

return M
