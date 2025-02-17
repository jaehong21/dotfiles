# ---- system ----
alias ls="lsd"
alias cls="clear"
alias n="nvim"

# ---- config ----
alias vc-clean="rm -rf ~/.local/state/nvim/swap ~/.local/state/nvim/lsp.log"
alias brewapply="brew bundle --file=~/dotfiles/Brewfile --cleanup --no-lock"
# alias colimaconfig "nvim ~/.colima/default/colima.yaml"
# alias colima-network-clean "rm -rf ~/.colima/_lima/_networks/user-v2"

# ---- misc ---
alias lg="lazygit"

# ---- terraform and kubectl ----
alias tf="terraform"
alias tg="terragrunt "
alias k=kubectl
alias kcs="kubectl config use-context"
# alias kns="kubectl config set-context --current --namespace"

export K9S_CONFIG_DIR="$HOME/dotfiles/k9s"
alias k9s="k9s -A"

# ---- ansible ----
alias an="ansible"
alias anp="ansible-playbook"
alias and="ansible-doc"
alias anv="ansible-vault"

# ---- python ----
alias python="python3"
alias pip="pip3"
