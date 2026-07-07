#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO_DIR/Brewfile"
# Optional external dotfiles repository. Replace the placeholder before use.
DOTFILES_REPO="https://github.com/DEIN_GITHUB_USERNAME/dotfiles.git"

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
fi

# Rosetta is still needed by a few Intel-only applications on Apple Silicon.
if [[ "$(uname -m)" == "arm64" ]] && ! /usr/bin/pgrep oahd &>/dev/null; then
  echo "Installing Rosetta 2..."
  sudo /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


# Homebrew lives in different locations on Apple Silicon and Intel Macs.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

BREW_CELLAR="$(brew --cellar)"
if [[ ! -w "$BREW_CELLAR" ]]; then
  echo "Homebrew Cellar is not writable: $BREW_CELLAR" >&2
  echo "Repair its ownership before running this bootstrap again." >&2
  exit 1
fi

# Install applications via Brewfile
if [[ -f "$BREWFILE" ]]; then
  echo "Installing applications from Brewfile..."
  brew bundle --file="$BREWFILE" --no-lock
else
  echo "Warning: Brewfile not found in current directory"
fi

# Use GNU Stow to symlink dotfiles
echo "Setting up dotfiles with GNU Stow..."
mkdir -p "$HOME/DB"
stow --restow --target="$HOME" --dir="$REPO_DIR/dotfiles" zsh ghostty
# Optional Vim configuration:
# stow --restow --target="$HOME" --dir="$REPO_DIR/dotfiles" vim

# Optional deterministic Dock layout (requires: brew install dockutil).
# Adapt the application paths before enabling these commands.
# dockutil --remove all --no-restart
# dockutil --add "/Applications/Safari.app" --no-restart
# dockutil --add "/Applications/Mail.app" --no-restart
# dockutil --add "/Applications/Calendar.app" --no-restart
# dockutil --add "/Applications/Notes.app" --no-restart
# dockutil --add "/Applications/Ghostty.app" --no-restart
# dockutil --add "/Applications/Zed.app" --no-restart
# killall Dock

# Install the current Node.js LTS through nvm instead of relying on Homebrew's
# globally linked Node version.
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
if [[ -s "$(brew --prefix nvm)/nvm.sh" ]]; then
  # shellcheck disable=SC1090
  source "$(brew --prefix nvm)/nvm.sh"
  nvm install --lts
  nvm alias default 'lts/*'
fi

echo "Applying macOS preferences..."
"$REPO_DIR/macos-defaults.sh"

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global fetch.prune true
git config --global core.autocrlf input
git config --global core.ignorecase false
git config --global diff.algorithm histogram
git config --global merge.conflictstyle zdiff3

# Optional: Agent Vault keeps credentials away from AI agents and brokers
# authenticated requests through a local proxy. Review the installer before
# enabling this command:
# curl --proto '=https' --proto-redir '=https' --tlsv1.2 -fsSL \
#   https://get.agent-vault.dev | sh

echo "Setup complete. Some preferences take effect after logging out or restarting."

# Optionally restart the shell
exec zsh -l
