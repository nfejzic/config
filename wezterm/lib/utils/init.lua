---@class Utils
local M = {
	tbl = {}
}

---Perform a deep copy of a table.
---@generic T: table
---@param tbl T Table that we want to make a deep copy of.
---@return T
function M.tbl.copy(tbl)
	local t2 = {};
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			t2[k] = M.tbl.copy(v);
		else
			t2[k] = v;
		end
	end
	return t2;
end

--- @generic T: table
--- @param tbl T
--- @param overwrites T
function M.tbl.overwrite(tbl, overwrites)
	for key, value in pairs(tbl) do
		if overwrites[key] == nil then
			tbl[key] = value
		elseif type(tbl[key]) == "table" then
			M.tbl.overwrite(tbl[key], overwrites[key])
		else
			tbl[key] = overwrites[key]
		end
	end
end

---Perform a deep copy of a table.
---@generic K, V
---@param tbl table<K, V> Table that we want to make a deep copy of.
---@return table<K, V>
function M.tbl.copy_and_overwrite(tbl, overwrites)
	local copy = M.tbl.copy(tbl)
	M.tbl.overwrite(copy, overwrites)
	return copy;
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
