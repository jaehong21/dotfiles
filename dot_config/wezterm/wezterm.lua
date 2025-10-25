local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.front_end = "WebGpu"
config.max_fps = 120
config.webgpu_power_preference = "HighPerformance"

return config
