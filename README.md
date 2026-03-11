# parafiles
My personal dotfiles and configs — everything Pará needs to feel at home in the terminal. 🧉

## Quick Start

```bash
git clone https://github.com/leandroh/parafiles.git ~/Developer/parafiles
cd ~/Developer/parafiles
./install.sh
```

Edit `~/.secrets` with your actual API keys and tokens.

## What's Included

| Directory | Contents |
|-----------|----------|
| `zsh/` | `.zshrc`, `.zprofile`, `.aliases` |
| `git/` | `.gitconfig`, `.gitignore_global` |
| `nvim/` | Neovim configuration |
| `iterm2/` | iTerm2 preferences |
| `ssh/` | SSH config template |

## Secrets

Secrets (API keys, tokens, credentials) are kept in `~/.secrets` which is **never committed**.

- `secrets.example` shows all required environment variables
- Copy it to `~/.secrets` and fill in your values
- `.zshrc` sources `~/.secrets` automatically

## How It Works

`install.sh` creates symlinks from your home directory to this repo:

- `~/.zshrc` -> `parafiles/zsh/.zshrc`
- `~/.zprofile` -> `parafiles/zsh/.zprofile`
- `~/.aliases` -> `parafiles/zsh/.aliases`
- `~/.gitconfig` -> `parafiles/git/.gitconfig`
- `~/.gitignore_global` -> `parafiles/git/.gitignore_global`
- `~/.config/nvim` -> `parafiles/nvim`

Existing files are backed up to `~/.dotfiles_backup/` before linking.
