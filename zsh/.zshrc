# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  bundler
  dotenv
  macos
  rake
  rbenv
  ruby
  wd
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Secrets (API keys, tokens, etc.)
[ -f ~/.secrets ] && source ~/.secrets

# Tool setup
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Erlang/Elixir
export KERL_CONFIGURE_OPTIONS="--without-wx --without-javac --with-ssl=$(brew --prefix openssl@1.1)"
export ERL_AFLAGS="-kernel shell_history enabled"

# Go
export GOPATH="$HOME/Developer/go"
export PATH="$GOPATH/bin:$PATH"

# PATH
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export PATH="/opt/homebrew/opt/libxslt/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/nvim-macos/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Editor
VISUAL="code --wait"
EDITOR="code --wait"

# Aliases
source ~/.aliases

# Completions
autoload -Uz compinit
compinit

source <(kubectl completion zsh)

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/tofu tofu
