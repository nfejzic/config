-- This is the default keybindings configuration. See hostconf for keybindings specific to the given hosts
--- @class KeybindConfig
local M = {}
-- timeout_milliseconds defaults to 1000 and can be omitted

---@type GetKeybindingsFn
function M.get_keybindings(wezterm, program_paths, utils, _)
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
			{
				key = "x",
				mods = "LEADER",
				action = act.ActivateCopyMode,
			},

			-- Prompt for a name to use for a new workspace and switch to it.
			{
				key = "n",
				mods = "LEADER",
				action = wezterm.action_callback(function(_win, _p, _l)
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
						act.InputSelector({
							action = wezterm.action_callback(function(win, _, id,
																	  label)
								if not id and not label then
									wezterm.log_info(
										"Switch workspace cancelled")
								else
									wezterm.log_info("Selected workspace " ..
										label)
									utils.workspace_switch_event(wezterm)
									win:perform_action(
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
