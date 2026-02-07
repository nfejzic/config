local M = {}

local function is_nightly()
	return vim.fn.has("nvim-0.10") > 0
end

function M.if_not_nightly(fn)
	if not is_nightly then
		fn()
	end
end

function M.if_nightly(fn)
	if is_nightly() then
		fn()
		-- is nightly and we ran the function
		return true
	end

	-- is not nightly
	return false
end

function M.if_nightly_else(fn, else_fn)
	if not M.if_nightly(fn) then
		else_fn()
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

function M.clearInterval(timer)
	timer:stop()
	timer:close()
end

--- Checks (naively) whether we're in an LLM prompt by matching file name against patterns.
function M.is_llm_prompt()
	local buf_name = vim.api.nvim_buf_get_name(0)
	local is_prompt = string.match(buf_name, "claude%-prompt")

	return is_prompt
end

return M
