# Manual macOS settings

These settings are not automated because their UI or preference keys can change
between macOS releases.

## Window management

In **System Settings → Desktop & Dock**, review:

- Tile by dragging windows to screen edges: enabled
- Hold the pointer over the green button to show tiling options: enabled
- Show suggested tiled windows: enabled
- Move tiled windows by dragging: enabled
- Tiled windows have margins: enabled
- Stage Manager: disabled

## Keyboard navigation

In **System Settings → Keyboard → Keyboard Shortcuts**, verify full keyboard
access. Tab and Shift-Tab should move focus, Space should activate a focused
control, and Enter should keep its normal dialog/text-entry behavior.

## Suggested window shortcuts

In **System Settings → Keyboard → Keyboard Shortcuts → Window**, optionally set:

| Action | Shortcut |
| --- | --- |
| Tile Left | Control Option Command Left |
| Tile Right | Control Option Command Right |
| Tile Top | Control Option Command Up |
| Tile Bottom | Control Option Command Down |
| Center | Control Option Command C |
| Fill | Control Option Command F |

## Appearance

Consider a fixed Light or Dark appearance, Graphite accent color, and small
sidebar icons. These remain personal choices and are not forced by the script.

## Documented optional automation

Further commented examples are kept next to the active configuration:

- `macos-defaults.sh`: effectively hidden Dock, quitting Finder, and the
  deliberately discouraged Gatekeeper-quarantine override
- `bootstrap.sh`: deterministic Dock layout using `dockutil`
- `Brewfile`: optional `mas`, `dockutil`, `mise`, Visual Studio Code and Obsidian
