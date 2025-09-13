#!/bin/bash

# Dotfiles Installation Script
# This script will create symlinks for all dotfiles in your home directory

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

echo -e "${BLUE}🚀 Setting up dotfiles...${NC}"
echo -e "${BLUE}Dotfiles directory: $DOTFILES_DIR${NC}"

# Function to create symlink
create_symlink() {
    local source_file="$1"
    local target_file="$2"
    
    # Create target directory if it doesn't exist
    local target_dir="$(dirname "$target_file")"
    if [[ ! -d "$target_dir" ]]; then
        echo -e "${YELLOW}Creating directory: $target_dir${NC}"
        mkdir -p "$target_dir"
    fi
    
    # Backup existing file if it exists and is not a symlink
    if [[ -e "$target_file" ]] && [[ ! -L "$target_file" ]]; then
        echo -e "${YELLOW}Backing up existing file: $target_file${NC}"
        mv "$target_file" "${target_file}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Remove existing symlink
    if [[ -L "$target_file" ]]; then
        rm "$target_file"
    fi
    
    # Create new symlink
    echo -e "${GREEN}Creating symlink: $target_file -> $source_file${NC}"
    ln -s "$source_file" "$target_file"
}

# Function to install shell configs
install_shell_configs() {
    echo -e "${BLUE}📦 Installing shell configurations...${NC}"
    
    local shell_dir="$CONFIG_DIR/shell"
    if [[ -d "$shell_dir" ]]; then
        # Bash
        [[ -f "$shell_dir/bashrc" ]] && create_symlink "$shell_dir/bashrc" "$HOME/.bashrc" || true
        [[ -f "$shell_dir/bash_profile" ]] && create_symlink "$shell_dir/bash_profile" "$HOME/.bash_profile" || true
        [[ -f "$shell_dir/bash_aliases" ]] && create_symlink "$shell_dir/bash_aliases" "$HOME/.bash_aliases" || true
        
        # Zsh
        [[ -f "$shell_dir/zshrc" ]] && create_symlink "$shell_dir/zshrc" "$HOME/.zshrc" || true
        [[ -f "$shell_dir/zsh_aliases" ]] && create_symlink "$shell_dir/zsh_aliases" "$HOME/.zsh_aliases" || true
        
        # Fish
        [[ -f "$shell_dir/config.fish" ]] && create_symlink "$shell_dir/config.fish" "$HOME/.config/fish/config.fish" || true
    fi
    return 0
}

# Function to install git configs
install_git_configs() {
    echo -e "${BLUE}📦 Installing git configurations...${NC}"
    
    local git_dir="$CONFIG_DIR/git"
    if [[ -d "$git_dir" ]]; then
        [[ -f "$git_dir/gitconfig" ]] && create_symlink "$git_dir/gitconfig" "$HOME/.gitconfig" || true
        [[ -f "$git_dir/gitignore_global" ]] && create_symlink "$git_dir/gitignore_global" "$HOME/.gitignore_global" || true
    fi
    return 0
}

# Function to install editor configs
install_editor_configs() {
    echo -e "${BLUE}📦 Installing editor configurations...${NC}"
    
    local editors_dir="$CONFIG_DIR/editors"
    if [[ -d "$editors_dir" ]]; then
        # Vim/Neovim
        [[ -f "$editors_dir/vimrc" ]] && create_symlink "$editors_dir/vimrc" "$HOME/.vimrc" || true
        [[ -f "$editors_dir/init.vim" ]] && create_symlink "$editors_dir/init.vim" "$HOME/.config/nvim/init.vim" || true
        
        # VS Code
        if [[ -d "$editors_dir/vscode" ]]; then
            local vscode_config_dir=""
            if [[ "$OSTYPE" == "darwin"* ]]; then
                vscode_config_dir="$HOME/Library/Application Support/Code/User"
            else
                vscode_config_dir="$HOME/.config/Code/User"
            fi
            
            [[ -f "$editors_dir/vscode/settings.json" ]] && create_symlink "$editors_dir/vscode/settings.json" "$vscode_config_dir/settings.json" || true
            [[ -f "$editors_dir/vscode/keybindings.json" ]] && create_symlink "$editors_dir/vscode/keybindings.json" "$vscode_config_dir/keybindings.json" || true
        fi
    fi
    return 0
}

# Function to install terminal configs
install_terminal_configs() {
    echo -e "${BLUE}📦 Installing terminal configurations...${NC}"
    
    local terminal_dir="$CONFIG_DIR/terminal"
    if [[ -d "$terminal_dir" ]]; then
        # Tmux
        [[ -f "$terminal_dir/tmux.conf" ]] && create_symlink "$terminal_dir/tmux.conf" "$HOME/.tmux.conf" || true
        
        # Alacritty
        [[ -f "$terminal_dir/alacritty.yml" ]] && create_symlink "$terminal_dir/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml" || true
        
        # Kitty
        [[ -f "$terminal_dir/kitty.conf" ]] && create_symlink "$terminal_dir/kitty.conf" "$HOME/.config/kitty/kitty.conf" || true
    fi
    return 0
}

# Function to install system configs
install_system_configs() {
    echo -e "${BLUE}📦 Installing system configurations...${NC}"
    
    local system_dir="$CONFIG_DIR/system"
    if [[ -d "$system_dir" ]]; then
        # SSH
        if [[ -d "$system_dir/ssh" ]]; then
            [[ -f "$system_dir/ssh/config" ]] && create_symlink "$system_dir/ssh/config" "$HOME/.ssh/config" || true
        fi
    fi
    return 0
}

# Main installation function
main() {
    echo -e "${GREEN}Starting dotfiles installation...${NC}"
    
    install_shell_configs
    install_git_configs
    install_editor_configs
    install_terminal_configs
    install_system_configs
    
    echo -e "${GREEN}✅ Dotfiles installation completed!${NC}"
    echo -e "${YELLOW}Note: You may need to restart your shell or source your configuration files.${NC}"
    echo -e "${YELLOW}Example: source ~/.bashrc or source ~/.zshrc${NC}"
}

# Check if we're running this script directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi