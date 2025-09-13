#!/bin/bash

# organize.sh - Automatically organize dotfiles into logical directory structure
# Usage: ./organize.sh [source_directory]

set -euo pipefail

# Default source directory is current directory
SOURCE_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

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

# File patterns and their target directories
declare -A FILE_PATTERNS=(
    # Shell configurations
    [".bashrc"]="shell"
    [".bash_profile"]="shell"
    [".bash_aliases"]="shell"
    [".zshrc"]="shell"
    [".zprofile"]="shell"
    [".zshenv"]="shell"
    [".fish_config"]="shell"
    ["config.fish"]="shell"
    [".profile"]="shell"
    
    # Editor configurations
    [".vimrc"]="editor"
    [".vim/"]="editor"
    ["init.vim"]="editor"
    ["init.lua"]="editor"
    [".nvim/"]="editor"
    [".emacs"]="editor"
    [".emacs.d/"]="editor"
    ["settings.json"]="editor"
    [".vscode/"]="editor"
    
    # Terminal configurations
    ["alacritty.yml"]="terminal"
    ["alacritty.toml"]="terminal"
    [".hyper.js"]="terminal"
    ["kitty.conf"]="terminal"
    [".kitty/"]="terminal"
    
    # Git configurations
    [".gitconfig"]="git"
    [".gitignore_global"]="git"
    [".gitignore"]="git"
    [".gitmessage"]="git"
    
    # Applications
    [".tmux.conf"]="applications"
    [".tmux/"]="applications"
    [".npmrc"]="applications"
    [".yarnrc"]="applications"
    [".prettierrc"]="applications"
    [".eslintrc"]="applications"
    [".config/"]="applications"
    [".aws/"]="applications"
    [".ssh/"]="applications"
)

# Function to determine target directory for a file
get_target_dir() {
    local file="$1"
    local basename_file="$(basename "$file")"
    
    # Check exact matches first
    for pattern in "${!FILE_PATTERNS[@]}"; do
        if [[ "$basename_file" == "$pattern" ]] || [[ "$file" == *"$pattern"* ]]; then
            echo "${FILE_PATTERNS[$pattern]}"
            return 0
        fi
    done
    
    # Default fallback for hidden files starting with dot
    if [[ "$basename_file" =~ ^\. ]]; then
        echo "applications"
        return 0
    fi
    
    # Return empty string if no match
    echo ""
}

# Function to organize a single file
organize_file() {
    local source_file="$1"
    local target_dir_name="$2"
    local target_dir="$BASE_DIR/$target_dir_name"
    
    # Create target directory if it doesn't exist
    if [[ ! -d "$target_dir" ]]; then
        log_info "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi
    
    local filename="$(basename "$source_file")"
    local target_file="$target_dir/$filename"
    
    # Check if target file already exists
    if [[ -e "$target_file" ]]; then
        log_warning "Target file already exists: $target_file"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Skipping $source_file"
            return 0
        fi
    fi
    
    # Move the file
    if mv "$source_file" "$target_file"; then
        log_success "Moved $source_file → $target_file"
    else
        log_error "Failed to move $source_file"
        return 1
    fi
}

# Main organization function
organize_files() {
    local source_dir="$1"
    
    log_info "Organizing files from: $source_dir"
    log_info "Base directory: $BASE_DIR"
    
    # Find all files (not directories) in source directory
    while IFS= read -r -d '' file; do
        # Skip the organize script itself and other scripts
        if [[ "$file" == *"/organize.sh" ]] || [[ "$file" == *"/scripts/"* ]]; then
            continue
        fi
        
        # Skip hidden git files and directories
        if [[ "$file" == *"/.git/"* ]] || [[ "$file" == *"/.git" ]]; then
            continue
        fi
        
        # Skip files that should stay in root directory
        if [[ "$file" == *"/.gitignore" ]] || [[ "$file" == *"/README.md" ]] || [[ "$file" == *"/LICENSE" ]]; then
            continue
        fi
        
        # Skip files already in organized directories
        if [[ "$file" == *"/shell/"* ]] || [[ "$file" == *"/editor/"* ]] || \
           [[ "$file" == *"/terminal/"* ]] || [[ "$file" == *"/git/"* ]] || \
           [[ "$file" == *"/applications/"* ]]; then
            continue
        fi
        
        local target_dir=$(get_target_dir "$file")
        
        if [[ -n "$target_dir" ]]; then
            log_info "Processing: $file"
            organize_file "$file" "$target_dir"
        else
            log_warning "No target directory found for: $file"
        fi
        
    done < <(find "$source_dir" -type f -print0)
}

# Help function
show_help() {
    cat << EOF
organize.sh - Automatically organize dotfiles into logical directory structure

USAGE:
    ./organize.sh [SOURCE_DIRECTORY]

DESCRIPTION:
    This script automatically moves dotfiles into a logical directory structure:
    
    shell/        - Shell configuration files (.bashrc, .zshrc, etc.)
    editor/       - Editor configurations (.vimrc, settings.json, etc.)
    terminal/     - Terminal emulator configs (alacritty.yml, etc.)
    git/          - Git configuration files (.gitconfig, etc.)
    applications/ - Other application configs (.tmux.conf, etc.)
    scripts/      - Utility scripts

ARGUMENTS:
    SOURCE_DIRECTORY    Directory to organize files from (default: current directory)

OPTIONS:
    -h, --help         Show this help message

EXAMPLES:
    ./organize.sh                    # Organize files in current directory
    ./organize.sh ~/Downloads        # Organize files from Downloads folder
    ./organize.sh /path/to/dotfiles  # Organize files from specific path

EOF
}

# Main script execution
main() {
    # Parse command line arguments
    case "${1:-}" in
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            if [[ $# -gt 1 ]]; then
                log_error "Too many arguments. Use -h for help."
                exit 1
            fi
            ;;
    esac
    
    local source_dir="${1:-.}"
    
    # Validate source directory
    if [[ ! -d "$source_dir" ]]; then
        log_error "Source directory does not exist: $source_dir"
        exit 1
    fi
    
    # Convert to absolute path
    source_dir="$(cd "$source_dir" && pwd)"
    
    log_info "Starting dotfiles organization..."
    organize_files "$source_dir"
    log_success "Organization complete!"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi