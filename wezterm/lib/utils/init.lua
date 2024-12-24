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

return M
