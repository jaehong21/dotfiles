local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- General
config.window_close_confirmation = "NeverPrompt"

-- Initial window size
config.initial_cols = 132
config.initial_rows = 36

-- Font
config.font_size = 14.4
config.line_height = 1.1
config.font = wezterm.font("Hack Nerd Font")

-- Colors
local bg = "#24263A" -- Tokyo Night Moon

config.color_scheme = "Tokyo Night Moon"
config.colors = {
	cursor_bg = "white",
	cursor_border = "white",
	tab_bar = {
		inactive_tab_edge = "#575757", -- divider between tabs
		active_tab = {
			bg_color = bg,
			fg_color = "#c0caf5", -- Tokyo Night Moon
		},
		inactive_tab = {
			bg_color = "#1a1b26", -- Tokyo Night Moon
			fg_color = "#414868", -- Tokyo Night Moon
		},
		new_tab = {
			bg_color = bg, -- Tokyo Night Moon
			fg_color = "#414868", -- Tokyo Night Moon
		},
	},
}
config.window_frame = {
	active_titlebar_bg = bg,
	inactive_titlebar_bg = bg,
}

-- Appearance
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 5,
	right = 5,
	top = 10,
	bottom = 0,
}

-- Performance
config.front_end = "WebGpu"
config.max_fps = 120
config.webgpu_power_preference = "HighPerformance"
config.prefer_egl = true

-- Keybindings
config.keys = {
	-- Clear screen
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.SendKey({ key = "L", mods = "CTRL" }),
	},
	-- Forward-word, Back-word
	{
		key = "LeftArrow",
		mods = "ALT",
		action = wezterm.action.SendString("\x1bb"),
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = wezterm.action.SendString("\x1bf"),
	},
	-- Tab navigator
	--[[ {
		key = "r",
		mods = "CMD|SHIFT",
		action = wezterm.action.ShowTabNavigator,
	}, ]]
	-- Toggle full screen
	{
		key = "f",
		mods = "CMD",
		action = wezterm.action.ToggleFullScreen,
	},
	-- New window in $HOME directory
	{
		key = "n",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewWindow({ cwd = wezterm.home_dir }),
	},
	-- New tab in $HOME directory
	{
		key = "t",
		mods = "CMD",
		-- action = wezterm.action.SpawnCommandInNewTab({ cwd = wezterm.home_dir }),
		action = wezterm.action.SpawnTab("CurrentPaneDomain"), -- default
	},
	-- Open URL
	{
		key = "o",
		mods = "CMD",
		action = wezterm.action.QuickSelectArgs({
			patterns = { "https?://[^ )'\"]+" },
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.open_with(url)
			end),
		}),
	},
	-- Close pane (Cmd+W)
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- Vertical split (Cmd+D)
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Horizontal split (Cmd+J)
	{
		key = "j",
		mods = "CMD",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Next pane
	{
		key = "]",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Next"),
	},
	-- Previous pane
	{
		key = "[",
		mods = "CMD",
		action = wezterm.action.ActivatePaneDirection("Prev"),
	},
	-- Resize window (Alt + j/k/h/l)
	{
		key = "j",
		mods = "ALT",
		action = wezterm.action.AdjustPaneSize({ "Down", 1 }),
	},
	{
		key = "k",
		mods = "ALT",
		action = wezterm.action.AdjustPaneSize({ "Up", 1 }),
	},
	{
		key = "h",
		mods = "ALT",
		action = wezterm.action.AdjustPaneSize({ "Left", 2 }),
	},
	{
		key = "l",
		mods = "ALT",
		action = wezterm.action.AdjustPaneSize({ "Right", 2 }),
	},
}

-- Tab title format
local function last_segment(path)
	-- strip trailing slash (if any) then take last component
	path = path:gsub("/+$", "")
	return path:match("([^/]+)$") or path
end
local function normalize(path)
	-- remove trailing slash
	path = path:gsub("/+$", "")
	-- convert backslashes on Windows just in case
	path = path:gsub("\\", "/")
	return path
end

---@diagnostic disable-next-line: unused-local, redefined-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local index = (tab.tab_index or 0) + 1

	local cwd = ""
	local uri = tab.active_pane and tab.active_pane.current_working_dir
	if uri then
		-- Use the parsed URL’s file path (no host prefix)
		local path = uri.file_path or tostring(uri)
		path = normalize(path)

		local home = normalize(wezterm.home_dir)
		if path == home then
			cwd = "~"
		else
			-- strip trailing slash (if any) then take last component
			cwd = last_segment(path)
		end
	end

	local title = string.format("%d. %s", index, cwd ~= "" and cwd or "~")
	return { { Text = " " .. title .. " " } }
end)

return config
