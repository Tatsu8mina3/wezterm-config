-- WezTerm キーバインド設定
-- Windows: Ctrl / Mac: Command (SUPER) で切り替え

local wezterm = require("wezterm")
local act = wezterm.action

local is_windows = wezterm.target_triple:find("windows") ~= nil
local mod = is_windows and "CTRL" or "SUPER"
local mod_shift = is_windows and "CTRL|SHIFT" or "SUPER|SHIFT"

----------------------------------------------------
-- Mac用: フルスクリーン代わりに最大化（透過を維持）
----------------------------------------------------
local maximized_state = {}

local toggle_maximize = wezterm.action_callback(function(window, pane)
  local id = window:window_id()
  local screen = wezterm.gui.screens().active
  if maximized_state[id] then
    local orig = maximized_state[id]
    window:set_inner_size(orig.w, orig.h)
    maximized_state[id] = nil
  else
    local dims = window:get_dimensions()
    maximized_state[id] = { w = dims.pixel_width, h = dims.pixel_height }
    window:set_position(screen.x, screen.y)
    window:set_inner_size(screen.width, screen.height)
  end
end)

local keys = {
  -- --------------------------------------------------
  -- コピー・ペースト
  -- --------------------------------------------------
  -- Windows: Ctrl+C / Mac: Cmd+C
  { key = "c", mods = mod, action = act.CopyTo("Clipboard") },
  -- プロセス中断（Windows: Ctrl+Shift+C / Mac: Cmd+Shift+C）
  { key = "c", mods = mod_shift, action = act.SendKey({ key = "c", mods = "CTRL" }) },
  -- Windows: Ctrl+V / Mac: Cmd+V
  { key = "v", mods = mod, action = act.PasteFrom("Clipboard") },
  { key = "Insert", mods = "CTRL", action = act.CopyTo("PrimarySelection") },
  { key = "Insert", mods = "SHIFT", action = act.PasteFrom("PrimarySelection") },

  -- --------------------------------------------------
  -- タブ操作
  -- --------------------------------------------------
  { key = "t", mods = mod, action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = mod, action = act.CloseCurrentTab({ confirm = true }) },
  { key = "]", mods = mod_shift, action = act.ActivateTabRelative(1) },
  { key = "[", mods = mod_shift, action = act.ActivateTabRelative(-1) },
  { key = "PageUp", mods = mod, action = act.ActivateTabRelative(-1) },
  { key = "PageDown", mods = mod, action = act.ActivateTabRelative(1) },
  { key = "PageUp", mods = mod_shift, action = act.MoveTabRelative(-1) },
  { key = "PageDown", mods = mod_shift, action = act.MoveTabRelative(1) },
  -- タブ1〜9
  { key = "1", mods = mod_shift, action = act.ActivateTab(0) },
  { key = "2", mods = mod_shift, action = act.ActivateTab(1) },
  { key = "3", mods = mod_shift, action = act.ActivateTab(2) },
  { key = "4", mods = mod_shift, action = act.ActivateTab(3) },
  { key = "5", mods = mod_shift, action = act.ActivateTab(4) },
  { key = "6", mods = mod_shift, action = act.ActivateTab(5) },
  { key = "7", mods = mod_shift, action = act.ActivateTab(6) },
  { key = "8", mods = mod_shift, action = act.ActivateTab(7) },
  { key = "9", mods = mod_shift, action = act.ActivateLastTab },

  -- --------------------------------------------------
  -- ペイン操作（直接）
  -- --------------------------------------------------
  { key = "LeftArrow", mods = mod_shift, action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = mod_shift, action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = mod_shift, action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = mod_shift, action = act.ActivatePaneDirection("Down") },
  { key = "z", mods = mod_shift, action = act.TogglePaneZoomState },

  -- --------------------------------------------------
  -- ウィンドウ・フォント
  -- --------------------------------------------------
  { key = "n", mods = mod_shift, action = act.SpawnWindow },
  { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
  { key = "-", mods = mod, action = act.DecreaseFontSize },
  { key = "=", mods = mod, action = act.IncreaseFontSize },
  { key = "0", mods = mod, action = act.ResetFontSize },

  -- --------------------------------------------------
  -- その他
  -- --------------------------------------------------
  { key = "r", mods = mod_shift, action = act.ReloadConfiguration },
  { key = "k", mods = mod_shift, action = act.ClearScrollback("ScrollbackOnly") },
  { key = "l", mods = mod_shift, action = act.ShowDebugOverlay },
  { key = "p", mods = mod_shift, action = act.ActivateCommandPalette },
  { key = "f", mods = mod_shift, action = act.Search({ CaseSensitiveString = "" }) },
  { key = "Space", mods = mod_shift, action = act.QuickSelect },
  { key = "x", mods = mod_shift, action = act.ActivateCopyMode },
  { key = "u", mods = mod_shift, action = act.CharSelect },

  -- スクロール
  { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },

  -- アプリ終了（Mac: Cmd+Q / Windows: Ctrl+Q）
  { key = "q", mods = mod, action = act.QuitApplication },
}

local key_tables = {
  resize_pane = {
    { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "Escape", action = act.PopKeyTable },
  },
  activate_pane = {
    { key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
    { key = "h", action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", action = act.ActivatePaneDirection("Right") },
    { key = "l", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow", action = act.ActivatePaneDirection("Up") },
    { key = "k", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow", action = act.ActivatePaneDirection("Down") },
    { key = "j", action = act.ActivatePaneDirection("Down") },
  },
}

return {
  keys = keys,
  key_tables = key_tables,
}
