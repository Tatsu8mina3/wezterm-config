local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

----------------------------------------------------
-- Git auto-pull（起動時に設定を同期）
----------------------------------------------------
wezterm.on("gui-startup", function()
  wezterm.background_child_process({
    "git", "-C", wezterm.config_dir, "pull", "--ff-only",
  })
end)
config.font_size = 12.0
config.use_ime = true
config.front_end = "OpenGL"
config.window_background_opacity = 0.6
config.macos_window_background_blur = 0
config.native_macos_fullscreen_mode = false

----------------------------------------------------
-- Shell
----------------------------------------------------
-- Windows のときだけ Git Bash、Mac/Linux はデフォルトシェル
local is_windows = wezterm.target_triple:find("windows") ~= nil
if is_windows then
  config.default_prog = { "C:/Program Files/Git/bin/bash.exe", "-l" }
end

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示（Macではブラー付き透過を有効化）
if is_windows then
  config.window_decorations = "RESIZE"
else
  config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"
end
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる（※透過と競合するためMacでは無効化）
if is_windows then
  config.window_background_gradient = {
    colors = { "#000000" },
  }
end

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- show_close_tab_button_in_tabs は nightly 版のみ対応のためコメントアウト

-- タブ同士の境界線を非表示
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

return config
