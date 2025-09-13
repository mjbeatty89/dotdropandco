#!/bin/bash

# install.sh - Install organized dotfiles to their proper locations
# Usage: ./install.sh [--dry-run]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
DRY_RUN=false

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_dry_run() {
    echo -e "${YELLOW}[DRY-RUN]${NC} $1"
}

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_dry_run "Would link: $source → $target"
        return 0
    fi
    
    # Create target directory if it doesn't exist
    local target_dir="$(dirname "$target")"
    if [[ ! -d "$target_dir" ]]; then
        log_info "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi
    
    # Remove existing file/link if it exists
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        log_warning "Removing existing: $target"
        rm -f "$target"
    fi
    
    # Create symlink
    if ln -sf "$source" "$target"; then
        log_success "Linked: $source → $target"
    else
        log_error "Failed to link: $source → $target"
        return 1
    fi
}

# Function to install shell configurations
install_shell_configs() {
    log_info "Installing shell configurations..."
    
    local shell_dir="$BASE_DIR/shell"
    
    # Install common shell configs
    if [[ -f "$shell_dir/.bashrc" ]]; then
        create_symlink "$shell_dir/.bashrc" "$HOME/.bashrc"
    fi
    if [[ -f "$shell_dir/.bash_profile" ]]; then
        create_symlink "$shell_dir/.bash_profile" "$HOME/.bash_profile"
    fi
    if [[ -f "$shell_dir/.zshrc" ]]; then
        create_symlink "$shell_dir/.zshrc" "$HOME/.zshrc"
    fi
    if [[ -f "$shell_dir/.profile" ]]; then
        create_symlink "$shell_dir/.profile" "$HOME/.profile"
    fi
}

# Function to install editor configurations
install_editor_configs() {
    log_info "Installing editor configurations..."
    
    local editor_dir="$BASE_DIR/editor"
    
    # Install editor configs
    if [[ -f "$editor_dir/.vimrc" ]]; then
        create_symlink "$editor_dir/.vimrc" "$HOME/.vimrc"
    fi
    if [[ -f "$editor_dir/init.vim" ]]; then
        create_symlink "$editor_dir/init.vim" "$HOME/.config/nvim/init.vim"
    fi
    if [[ -f "$editor_dir/settings.json" ]]; then
        create_symlink "$editor_dir/settings.json" "$HOME/.config/Code/User/settings.json"
    fi
}

# Function to install terminal configurations
install_terminal_configs() {
    log_info "Installing terminal configurations..."
    
    local terminal_dir="$BASE_DIR/terminal"
    
    # Install terminal configs
    if [[ -f "$terminal_dir/alacritty.yml" ]]; then
        create_symlink "$terminal_dir/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
    fi
    if [[ -f "$terminal_dir/.hyper.js" ]]; then
        create_symlink "$terminal_dir/.hyper.js" "$HOME/.hyper.js"
    fi
}

# Function to install git configurations
install_git_configs() {
    log_info "Installing git configurations..."
    
    local git_dir="$BASE_DIR/git"
    
    # Install git configs
    if [[ -f "$git_dir/.gitconfig" ]]; then
        create_symlink "$git_dir/.gitconfig" "$HOME/.gitconfig"
    fi
    if [[ -f "$git_dir/.gitignore_global" ]]; then
        create_symlink "$git_dir/.gitignore_global" "$HOME/.gitignore_global"
    fi
}

# Function to install application configurations
install_app_configs() {
    log_info "Installing application configurations..."
    
    local apps_dir="$BASE_DIR/applications"
    
    # Install application configs
    if [[ -f "$apps_dir/.tmux.conf" ]]; then
        create_symlink "$apps_dir/.tmux.conf" "$HOME/.tmux.conf"
    fi
    if [[ -f "$apps_dir/.npmrc" ]]; then
        create_symlink "$apps_dir/.npmrc" "$HOME/.npmrc"
    fi
}

# Help function
show_help() {
    cat << EOF
install.sh - Install organized dotfiles to their proper locations

USAGE:
    ./install.sh [OPTIONS]

DESCRIPTION:
    This script creates symlinks from the organized dotfiles to their standard
    locations in the home directory.

OPTIONS:
    --dry-run          Show what would be done without making changes
    -h, --help         Show this help message

EXAMPLES:
    ./install.sh                # Install all dotfiles
    ./install.sh --dry-run      # Preview what would be installed

EOF
}

# Main installation function
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "DRY RUN MODE - No changes will be made"
    fi
    
    log_info "Starting dotfiles installation from: $BASE_DIR"
    
    # Install configurations by category
    install_shell_configs
    install_editor_configs
    install_terminal_configs
    install_git_configs
    install_app_configs
    
    log_success "Dotfiles installation complete!"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "This was a dry run. Run without --dry-run to actually install."
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi