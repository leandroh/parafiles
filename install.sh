#!/usr/bin/env bash
set -euo pipefail

PARAFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

echo "Parafiles installer"
echo "==================="
echo "Source: $PARAFILES_DIR"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

link_file() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    local current_target
    current_target=$(readlink "$dest")
    if [ "$current_target" = "$src" ]; then
      echo "  [skip] $dest -> already linked"
      return
    fi
    echo "  [backup] $dest (symlink to $current_target)"
    mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
  elif [ -f "$dest" ]; then
    echo "  [backup] $dest"
    mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
  fi

  ln -s "$src" "$dest"
  echo "  [link] $dest -> $src"
}

echo "Linking dotfiles..."

# Zsh
link_file "$PARAFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$PARAFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
link_file "$PARAFILES_DIR/zsh/.aliases" "$HOME/.aliases"

# Git
link_file "$PARAFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$PARAFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# Nvim
mkdir -p "$HOME/.config"
link_file "$PARAFILES_DIR/nvim" "$HOME/.config/nvim"

echo ""

# Secrets
if [ ! -f "$HOME/.secrets" ]; then
  echo "Creating ~/.secrets from template..."
  cp "$PARAFILES_DIR/secrets.example" "$HOME/.secrets"
  chmod 600 "$HOME/.secrets"
  echo "  [created] ~/.secrets - EDIT THIS FILE with your actual secrets"
else
  echo "  [skip] ~/.secrets already exists"
fi

echo ""

# SSH config
if [ ! -f "$HOME/.ssh/config" ]; then
  mkdir -p "$HOME/.ssh"
  cp "$PARAFILES_DIR/ssh/config.template" "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
  echo "  [created] ~/.ssh/config from template"
else
  echo "  [skip] ~/.ssh/config already exists"
fi

echo ""

# iTerm2 preferences
if [ -d "/Applications/iTerm.app" ]; then
  echo "Configuring iTerm2 to load preferences from parafiles..."
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$PARAFILES_DIR/iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  echo "  [done] iTerm2 will load prefs from $PARAFILES_DIR/iterm2"
else
  echo "  [skip] iTerm2 not installed"
fi

echo ""

# Check backup dir
if [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
  rmdir "$BACKUP_DIR"
else
  echo "Backups saved to: $BACKUP_DIR"
fi

echo ""
echo "Done! Restart your shell or run: source ~/.zshrc"
