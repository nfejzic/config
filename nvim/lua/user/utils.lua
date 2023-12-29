local M = {}

local function is_nightly()
	return vim.fn.has("nvim-0.10") ~= 0
end

M.if_not_nightly = function(fn)
	if not is_nightly then
		fn()
	end
end

M.if_nightly = function(fn)
	if is_nightly() then
		fn()
		-- is nightly and we ran the function
		return true
	end

	-- is not nightly
	return false
end

M.if_nightly_else = function(fn, else_fn)
	if not M.if_nightly(fn) then
		else_fn()
	end
end

M.print_table = function(tbl, indent)
	if not indent then
		indent = 0
	end
	for k, v in pairs(tbl) do
		local formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			M.print_table(v, indent + 1)
		elseif type(v) == "boolean" then
			print(formatting .. tostring(v))
		else
			print(formatting .. v)
		end
	end
end

return M
