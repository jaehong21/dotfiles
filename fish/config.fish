set -g fish_greeting

# ---- PATH ----
# fish_add_path /bin /usr/bin /sbin /usr/sbin
fish_add_path ~/go/bin # go
for go_bin in ~/.local/share/mise/installs/go/*/bin
  if test -d $go_bin
    fish_add_path $go_bin
  end
end

fish_add_path ~/.local/share/bob/nvim-bin # bob-nvim

# ---- homebrew ----
eval "$(/opt/homebrew/bin/brew shellenv)"
set BREW_PREFIX (brew --prefix)

# ---- fish scripts ----
for file in ~/dotfiles/fish/*.fish
  if test (basename $file) != "config.fish"
    source $file
  end
end

# --- autojump ---
[ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish

# --- fzf ---
[ -f /opt/homebrew/bin/fzf ]; and fzf --fish | source
alias f="cd (fd --type directory --hidden | fzf)"

# ---- mise ----
set -Ux MISE_GLOBAL_CONFIG_FILE ~/dotfiles/mise.toml
$BREW_PREFIX/opt/mise/bin/mise activate fish | source

# ---- oh-my-posh ----
$BREW_PREFIX/bin/oh-my-posh init fish --config ~/dotfiles/oh-my-posh.toml | source

# ---- postgresql@17 ----
fish_add_path /opt/homebrew/opt/postgresql@17/bin

# ---- argo-rollouts ----
kubectl argo rollouts completion fish | source
