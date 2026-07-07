command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
# Optional; enable together with the commented direnv entry in the Brewfile.
# command -v direnv >/dev/null && eval "$(direnv hook zsh)"

if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

install_hint() {
  local package="$1"
  if command -v brew >/dev/null; then
    print "brew install $package"
  elif [[ "$IS_LINUX" == true ]]; then
    print "Installiere '$package' mit dem Paketmanager deiner Distribution."
  fi
}

check_missing_tools() {
  [[ -o interactive ]] || return
  local tool package
  local -A wanted=(
    rg ripgrep fd fd fzf fzf zoxide zoxide eza eza bat bat
    gh gh lazygit lazygit jq jq stow stow
  )
  for tool package in ${(kv)wanted}; do
    if ! (( $+commands[$tool] )); then
      print -P "%F{yellow}Hinweis:%f $tool fehlt — $(install_hint "$package")"
    fi
  done
}

check_missing_tools
