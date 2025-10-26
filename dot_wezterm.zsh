# WezTerm helpers
__wezterm_require_tools() {
  local tool
  for tool in wezterm jq fzf; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      echo "wezterm helper: missing required '$tool' command" >&2
      return 1
    fi
  done
  return 0
}

__wezterm_select_tab() {
  local query="$1"
  __wezterm_require_tools || return 1

  local json
  if ! json="$(command wezterm cli list --format json 2>/dev/null)"; then
    echo "wezterm helper: failed to list tabs via 'wezterm cli list'" >&2
    return 1
  fi

  if [[ -z "$json" || "$json" == "[]" ]]; then
    echo "wezterm helper: no running tabs were found" >&2
    return 1
  fi

  local entries
  entries="$(jq -r '
    def nice_title:
      if (.tab_title // "") != "" then .tab_title
      elif (.title // "") != "" then .title
      elif (.window_title // "") != "" then .window_title
      else "-"
      end;
    def nice_cwd:
      (.cwd // "")
      | sub("^file://[^/]*"; "");
    map(
      (nice_cwd) as $cwd
      | (nice_title) as $title
      | {
          tab_id: .tab_id,
          window_id: .window_id,
          workspace: (.workspace // "default"),
          title: $title,
          cwd: $cwd,
          cwd_display: (if ($cwd | length) > 0 then " -- " + $cwd else "" end)
        }
    )
    | sort_by(.workspace, .window_id, .tab_id)
    | .[]
    | "\(.tab_id)\t[\(.workspace)] win:\(.window_id) \(.title)\(.cwd_display)"
  ' <<<"$json")" || return 1

  if [[ -z "$entries" ]]; then
    echo "wezterm helper: no running tabs were found" >&2
    return 1
  fi

  local -a fzf_opts
  fzf_opts=(
    --prompt='wezterm tab> '
    --delimiter=$'\t'
    --with-nth=2..
    --height=80%
    --layout=reverse
    --border
    --cycle
    --ansi
    --select-1
    --exit-0
    --header='Select a WezTerm tab to activate'
  )
  if [[ -n "$query" ]]; then
    fzf_opts+=(--query "$query")
  fi

  local selected
  selected="$(printf '%s\n' "$entries" | fzf "${fzf_opts[@]}")"
  local fzf_status=$?
  if [[ $fzf_status -ne 0 || -z "$selected" ]]; then
    return $fzf_status
  fi

  printf '%s' "${selected%%$'\t'*}"
}

__wezterm_attach_tab() {
  local tab_id
  tab_id="$(__wezterm_select_tab "$1")" || return $?
  command wezterm cli activate-tab --tab-id "$tab_id"
}

wezterm() {
  local subcmd="$1"
  case "$subcmd" in
    ta|attach-tab)
      shift
      __wezterm_attach_tab "$@"
      ;;
    *)
      command wezterm "$@"
      ;;
  esac
}
