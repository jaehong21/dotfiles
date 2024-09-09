#!/usr/bin/env fish

# ---- system ----

# ---- config ----
abbr --add vc-clean "rm -rf ~/.local/state/nvim/swap ~/.local/state/nvim/lsp.log"

abbr --add brewapply "brew bundle --file=~/dotfiles/Brewfile --cleanup --no-lock"
abbr --add colimaconfig "nvim ~/.colima/default/colima.yaml"
abbr --add colima-network-clean "rm -rf ~/.colima/_lima/_networks/user-v2"

# ---- terraform and kubectl ----
abbr --add tf "terraform"
abbr --add tg "terragrunt"
abbr --add k kubectl
abbr --add kcs "kubectl config use-context"
# alias kns="kubectl config set-context --current --namespace"
alias k9s="k9s -A"

# ---- python ----
alias python="python3"
alias pip="pip3"

# ---- navigation ----
function ..
    pwd; cd ..; pwd
end
function ...
    pwd; cd ../..; pwd
end
function ....
    pwd; cd ../../..; pwd
end
function .....
    pwd; cd ../../../..; pwd
end

