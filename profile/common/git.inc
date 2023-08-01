# Return if there is no git
which git > /dev/null 2>&1 || return 0

export PATH=/usr/local/git/bin:$PATH
export MANPATH=/usr/local/git/share/man:/usr/local/gitmanpages:$MANPATH

if type __git_ps1 >/dev/null 2>&1; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWCOLORHINTS=1
  export GIT_PS1_SHOWUPSTREAM="verbose"
  export GIT_PS1_DESCRIBE_STYLE="branch"
  PC='__git_ps1 "$(_echo_coloured_exitcode)$(_echo_jobs)\D{%H%M} \h:\W" " \u\\$ " " [%s]"'
  if [ -z "$PROMPT_COMMAND" ]; then
    export PROMPT_COMMAND="$PC"
  else
    export PROMPT_COMMAND="$PC;$PROMPT_COMMAND"
  fi
fi

alias g="git"
alias gd="git diff --color-words -U0"
alias gl="g l"
alias gm="git merge --no-ff"
if which fzf > /dev/null 2>&1; then
  alias gco='git checkout $(git branch | cut -c 3- | fzf)'
  alias gcor='git checkout $(git branch -r | cut -c 3- | fzf)'
else
  alias gco='echo fzf not installed. brew install fzf.'
  alias gcor=gco
fi

# Make bash completion work with the g alias
if type __git_complete >/dev/null 2>&1; then
  __git_complete g git
fi

# Make `git kill` autocomplete branch names
function _git_kill() { __gitcomp_nl "$(__git_heads)"; }

export FILTER_BRANCH_SQUELCH_WARNING=1
