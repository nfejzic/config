local M = {}

local function is_nightly()
	return vim.fn.has("nvim-0.10") > 0
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

--- @param package string the name of the Mason package
--- @return string|nil path path of the package, or nil if not installed
function M.mason_path(package)
	local mr = require("mason-registry")

	if not mr.is_installed(package) then
		return nil
	else
		local pkg = mr.get_package(package)
		return pkg:get_install_path()
	end
end

--- @param tbl table the table we want to check, has `string` values
--- @param val string the value we're looking for
--- @return boolean `true` if table contains the value, otherwise `false`
local function table_contains_val(tbl, val)
	for _, v in ipairs(tbl) do
		if v == val then
			return true
		end
	end
	return false
end

--- @param conform unknown the `conform.nvim` is required for formatters
--- @param fmts table|string Single formatter, or list of formatters to filter out
--- @return table list of formatters that should be applied for the given buffer
function M.filter_out_formatters(conform, fmts, bufnr)
	local formatters = {}
	local buf_fmts = conform.list_formatters(bufnr)

	for _, fmt in ipairs(buf_fmts) do
		local should_insert = false
		---@diagnostic disable-next-line: undefined-field

		if type(fmts) == "string" then
			if fmt.name ~= fmts then
				should_insert = true
			end
		else
			if not table_contains_val(fmts, fmt.name) then
				---@diagnostic disable-next-line: undefined-field
				should_insert = true
			end
		end

		if should_insert then
			table.insert(formatters, fmt.name)
		end
	end

	return formatters
end

return M
