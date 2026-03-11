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

[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# Secrets (API keys, tokens, etc.)
[ -f ~/.secrets ] && source ~/.secrets

# asdf
[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ] && . /opt/homebrew/opt/asdf/libexec/asdf.sh

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Erlang/Elixir
if command -v brew &>/dev/null; then
  export KERL_CONFIGURE_OPTIONS="--without-wx --without-javac --with-ssl=$(brew --prefix openssl@1.1)"
fi
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

# Editor
export VISUAL="code --wait"
export EDITOR="code --wait"

# Aliases
[ -f ~/.aliases ] && source ~/.aliases

# Completions
autoload -Uz compinit
compinit

command -v kubectl &>/dev/null && source <(kubectl completion zsh)

autoload -U +X bashcompinit && bashcompinit
command -v tofu &>/dev/null && complete -o nospace -C "$(command -v tofu)" tofu
