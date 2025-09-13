#!/bin/bash

# Dotfiles Backup Script
# This script will collect your current dotfiles and organize them in this repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"

echo -e "${BLUE}📦 Collecting dotfiles from your system...${NC}"
echo -e "${BLUE}Dotfiles directory: $DOTFILES_DIR${NC}"

# Function to copy file if it exists
copy_if_exists() {
    local source_file="$1"
    local target_file="$2"
    
    if [[ -f "$source_file" ]] && [[ ! -L "$source_file" ]]; then
        local target_dir="$(dirname "$target_file")"
        mkdir -p "$target_dir"
        
        echo -e "${GREEN}Copying: $source_file -> $target_file${NC}"
        cp "$source_file" "$target_file"
        return 0
    fi
    return 1
}

# Function to copy directory if it exists
copy_dir_if_exists() {
    local source_dir="$1"
    local target_dir="$2"
    
    if [[ -d "$source_dir" ]] && [[ ! -L "$source_dir" ]]; then
        mkdir -p "$(dirname "$target_dir")"
        
        echo -e "${GREEN}Copying directory: $source_dir -> $target_dir${NC}"
        cp -r "$source_dir" "$target_dir"
        return 0
    fi
    return 1
}

# Function to backup shell configs
backup_shell_configs() {
    echo -e "${BLUE}🐚 Backing up shell configurations...${NC}"
    
    local shell_dir="$CONFIG_DIR/shell"
    local found=false
    
    # Bash
    copy_if_exists "$HOME/.bashrc" "$shell_dir/bashrc" && found=true
    copy_if_exists "$HOME/.bash_profile" "$shell_dir/bash_profile" && found=true
    copy_if_exists "$HOME/.bash_aliases" "$shell_dir/bash_aliases" && found=true
    copy_if_exists "$HOME/.profile" "$shell_dir/profile" && found=true
    
    # Zsh
    copy_if_exists "$HOME/.zshrc" "$shell_dir/zshrc" && found=true
    copy_if_exists "$HOME/.zsh_aliases" "$shell_dir/zsh_aliases" && found=true
    copy_if_exists "$HOME/.zprofile" "$shell_dir/zprofile" && found=true
    
    # Fish
    copy_if_exists "$HOME/.config/fish/config.fish" "$shell_dir/config.fish" && found=true
    
    if [[ "$found" == "false" ]]; then
        echo -e "${YELLOW}No shell configuration files found${NC}"
    fi
}

# Function to backup git configs
backup_git_configs() {
    echo -e "${BLUE}📝 Backing up git configurations...${NC}"
    
    local git_dir="$CONFIG_DIR/git"
    local found=false
    
    copy_if_exists "$HOME/.gitconfig" "$git_dir/gitconfig" && found=true
    copy_if_exists "$HOME/.gitignore_global" "$git_dir/gitignore_global" && found=true
    copy_if_exists "$HOME/.gitignore" "$git_dir/gitignore_global" && found=true
    
    if [[ "$found" == "false" ]]; then
        echo -e "${YELLOW}No git configuration files found${NC}"
    fi
}

# Function to backup editor configs
backup_editor_configs() {
    echo -e "${BLUE}✏️  Backing up editor configurations...${NC}"
    
    local editors_dir="$CONFIG_DIR/editors"
    local found=false
    
    # Vim/Neovim
    copy_if_exists "$HOME/.vimrc" "$editors_dir/vimrc" && found=true
    copy_if_exists "$HOME/.config/nvim/init.vim" "$editors_dir/init.vim" && found=true
    copy_dir_if_exists "$HOME/.config/nvim" "$editors_dir/nvim" && found=true
    
    # VS Code
    local vscode_config_dir=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        vscode_config_dir="$HOME/Library/Application Support/Code/User"
    else
        vscode_config_dir="$HOME/.config/Code/User"
    fi
    
    if [[ -d "$vscode_config_dir" ]]; then
        mkdir -p "$editors_dir/vscode"
        copy_if_exists "$vscode_config_dir/settings.json" "$editors_dir/vscode/settings.json" && found=true
        copy_if_exists "$vscode_config_dir/keybindings.json" "$editors_dir/vscode/keybindings.json" && found=true
        copy_if_exists "$vscode_config_dir/snippets" "$editors_dir/vscode/snippets" && found=true
    fi
    
    # Sublime Text
    local sublime_config_dir=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sublime_config_dir="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
    else
        sublime_config_dir="$HOME/.config/sublime-text-3/Packages/User"
    fi
    
    if [[ -d "$sublime_config_dir" ]]; then
        copy_dir_if_exists "$sublime_config_dir" "$editors_dir/sublime" && found=true
    fi
    
    if [[ "$found" == "false" ]]; then
        echo -e "${YELLOW}No editor configuration files found${NC}"
    fi
}

# Function to backup terminal configs
backup_terminal_configs() {
    echo -e "${BLUE}💻 Backing up terminal configurations...${NC}"
    
    local terminal_dir="$CONFIG_DIR/terminal"
    local found=false
    
    # Tmux
    copy_if_exists "$HOME/.tmux.conf" "$terminal_dir/tmux.conf" && found=true
    
    # Alacritty
    copy_if_exists "$HOME/.config/alacritty/alacritty.yml" "$terminal_dir/alacritty.yml" && found=true
    copy_if_exists "$HOME/.alacritty.yml" "$terminal_dir/alacritty.yml" && found=true
    
    # Kitty
    copy_if_exists "$HOME/.config/kitty/kitty.conf" "$terminal_dir/kitty.conf" && found=true
    
    # iTerm2 (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        copy_if_exists "$HOME/Library/Preferences/com.googlecode.iterm2.plist" "$terminal_dir/com.googlecode.iterm2.plist" && found=true
    fi
    
    if [[ "$found" == "false" ]]; then
        echo -e "${YELLOW}No terminal configuration files found${NC}"
    fi
}

# Function to backup desktop configs
backup_desktop_configs() {
    echo -e "${BLUE}🖥️  Backing up desktop configurations...${NC}"
    
    local desktop_dir="$CONFIG_DIR/desktop"
    local found=false
    
    # i3
    copy_if_exists "$HOME/.config/i3/config" "$desktop_dir/i3_config" && found=true
    copy_dir_if_exists "$HOME/.config/i3" "$desktop_dir/i3" && found=true
    
    # Awesome WM
    copy_if_exists "$HOME/.config/awesome/rc.lua" "$desktop_dir/awesome_rc.lua" && found=true
    copy_dir_if_exists "$HOME/.config/awesome" "$desktop_dir/awesome" && found=true
    
    # GNOME (via dconf)
    if command -v dconf &> /dev/null; then
        echo -e "${GREEN}Exporting GNOME settings via dconf...${NC}"
        mkdir -p "$desktop_dir"
        dconf dump / > "$desktop_dir/gnome-settings.dconf" 2>/dev/null && found=true
    fi
    
    if [[ "$found" == "false" ]]; then
        echo -e "${YELLOW}No desktop configuration files found${NC}"
    fi
}

# Function to backup system configs
backup_system_configs() {
    echo -e "${BLUE}⚙️  Backing up system configurations...${NC}"
    
    local system_dir="$CONFIG_DIR/system"
    local found=false
    
    # SSH
    if [[ -d "$HOME/.ssh" ]]; then
        mkdir -p "$system_dir/ssh"
        copy_if_exists "$HOME/.ssh/config" "$system_dir/ssh/config" && found=true
        # Note: We don't copy private keys for security reasons
        echo -e "${YELLOW}Note: SSH keys are not backed up for security reasons${NC}"
    fi
    
    # Fonts
    copy_dir_if_exists "$HOME/.local/share/fonts" "$system_dir/fonts" && found=true
    if [[ "$OSTYPE" == "darwin"* ]]; then
        copy_dir_if_exists "$HOME/Library/Fonts" "$system_dir/fonts_macos" && found=true
    fi
    
    if [[ "$found" == "false" ]]; then
        echo -e "${YELLOW}No system configuration files found${NC}"
    fi
}

# Function to create README files for each category
create_readme_files() {
    echo -e "${BLUE}📄 Creating README files...${NC}"
    
    # Shell README
    if [[ -d "$CONFIG_DIR/shell" ]]; then
        cat > "$CONFIG_DIR/shell/README.md" << 'EOF'
# Shell Configuration

This directory contains shell configuration files.

## Files:
- `bashrc` - Bash shell configuration
- `bash_profile` - Bash login shell configuration
- `bash_aliases` - Bash aliases
- `zshrc` - Zsh shell configuration
- `zsh_aliases` - Zsh aliases
- `config.fish` - Fish shell configuration

## Installation:
Run `../scripts/install.sh` from the repository root to install these configurations.
EOF
    fi
    
    # Git README
    if [[ -d "$CONFIG_DIR/git" ]]; then
        cat > "$CONFIG_DIR/git/README.md" << 'EOF'
# Git Configuration

This directory contains Git configuration files.

## Files:
- `gitconfig` - Main Git configuration
- `gitignore_global` - Global gitignore rules

## Installation:
Run `../scripts/install.sh` from the repository root to install these configurations.
EOF
    fi
}

# Main backup function
main() {
    echo -e "${GREEN}Starting dotfiles backup...${NC}"
    
    # Create config directory structure
    mkdir -p "$CONFIG_DIR"/{shell,git,editors,terminal,desktop,system}
    
    backup_shell_configs
    backup_git_configs
    backup_editor_configs
    backup_terminal_configs
    backup_desktop_configs
    backup_system_configs
    create_readme_files
    
    echo -e "${GREEN}✅ Dotfiles backup completed!${NC}"
    echo -e "${YELLOW}Your dotfiles have been organized in the config/ directory.${NC}"
    echo -e "${YELLOW}Review the files and commit them to your repository when ready.${NC}"
    echo -e "${BLUE}Use 'scripts/install.sh' to deploy these dotfiles on a new system.${NC}"
}

# Check if we're running this script directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi