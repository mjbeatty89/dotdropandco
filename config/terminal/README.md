# Terminal Configuration

This directory contains configuration files for terminal emulators and terminal multiplexers.

## Supported Applications

### Tmux
- `tmux.conf` → `~/.tmux.conf`

### Alacritty
- `alacritty.yml` → `~/.config/alacritty/alacritty.yml`

### Kitty
- `kitty.conf` → `~/.config/kitty/kitty.conf`

### iTerm2 (macOS)
- `com.googlecode.iterm2.plist` → iTerm2 preferences

## Example Configurations

### Tmux Configuration
```bash
# Set prefix to Ctrl-a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Enable mouse mode
set -g mouse on

# Start windows and panes at 1
set -g base-index 1
setw -g pane-base-index 1
```

### Alacritty Configuration
```yaml
window:
  padding:
    x: 2
    y: 2

font:
  normal:
    family: Monaco
  size: 14

colors:
  primary:
    background: '0x1d1f21'
    foreground: '0xc5c8c6'
```

## Installation

Run `../../scripts/install.sh` from the repository root to install all terminal configurations.