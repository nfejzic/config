local function get_keybindings(wezterm, program_paths)
	local act = wezterm.action

	local sessionizer = require("lib.sessionizer").setup(wezterm, {
		program_paths = program_paths,
		paths = { os.getenv("HOME") .. "/Developer" },
		wezterm = wezterm,
	})

	local spawn_tab_next_to_active = function(win, pane)
		local function active_tab_idx(mux_win)
			for _, item in ipairs(mux_win:tabs_with_info()) do
				-- wezterm.log_info('idx: ', idx, 'tab:', item)
				if item.is_active then
					return item.index
				end
			end
		end

		local mux_win = win:mux_window()
		local idx = active_tab_idx(mux_win)
		local _ = mux_win:spawn_tab({})
		win:perform_action(wezterm.action.MoveTab(idx + 1), pane)
	end

	return {
		leader = {
			key = " ",
			mods = "ALT",
			timeout_milliseconds = 1000,
		},

		keys = {
			{
				key = 'Backspace',
				mods = 'CTRL',
				action = act.SendKey {
					key = 'w',
					mods = 'CTRL',
				},
			},

			{
				key = "x",
				mods = "LEADER",
				action = act.ActivateCopyMode,
			},

			{
				key = "d",
				mods = "SUPER",
				action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
			},

			{
				key = "d",
				mods = "SUPER|SHIFT",
				action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
			},

			{
				key = "w",
				mods = "SUPER",
				action = act.CloseCurrentPane({ confirm = false }),
			},

			-- go to pane to the left of current pane
			{
				key = "h",
				mods = "SUPER",
				action = act.ActivatePaneDirection("Left"),
			},

			-- go to pane to the right of current pane
			{
				key = "l",
				mods = "SUPER",
				action = act.ActivatePaneDirection("Right"),
			},

			-- go to pane below current pane
			{
				key = "j",
				mods = "SUPER",
				action = act.ActivatePaneDirection("Down"),
			},

			-- go to pane above current pane
			{
				key = "k",
				mods = "SUPER",
				action = act.ActivatePaneDirection("Up"),
			},

			-- pane resizing
			{
				key = "H",
				mods = "SUPER|SHIFT",
				action = act.AdjustPaneSize({ "Left", 5 }),
			},

			{
				key = "J",
				mods = "SUPER|SHIFT",
				action = act.AdjustPaneSize({ "Down", 5 }),
			},

			{
				key = "K",
				mods = "SUPER|SHIFT",
				action = act.AdjustPaneSize({ "Up", 5 }),
			},

			{
				key = "L",
				mods = "SUPER|SHIFT",
				action = act.AdjustPaneSize({ "Right", 5 }),
			},

			-- create tab next to the active tab
			{
				key = "t",
				mods = "SUPER",
				action = wezterm.action_callback(spawn_tab_next_to_active),
			},

			{
				key = "t",
				mods = "SUPER|SHIFT",
				action = act.SpawnTab("CurrentPaneDomain"),
			},

			-- go to next tab
			{
				key = "n",
				mods = "SUPER",
				action = act.ActivateTabRelative(1),
			},

			-- go to previous tab
			{
				key = "p",
				mods = "SUPER",
				action = act.ActivateTabRelative(-1),
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
						act.PromptInputLine({
							description = wezterm.format({
								{ Attribute = { Intensity = "Bold" } },
								{ Foreground = { AnsiColor = "Fuchsia" } },
								{ Text = t },
							}),
							action = wezterm.action_callback(function(window, pane, line)
								-- line will be `nil` if they hit escape without entering anything
								-- An empty string if they just hit enter
								-- Or the actual line of text they wrote
								if line then
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
				action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
			},

			{
				key = "l",
				mods = "LEADER",
				action = act.ShowLauncherArgs({
					flags = "FUZZY|TABS|DOMAINS|KEY_ASSIGNMENTS|WORKSPACES|COMMANDS|LAUNCH_MENU_ITEMS",
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
		},
	}
end
---
--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local jetbrains_mono = {
	family = "JetBrains Mono",
	size = 22,
	cell_width = 1,
	line_height = 1.05,
	harfbuzz_features = {
		"cv01", --    slab 'l'
		"cv12", -- regular 'u'
	},
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local comic_code = {
	family = "Comic Code",
	size = 22,
	line_height = 1.15,
	cell_width = 1,
	harfbuzz_features = { "zero", "dlig" },
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local monolisa = {
	family = "MonoLisa",
	size = 22,
	line_height = 1,
	cell_width = 0.95,
	harfbuzz_features = {
		"ss11", -- centered 'x' in 0xF
		-- "ss02", -- cursive italic
		"ss07", -- more agressive '{' and '}'
	},
}

--- @type HostConfig
local config = {
	dpi = 108,
	font = monolisa,
	update_dpi = true,
	program_paths = {
		fd = require("lib.utils").execute("which fd")
	},
	get_keybindings = get_keybindings,
	window_padding = { top = "27pt", right = "0cell", bottom = "0cell", left = "0cell" },
}

config.font = comic_code
config.font = monolisa
config.font.freetype_load_flags = "NO_AUTOHINT"

return config
