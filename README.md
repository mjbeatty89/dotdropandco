# 🏠 DotDropAndCo - Personal Dotfiles

A clean, organized repository for managing personal dotfiles and system configurations. Easily back up your current setup and deploy it to new systems with automated scripts.

## 🚀 Quick Start

### Using Make (Recommended)
```bash
# Clone this repository
git clone https://github.com/mjbeatty89/dotdropandco.git
cd dotdropandco

# See all available commands
make

# Collect your current dotfiles
make backup

# Install dotfiles on a new system
make install
```

### Using Scripts Directly
```bash
# Backing Up Your Current System
./scripts/backup.sh

# Setting Up a New System  
./scripts/install.sh
```

### Traditional Method
```bash
# Clone this repository
git clone https://github.com/mjbeatty89/dotdropandco.git
cd dotdropandco

# Collect your current dotfiles
./scripts/backup.sh

# Review and commit your configs
git add config/
git commit -m "Add my dotfiles"
git push
```

## 📁 Directory Structure

```
dotdropandco/
├── config/                 # Your configuration files
│   ├── shell/             # Shell configs (bash, zsh, fish)
│   ├── git/               # Git configuration
│   ├── editors/           # Editor configs (vim, vscode, etc.)
│   ├── terminal/          # Terminal configs (tmux, alacritty)
│   ├── desktop/           # Desktop environment configs
│   └── system/            # System-level configs (ssh, fonts)
├── scripts/               # Automation scripts
│   ├── backup.sh          # Collect dotfiles from current system
│   └── install.sh         # Deploy dotfiles to new system
├── docs/                  # Documentation
├── backup/                # Backup location for replaced files
└── README.md              # This file
```

## 🛠️ Features

- **🔄 Automated Backup**: Collect all your dotfiles with one command
- **⚡ Easy Installation**: Deploy to new systems instantly
- **🗂️ Organized Structure**: Clean categorization of config types
- **🔒 Safe Installation**: Backs up existing files before replacing
- **🌈 Colored Output**: Beautiful terminal feedback
- **📝 Documentation**: Self-documenting with README files
- **🔍 Smart Detection**: Automatically finds configs across different systems

## 📋 Supported Configurations

### Shell
- Bash (`.bashrc`, `.bash_profile`, `.bash_aliases`)
- Zsh (`.zshrc`, `.zsh_aliases`, `.zprofile`)
- Fish (`config.fish`)

### Version Control
- Git (`.gitconfig`, `.gitignore_global`)

### Editors
- Vim/Neovim (`.vimrc`, `init.vim`)
- VS Code (`settings.json`, `keybindings.json`)
- Sublime Text (user preferences)

### Terminal
- Tmux (`.tmux.conf`)
- Alacritty (`alacritty.yml`)
- Kitty (`kitty.conf`)
- iTerm2 (macOS preferences)

### Desktop Environment
- i3 Window Manager
- Awesome WM
- GNOME (via dconf export)

### System
- SSH configuration
- Custom fonts
- System-level preferences

## 🔧 Advanced Usage

### Using Make Commands
```bash
make help      # Show available commands
make backup    # Backup current dotfiles
make install   # Install dotfiles
make status    # Show repository status
make clean     # Clean up backup files
```

### Custom Installation
You can run specific parts of the installation:

```bash
# Source the install script to use individual functions
source scripts/install.sh

# Install only shell configs
install_shell_configs

# Install only git configs
install_git_configs
```

### Manual File Organization
Place your dotfiles in the appropriate directories:

```bash
# Shell configurations
config/shell/bashrc
config/shell/zshrc

# Git configurations  
config/git/gitconfig
config/git/gitignore_global

# And so on...
```

Then run `./scripts/install.sh` to create symlinks.

### Backup Management
The install script automatically backs up existing files:
- Backups are stored with timestamp: `.filename.backup.20241201_143022`
- Only non-symlinked files are backed up
- Existing symlinks are replaced

## 🎨 Customization

### Adding New Configurations
1. Add your config files to the appropriate `config/` subdirectory
2. Update the installation script if needed for new file types
3. Document your additions in the relevant README files

### Cross-Platform Support
The scripts automatically detect:
- macOS vs Linux paths
- Different application installation locations
- Platform-specific configurations

## 🔐 Security Notes

- SSH private keys are **never** backed up for security
- Only the SSH config file is included
- Sensitive files can be excluded via `.gitignore`
- Always review files before committing

## 🚨 Troubleshooting

### Common Issues

**Permission Denied**
```bash
chmod +x scripts/*.sh
```

**Files Not Found**
- Check that your dotfiles exist in the expected locations
- Some configurations may be in different paths on your system

**Symlink Conflicts**
- The install script backs up existing files automatically
- Check the `backup/` directory for replaced files

### Getting Help

1. Check the colored output for specific error messages
2. Review the generated backup files
3. Ensure you have write permissions to your home directory

## 📚 Best Practices

1. **Regular Backups**: Run `backup.sh` after major configuration changes
2. **Version Control**: Commit and push changes regularly
3. **Test Installations**: Try installation on a test system first
4. **Document Changes**: Update README files when adding new configs
5. **Review Before Commit**: Always check what files are being added

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:
- Fork for your own dotfiles management
- Suggest improvements via issues
- Share your own organizational strategies

## 📄 License

Personal dotfiles repository - use as inspiration for your own setup!

---

**Happy configuring! 🎉**

Remember: A well-organized dotfiles repository is the foundation of a productive development environment.
