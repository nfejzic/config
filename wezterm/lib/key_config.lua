-- This is the default keybindings configuration. See hostconf for keybindings specific to the given hosts
--- @class KeysConfig
local M = {}
-- timeout_milliseconds defaults to 1000 and can be omitted

--- @param wezterm Wezterm
--- @param program_paths ProgramPaths
--- @param utils Utils
--- @param tab_api TabApi
--- @param mods { super: string, super_shift: string }
--- @param smart_splits SmartSplits
function M.get_keybindings(wezterm, program_paths, utils, tab_api, mods, smart_splits)
	local act = wezterm.action

	local sessionizer = require("lib.sessionizer").setup(
		wezterm, {
			program_paths = program_paths,
			paths = { os.getenv("HOME") .. "/Developer" },
			wezterm = wezterm,
		},
		utils
	)

	return {
		leader = {
			key = " ",
			mods = "ALT",
			timeout_milliseconds = 1000,
		},

		keys = {
			-- Delete word on CTRL + Backspace
			{
				key = 'Backspace',
				mods = 'CTRL',
				action = act.SendKey {
					key = 'w',
					mods = 'CTRL',
				},
			},

			{
				key = "d",
				mods = mods.super,
				action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
			},

			{
				key = "d",
				mods = mods.super_shift,
				action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
			},

			{
				key = "w",
				mods = mods.super,
				action = wezterm.action_callback(
					function(win, pane)
						if smart_splits.is_vim(pane) then
							win:perform_action(act.SendKey({ key = "w", mods = 'ALT' }), pane)
						else
							wezterm.log_info("closing current pane")
							win:perform_action(act.CloseCurrentPane({ confirm = false }), pane)
						end
					end
				)
			},

			-- create tab next to the active tab
			{
				key = "t",
				mods = mods.super,
				action = wezterm.action_callback(tab_api.spawn_tab_next_to_active(wezterm)),
			},

			{
				key = "t",
				mods = mods.super_shift,
				action = act.SpawnTab("CurrentPaneDomain"),
			},

			-- go to next tab
			{
				key = "n",
				mods = mods.super,
				action = act.ActivateTabRelative(1),
			},

			-- go to previous tab
			{
				key = "p",
				mods = mods.super,
				action = act.ActivateTabRelative(-1),
			},

			{
				key = "x",
				mods = "LEADER",
				action = act.ActivateCopyMode,
			},

			-- Prompt for a name to use for a new workspace and switch to it.
			{
				key = "n",
				mods = "LEADER",
				action = wezterm.action_callback(function(_win, _p, _)
					local active_workspaces = wezterm.mux.get_workspace_names()

					local t = ""

					if #active_workspaces > 1 then
						t = t .. "Currently active workspaces: \n"
						for i, n in ipairs(active_workspaces) do
							t = t .. i .. ": " .. n .. "\n"
						end
						t = t .. "\n"
					end

					t = t .. "Enter name for new (or existing) workspace"

					_win:perform_action(
					-- NOTE: it seems like these warnings are false positive
					---@diagnostic disable-next-line: param-type-mismatch
						act.PromptInputLine({
							description = wezterm.format({
								{ Attribute = { Intensity = "Bold" } },
								{ Foreground = { AnsiColor = "Fuchsia" } },
								{ Text = t },
							}),
							action = wezterm.action_callback(function(window,
																	  pane, line)
								-- line will be `nil` if they hit escape without entering anything
								-- An empty string if they just hit enter
								-- Or the actual line of text they wrote
								if line then
									utils.workspace_switch_event(wezterm)
									window:perform_action(
									---@diagnostic disable-next-line: param-type-mismatch
										act.SwitchToWorkspace({
											name = line,
										}),
										pane
									)
								end
							end),
						}),
						_p
					)
				end),
			},

			{
				key = "s",
				mods = "LEADER",

				action = wezterm.action_callback(function(window, pane)
					local workspaces = wezterm.mux.get_workspace_names()

					local workspaces_list = {}

					for _, workspace in pairs(workspaces) do
						table.insert(workspaces_list,
							{ label = workspace, id = workspace })
					end

					window:perform_action(
					-- NOTE: it seems like these warnings are false positive
					---@diagnostic disable-next-line: param-type-mismatch
						act.InputSelector({
							action = wezterm.action_callback(function(win, _, id,
																	  label)
								if not id and not label then
									return
								else
									wezterm.log_info("Selected workspace " ..
										label)
									utils.workspace_switch_event(wezterm)
									win:perform_action(
									---@diagnostic disable-next-line: param-type-mismatch
										act.SwitchToWorkspace({ name = id }),
										pane)
								end
							end),
							choices = workspaces_list,
							fuzzy = true,
						}),
						pane
					)
				end)
			},

			{
				key = "l",
				mods = "LEADER",
				action = act.ShowLauncherArgs({
					flags =
					"FUZZY|TABS|DOMAINS|KEY_ASSIGNMENTS|WORKSPACES|COMMANDS|LAUNCH_MENU_ITEMS",
				}),
			},

			-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
			{
				key = "a",
				mods = "LEADER|CTRL",
				action = act.SendKey({ key = "a", mods = "CTRL" }),
			},

			-- enter the quickselection mode
			{
				key = "v",
				mods = "LEADER",
				action = act.QuickSelect,
			},

			{
				key = "f",
				mods = "LEADER",
				action = wezterm.action_callback(sessionizer.toggle),
			},

			{
				key = "F",
				mods = "LEADER",
				action = wezterm.action_callback(sessionizer.resetCacheAndToggle),
			},

			{
				key = " ",
				mods = "LEADER|ALT",
				action = act.EmitEvent(utils.events.SWITCH_TO_LAST_WORKSPACE),
			},
		},
	}
end

return M
