# dotdropandco

A well-organized dotfiles repository with automatic file organization capabilities.

## Directory Structure

This repository maintains a logical folder structure for different types of configuration files:

```
dotdropandco/
├── shell/          # Shell configuration files
├── editor/         # Editor configurations  
├── terminal/       # Terminal emulator configs
├── git/            # Git configuration files
├── applications/   # Other application configs
├── scripts/        # Utility and automation scripts
└── README.md
```

### Directory Descriptions

- **`shell/`** - Shell configuration files like `.bashrc`, `.zshrc`, `.fish_config`, `.profile`, etc.
- **`editor/`** - Editor configurations including `.vimrc`, `init.vim`, VSCode `settings.json`, etc.
- **`terminal/`** - Terminal emulator configurations like `alacritty.yml`, `.hyper.js`, `kitty.conf`, etc.
- **`git/`** - Git-related configurations including `.gitconfig`, `.gitignore_global`, etc.
- **`applications/`** - Configuration files for various applications like `.tmux.conf`, `.npmrc`, `.aws/`, etc.
- **`scripts/`** - Utility scripts for managing and organizing the dotfiles

## Automatic Organization

### Quick Start

To automatically organize dotfiles that you've dropped into this repository:

```bash
# Organize files in the current directory
./scripts/organize.sh

# Organize files from a specific directory
./scripts/organize.sh ~/Downloads

# Get help
./scripts/organize.sh --help
```

### How It Works

The `organize.sh` script automatically detects file types and moves them to the appropriate directories based on:

1. **File naming patterns** - Recognizes common dotfile names like `.bashrc`, `.vimrc`, etc.
2. **File extensions** - Handles files like `alacritty.yml`, `settings.json`, etc.
3. **Directory patterns** - Organizes configuration directories like `.config/`, `.vim/`, etc.

### Supported File Types

| File Pattern | Target Directory | Examples |
|--------------|------------------|----------|
| Shell configs | `shell/` | `.bashrc`, `.zshrc`, `.fish_config` |
| Editor configs | `editor/` | `.vimrc`, `init.vim`, `settings.json` |
| Terminal configs | `terminal/` | `alacritty.yml`, `.hyper.js`, `kitty.conf` |
| Git configs | `git/` | `.gitconfig`, `.gitignore_global` |
| App configs | `applications/` | `.tmux.conf`, `.npmrc`, `.aws/` |

## Usage Examples

### Adding New Dotfiles

1. **Drop files anywhere** in the repository
2. **Run the organizer**: `./scripts/organize.sh`
3. **Files are automatically sorted** into the correct directories

### Manual Organization

You can also manually place files in the appropriate directories following the structure above.

### Deploying Dotfiles

```bash
# Link shell configurations
ln -sf $(pwd)/shell/.bashrc ~/.bashrc
ln -sf $(pwd)/shell/.zshrc ~/.zshrc

# Link editor configurations  
ln -sf $(pwd)/editor/.vimrc ~/.vimrc

# Link application configurations
ln -sf $(pwd)/applications/.tmux.conf ~/.tmux.conf
```

## Features

- **Automatic file organization** based on common dotfile patterns
- **Clear directory structure** for easy navigation and maintenance
- **Safe operations** with confirmation prompts for overwrites
- **Colored output** for better visibility during organization
- **Extensible pattern matching** for custom file types

## Contributing

To add support for new file types, edit the `FILE_PATTERNS` array in `scripts/organize.sh`:

```bash
declare -A FILE_PATTERNS=(
    ["your_config_file"]="target_directory"
    # ... existing patterns
)
```

## Best Practices

1. **Backup first** - Always backup your existing dotfiles before organizing
2. **Test the organizer** - Run with `--help` to understand the behavior  
3. **Review changes** - Check where files were moved after organization
4. **Use symlinks** - Link organized files to their target locations rather than copying

---

Keep your dotfiles organized and your system configuration clean! 🎯
