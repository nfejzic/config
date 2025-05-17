---@type GetKeybindingsFn
local function get_keybindings(wezterm, _, _, tab_api)
	local act = wezterm.action

	return {
		keys = {
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
				mods = "ALT|SHIFT",
				action = act.SpawnTab("CurrentPaneDomain"),
			},

			-- create tab next to the active tab
			{
				key = "t",
				mods = "SUPER",
				action = wezterm.action_callback(tab_api
					.spawn_tab_next_to_active(wezterm)),
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
