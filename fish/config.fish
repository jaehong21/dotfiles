set -g fish_greeting

# ---- PATH ----
# fish_add_path /bin /usr/bin /sbin /usr/sbin
fish_add_path ~/go/bin # go
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

# ---- zoxide ----
zoxide init fish | source

# ---- mise ----
$BREW_PREFIX/opt/mise/bin/mise activate fish | source

# ---- oh-my-posh ----
$BREW_PREFIX/bin/oh-my-posh init fish --config ~/dotfiles/oh-my-posh.toml | source
