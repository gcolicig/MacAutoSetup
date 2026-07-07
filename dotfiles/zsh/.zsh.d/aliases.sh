# Prefer GNU tools over BSD ones
command -v gsed >/dev/null && alias sed='gsed'
command -v gawk >/dev/null && alias awk='gawk'

# Use bat's syntax highlighting when cat is entered interactively.
command -v bat >/dev/null && alias cat='bat'

if command -v eza >/dev/null; then
  alias ll='eza -lh --icons --git'
  alias la='eza -lah --icons --git'
  alias tree='eza --tree --icons --level=2'
fi


if command -v zed >/dev/null; then
  alias db='cd ~/DB && zed ~/DB/index.md'
  alias te='zed ~/DB/todo.txt'
else
  alias db='cd ~/DB && "$EDITOR" ~/DB/index.md'
  alias te='"$EDITOR" ~/DB/todo.txt'
fi

if command -v todo.sh >/dev/null; then
  alias todo='todo.sh'
  alias t='todo.sh'
  alias td='todo.sh done'
  alias ta='todo.sh add'
  alias tl='todo.sh list'
  alias tp='todo.sh pri'
fi
