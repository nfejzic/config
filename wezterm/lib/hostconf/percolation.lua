--- @param wezterm table
local function get_keybindings(wezterm, program_paths)
	local act = wezterm.action

	local sessionizer = require("lib.sessionizer").setup(wezterm, {
		program_paths = program_paths,
		paths = { os.getenv("HOME") .. "/Developer" },
		wezterm = wezterm,
	})

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

			{
				key = "v",
				mods = "ALT",
				action = act.PasteFrom('Clipboard'),
			},

			{
				key = "Backspace",
				mods = "CTRL",
				action = act.SendKey({
					key = 'w',
					mods = 'CTRL',
				})
			},

			{
				key = "d",
				mods = "ALT",
				action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
			},

			{
				key = "d",
				mods = "ALT|SHIFT",
				action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
			},

			{
				key = "w",
				mods = "ALT",
				action = act.CloseCurrentPane({ confirm = false }),
			},

			-- go to pane to the left of current pane
			{
				key = "h",
				mods = "ALT",
				action = act.ActivatePaneDirection("Left"),
			},

			-- go to pane to the right of current pane
			{
				key = "l",
				mods = "ALT",
				action = act.ActivatePaneDirection("Right"),
			},

			-- go to pane below current pane
			{
				key = "j",
				mods = "ALT",
				action = act.ActivatePaneDirection("Down"),
			},

			-- go to pane above current pane
			{
				key = "k",
				mods = "ALT",
				action = act.ActivatePaneDirection("Up"),
			},

			-- pane resizing
			{
				key = "H",
				mods = "ALT|SHIFT",
				action = act.AdjustPaneSize({ "Left", 5 }),
			},

			{
				key = "J",
				mods = "ALT|SHIFT",
				action = act.AdjustPaneSize({ "Down", 5 }),
			},

			{
				key = "K",
				mods = "ALT|SHIFT",
				action = act.AdjustPaneSize({ "Up", 5 }),
			},

			{
				key = "L",
				mods = "ALT|SHIFT",
				action = act.AdjustPaneSize({ "Right", 5 }),
			},

			-- create new tab
			{
				key = "t",
				mods = "ALT",
				action = act.SpawnTab("CurrentPaneDomain"),
			},

			-- go to next tab
			{
				key = "n",
				mods = "ALT",
				action = act.ActivateTabRelative(1),
			},

			-- go to previous tab
			{
				key = "p",
				mods = "ALT",
				action = act.ActivateTabRelative(-1),
			},

			-- Prompt for a name to use for a new workspace and switch to it.
			{
				key = "n",
				mods = "SUPER",
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

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local comic_code = {
	family = "Comic Code",
	size = 17,
	cell_width = 1.00,
	line_height = 1.12,
	harfbuzz_features = {
		-- dotted zero
		"zero"
	}
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local jetbrains_mono = {
	family = "JetBrains Mono",
	size = 15,
	cell_width = 1,
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local jetbrains_mono_comfy = {
	family = "JetBrains Mono",
	size = 16,
	cell_width = 1,
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local monolisa = {
	-- Font custom-hosted here: https://github.com/nfejzic/monolisa
	family = "MonoLisa",
	size = 23,
	cell_width = 1,
	line_height = 1.00,
	freetype_load_flags = "NO_HINTING",
	harfbuzz_features = {
		-- centered hexadecimal 0xF
		"ss11",
	},
}

--- @type HostConfig
local config = {
	dpi = nil,
	font = comic_code,
	update_dpi = false,
	program_paths = { fd = "/usr/bin/fd" },
	get_keybindings = get_keybindings,
	window_decorations = "NONE",
}

return config
