# Shell Configuration

This directory contains shell configuration files for various shells.

## Quick Setup

The installation script will automatically symlink these files to your home directory:

- `bashrc` → `~/.bashrc`
- `bash_profile` → `~/.bash_profile` 
- `bash_aliases` → `~/.bash_aliases`
- `zshrc` → `~/.zshrc`
- `zsh_aliases` → `~/.zsh_aliases`
- `config.fish` → `~/.config/fish/config.fish`

## Usage

1. Place your shell configuration files in this directory
2. Run `../../scripts/install.sh` from the repository root
3. Restart your shell or source the new configs

## Example Files

You can create files like:

```bash
# Example .bashrc additions
export EDITOR=vim
export PATH=$PATH:$HOME/.local/bin

# Useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
```

## Tips

- Keep sensitive information (API keys, passwords) in separate files that are not tracked
- Use `$HOME/.local/` for user-specific installations
- Consider using tools like `oh-my-zsh` or `starship` for enhanced shell experiences