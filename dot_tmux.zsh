# tmux helpers
__tmux_new_session() {
  local name="$1"
  local base="${PWD##*/}"
  base="${base// /_}"
  base="${base//./}"

  local suffix
  if [[ -n "$name" ]]; then
    suffix="$name"
  else
    suffix="$(uuidgen 2>/dev/null | tr '[:upper:]' '[:lower:]' | tr -d '-' | cut -c1-8)"
    if [[ -z "$suffix" ]]; then
      suffix="$(LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c8)"
    fi
  fi

  local session_name="${base}/${suffix}"
  command tmux new-session -d -s "$session_name"
  command tmux attach-session -t "$session_name"
}

__tmux_attach_session() {
  local sessions
  sessions="$(command tmux list-sessions -F '#{session_name}' 2>/dev/null)"
  if [[ $? -ne 0 || -z "$sessions" ]]; then
    echo "No sessions"
    return
  fi

  local selected
  selected="$(printf '%s\n' "$sessions" | fzf)"
  if [[ -z "$selected" ]]; then
    return
  fi

  command tmux attach-session -t "$selected"
}

tmux() {
  local subcmd="$1"
  case "$subcmd" in
    n)
      shift
      __tmux_new_session "$1"
      ;;
    a)
      shift
      __tmux_attach_session
      ;;
    l)
      shift
      command tmux list-sessions "$@"
      ;;
    k)
      shift
      command tmux kill-server "$@"
      ;;
    *)
      command tmux "$@"
      ;;
  esac
}

