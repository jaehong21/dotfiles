#!/usr/bin/env fish

abbr --add g 'git'

function current_branch
  git rev-parse --abbrev-ref HEAD
end

alias gl='git pull'
alias gp='git push'
alias gb='git branch'
alias gr='git remote'
alias gst='git status'
alias gluc='git pull upstream main'
alias gcm='git checkout main'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gcmsg='git commit -m'
