#!/usr/bin/env bash
set -euo pipefail

PARAFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[DRY RUN] No changes will be made."
  echo ""
fi

echo "Parafiles installer"
echo "==================="
echo "Source: $PARAFILES_DIR"
echo ""

if [ "$DRY_RUN" = false ]; then
  mkdir -p "$BACKUP_DIR"
fi

# ── Dependencies ──────────────────────────────────────────────

echo "Checking dependencies..."

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "  [install] Homebrew not found, installing..."
  if [ "$DRY_RUN" = false ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "  [ok] Homebrew"
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "  [install] Oh My Zsh not found, installing..."
  if [ "$DRY_RUN" = false ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
else
  echo "  [ok] Oh My Zsh"
fi

# Oh My Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "  [install] zsh-autosuggestions..."
  if [ "$DRY_RUN" = false ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  fi
else
  echo "  [ok] zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "  [install] zsh-syntax-highlighting..."
  if [ "$DRY_RUN" = false ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  fi
else
  echo "  [ok] zsh-syntax-highlighting"
fi

# asdf
if ! command -v asdf &>/dev/null && [ ! -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
  echo "  [install] asdf via Homebrew..."
  if [ "$DRY_RUN" = false ]; then
    brew install asdf
  fi
else
  echo "  [ok] asdf"
fi

# Optional tools (just warn)
MISSING_OPTIONAL=()
command -v kubectl &>/dev/null || MISSING_OPTIONAL+=("kubectl")
command -v tofu &>/dev/null || MISSING_OPTIONAL+=("opentofu")
command -v nvim &>/dev/null || MISSING_OPTIONAL+=("neovim")
command -v pnpm &>/dev/null || MISSING_OPTIONAL+=("pnpm")

if [ ${#MISSING_OPTIONAL[@]} -gt 0 ]; then
  echo ""
  echo "  Optional tools not found (install when needed):"
  echo "    brew install ${MISSING_OPTIONAL[*]}"
fi

echo ""

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
    if [ "$DRY_RUN" = false ]; then
      mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
    fi
  elif [ -d "$dest" ]; then
    echo "  [backup] $dest (directory)"
    if [ "$DRY_RUN" = false ]; then
      mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
    fi
  elif [ -f "$dest" ]; then
    echo "  [backup] $dest"
    if [ "$DRY_RUN" = false ]; then
      mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
    fi
  fi

  if [ "$DRY_RUN" = false ]; then
    ln -s "$src" "$dest"
  fi
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
if [ "$DRY_RUN" = false ]; then
  mkdir -p "$HOME/.config"
fi
link_file "$PARAFILES_DIR/nvim" "$HOME/.config/nvim"

echo ""

# Secrets
if [ ! -f "$HOME/.secrets" ]; then
  echo "Creating ~/.secrets from template..."
  if [ "$DRY_RUN" = false ]; then
    cp "$PARAFILES_DIR/secrets.example" "$HOME/.secrets"
    chmod 600 "$HOME/.secrets"
  fi
  echo "  [created] ~/.secrets - EDIT THIS FILE with your actual secrets"
else
  echo "  [skip] ~/.secrets already exists"
fi

echo ""

# SSH config
if [ ! -f "$HOME/.ssh/config" ]; then
  echo "Creating ~/.ssh/config from template..."
  if [ "$DRY_RUN" = false ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    cp "$PARAFILES_DIR/ssh/config.template" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
  fi
  echo "  [created] ~/.ssh/config from template"
else
  echo "  [skip] ~/.ssh/config already exists"
fi

echo ""

# iTerm2 preferences
if [ -d "/Applications/iTerm.app" ]; then
  echo "Configuring iTerm2 to load preferences from parafiles..."
  if [ "$DRY_RUN" = false ]; then
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$PARAFILES_DIR/iterm2"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  fi
  echo "  [done] iTerm2 will load prefs from $PARAFILES_DIR/iterm2"
else
  echo "  [skip] iTerm2 not installed"
fi

echo ""

# Check backup dir
if [ "$DRY_RUN" = false ]; then
  if [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    rmdir "$BACKUP_DIR"
  else
    echo "Backups saved to: $BACKUP_DIR"
  fi
fi

echo ""
echo "Done! Restart your shell or run: source ~/.zshrc"
