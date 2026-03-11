# parafiles

My personal dotfiles and configs.

## Quick Start

```bash
git clone https://github.com/leandroh/parafiles.git ~/Developer/parafiles
cd ~/Developer/parafiles

# Preview what will happen
./install.sh --dry-run

# Run for real
./install.sh
```

Edit `~/.secrets` with your actual API keys and tokens.

## What's Included

| Directory | Contents |
|-----------|----------|
| `zsh/` | `.zshrc`, `.zprofile`, `.aliases` |
| `git/` | `.gitconfig`, `.gitignore_global` |
| `nvim/` | Neovim config |
| `iterm2/` | iTerm2 preferences |
| `ssh/` | SSH config template |

## Secrets

Secrets (API keys, tokens, credentials) are kept in `~/.secrets` which is **never committed**.

`secrets.example` shows the expected variables. Copy it to `~/.secrets`, fill in your values, and `.zshrc` sources it automatically.

## How It Works

`install.sh` creates symlinks from your home directory to this repo:

```
~/.zshrc          → zsh/.zshrc
~/.zprofile       → zsh/.zprofile
~/.aliases        → zsh/.aliases
~/.gitconfig      → git/.gitconfig
~/.gitignore_global → git/.gitignore_global
~/.config/nvim    → nvim/
```

Existing files are backed up to `~/.dotfiles_backup/` before linking.

## Tools

| Tool | Manager |
|------|---------|
| Node, Ruby, Erlang, Elixir | asdf |
| Packages | pnpm, Homebrew |
| Editor | VS Code, Neovim |
| Terminal | iTerm2 |
| Infra | Terraform/OpenTofu, kubectl |
