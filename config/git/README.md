# Git Configuration

This directory contains Git configuration files.

## Quick Setup

The installation script will automatically symlink these files:

- `gitconfig` → `~/.gitconfig`
- `gitignore_global` → `~/.gitignore_global`

## Example Global Git Configuration

Create a `gitconfig` file with your preferences:

```ini
[user]
    name = Your Name
    email = your.email@example.com

[core]
    editor = vim
    excludesfile = ~/.gitignore_global
    autocrlf = input

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !gitk

[color]
    ui = auto

[push]
    default = simple

[pull]
    rebase = false
```

## Example Global Gitignore

Create a `gitignore_global` file:

```
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Editor files
*.swp
*.swo
*~
.vscode/
.idea/

# Language specific
node_modules/
*.pyc
__pycache__/
```

## Security Note

Never commit sensitive information like:
- Personal access tokens
- SSH keys
- Passwords or API keys

Keep these in separate, untracked files.