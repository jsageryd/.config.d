export PATH=/usr/local/git/bin:$PATH
export MANPATH=/usr/local/git/share/man:/usr/local/gitmanpages:$MANPATH

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWCOLORHINTS=1
export PROMPT_COMMAND='__git_ps1 "$(date +%H%M) \h:\w" " \u\$ " " [%s]"'

alias gl="git log --date=relative --format=\"%Cblue%h%Creset %C(yellow)%an%Creset %Cgreen%ad%Creset%C(yellow)%d%Creset %s\" --topo-order"
alias gd="git diff --color-words -U0"
alias gg="git gc --prune=now"
