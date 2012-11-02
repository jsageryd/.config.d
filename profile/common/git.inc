export PATH=/usr/local/git/bin:$PATH
export MANPATH=/usr/local/git/share/man:/usr/local/gitmanpages:$MANPATH

export PS1='$(date +%H%M) \h:\w$(__git_ps1 " [%s]") \u\$ '

alias gl="git log --date=relative --format=\"%Cblue%h%Creset %C(yellow)%an%Creset %Cgreen%ad%Creset%C(yellow)%d%Creset %s\" --topo-order"
alias gd="git diff --color-words -U0"
alias gg="git gc --prune=now"
