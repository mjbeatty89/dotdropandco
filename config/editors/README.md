# Editor Configuration

This directory contains configuration files for various text editors and IDEs.

## Supported Editors

### Vim/Neovim
- `vimrc` → `~/.vimrc`
- `init.vim` → `~/.config/nvim/init.vim`
- `nvim/` → `~/.config/nvim/` (full directory)

### VS Code
- `vscode/settings.json` → `~/Library/Application Support/Code/User/settings.json` (macOS)
- `vscode/settings.json` → `~/.config/Code/User/settings.json` (Linux)
- `vscode/keybindings.json` → User keybindings
- `vscode/snippets/` → User snippets

### Sublime Text
- `sublime/` → Platform-specific Sublime Text user directory

## Example Configurations

### Vim Configuration
```vim
" Basic settings
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
syntax on
```

### VS Code Settings
```json
{
    "editor.fontSize": 14,
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "workbench.colorTheme": "Dark+ (default dark)",
    "files.autoSave": "afterDelay"
}
```

## Installation

Run `../../scripts/install.sh` from the repository root to install all editor configurations.