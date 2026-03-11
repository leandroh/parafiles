# Homebrew
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# VS Code CLI
[ -d "/Applications/Visual Studio Code.app" ] && export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Cloud66
[ -d /opt/cloud66/bin ] && export PATH="/opt/cloud66/bin:${PATH}"

# OrbStack (uncomment if installed)
# source ~/.orbstack/shell/init.zsh 2>/dev/null || :
