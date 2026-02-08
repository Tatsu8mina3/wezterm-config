local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

----------------------------------------------------
-- Git auto-pull（起動時に設定を同期 → 結果を通知）
----------------------------------------------------
wezterm.on("gui-startup", function()
  local success, stdout, stderr = wezterm.run_child_process({
    "git", "-C", wezterm.config_dir, "pull", "--ff-only",
  })
  -- wezterm.GLOBAL は設定リロードをまたいで値を保持できる
  wezterm.GLOBAL.pull_result = { success = success, stdout = stdout, stderr = stderr }
end)

wezterm.on("window-config-reloaded", function(window, pane)
  local result = wezterm.GLOBAL.pull_result
  if result then
    local msg, color
    if result.success then
      local out = result.stdout:gsub("%s+$", "")
      if out == "Already up to date." or out == "Already up-to-date." then
        msg = " up to date "
        color = "#5c6d74"
      else
        msg = " config updated "
        color = "#ae8b2d"
      end
    else
      msg = " sync failed "
      color = "#cc6666"
    end
    window:set_right_status(wezterm.format({
      { Foreground = { Color = "#FFFFFF" } },
      { Background = { Color = color } },
      { Text = msg },
    }))
    -- タブが1つでもタブバーを一時表示
    local overrides = window:get_config_overrides() or {}
    overrides.hide_tab_bar_if_only_one_tab = false
    window:set_config_overrides(overrides)
    -- 5秒後にステータスを消してタブバーも元に戻す
    wezterm.time.call_after(5, function()
      window:set_right_status("")
      local o = window:get_config_overrides() or {}
      o.hide_tab_bar_if_only_one_tab = nil
      window:set_config_overrides(o)
    end)
    wezterm.GLOBAL.pull_result = nil
  end
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
