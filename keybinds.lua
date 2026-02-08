-- WezTerm キーバインド設定
-- Leader: Ctrl+q

local act = require("wezterm").action

local keys = {
  -- --------------------------------------------------
  -- コピー・ペースト
  -- --------------------------------------------------
  -- ※Ctrl+Cをコピーに割り当てたので、プロセス中断はCtrl+Shift+Cで
  { key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
  { key = "c", mods = "CTRL|SHIFT", action = act.SendKey({ key = "c", mods = "CTRL" }) },
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
  { key = "Insert", mods = "CTRL", action = act.CopyTo("PrimarySelection") },
  { key = "Insert", mods = "SHIFT", action = act.PasteFrom("PrimarySelection") },

  -- --------------------------------------------------
  -- タブ操作
  -- --------------------------------------------------
  { key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
  { key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "PageUp", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "PageDown", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },
  -- タブ1〜9
  { key = "1", mods = "CTRL|SHIFT", action = act.ActivateTab(0) },
  { key = "2", mods = "CTRL|SHIFT", action = act.ActivateTab(1) },
  { key = "3", mods = "CTRL|SHIFT", action = act.ActivateTab(2) },
  { key = "4", mods = "CTRL|SHIFT", action = act.ActivateTab(3) },
  { key = "5", mods = "CTRL|SHIFT", action = act.ActivateTab(4) },
  { key = "6", mods = "CTRL|SHIFT", action = act.ActivateTab(5) },
  { key = "7", mods = "CTRL|SHIFT", action = act.ActivateTab(6) },
  { key = "8", mods = "CTRL|SHIFT", action = act.ActivateTab(7) },
  { key = "9", mods = "CTRL|SHIFT", action = act.ActivateLastTab },

  -- --------------------------------------------------
  -- ペイン操作（直接）
  -- --------------------------------------------------
  { key = "LeftArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
  { key = "z", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },

  -- --------------------------------------------------
  -- ウィンドウ・フォント
  -- --------------------------------------------------
  { key = "n", mods = "CTRL|SHIFT", action = act.SpawnWindow },
  { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },

  -- --------------------------------------------------
  -- その他
  -- --------------------------------------------------
  { key = "r", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },
  { key = "k", mods = "CTRL|SHIFT", action = act.ClearScrollback("ScrollbackOnly") },
  { key = "l", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
  { key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },
  { key = "f", mods = "CTRL|SHIFT", action = act.Search({ CaseSensitiveString = "" }) },
  { key = "Space", mods = "CTRL|SHIFT", action = act.QuickSelect },
  { key = "x", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
  { key = "u", mods = "CTRL|SHIFT", action = act.CharSelect },

  -- スクロール
  { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },

  -- --------------------------------------------------
  -- Leader (Ctrl+q) キーバインド
  -- --------------------------------------------------
  -- ペイン分割
  { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  -- ペインリサイズモード
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "resize_pane",
      one_shot = false,
    }),
  },
  -- ペイン切り替えモード
  {
    key = "a",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "activate_pane",
      timeout_milliseconds = 1000,
    }),
  },
  -- Ctrl+q をそのまま送る（2回押した場合）
  {
    key = "q",
    mods = "LEADER|CTRL",
    action = act.SendKey({ key = "q", mods = "CTRL" }),
  },
}

local key_tables = {
  -- ペインリサイズ（Ctrl+q → r の後、h/j/k/l または矢印キーでリサイズ）
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
  -- ペイン切り替え（Ctrl+q → a の後、h/j/k/l または矢印キーでフォーカス移動）
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
