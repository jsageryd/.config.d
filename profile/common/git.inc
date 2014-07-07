# Return if there is no git
which -s git || return 0

export PATH=/usr/local/git/bin:$PATH
export MANPATH=/usr/local/git/share/man:/usr/local/gitmanpages:$MANPATH

if type __git_ps1 >/dev/null 2>&1; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWCOLORHINTS=1
  export PROMPT_COMMAND='__git_ps1 "\D{%H%M} \h:\w" " \u\\$ " " [%s]"; history -a'
fi

alias g="git"
alias gl="git log --date=relative --format=\"%Cblue%h%Creset %C(yellow)%an%Creset %Cgreen%ad%Creset%C(auto)%d%Creset %s\" --topo-order"
alias gd="git diff --color-words -U0"

# Make bash completion work with the g alias
complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null || complete -o default -o nospace -F _git g

# Make `git kill` autocomplete branch names just like `git checkout`
function _git_kill() { _git_checkout; }

# Shows branches with descriptions
# The first word in the description is specially highlighted:
# - wip means work in progress
# - rip means review in progess
# - ready means branch is ready for review but has not yet been sent for review
# - review means branch is under review
# - deploy means branch is reviewed and ready to be sent for deploy
# - pending means branch is pending to be in wip or rip status
# - ice means branch is on ice, halted for the time being
function gb() {
  if [ "$1" = '--sort' -o "$1" = '-s' ]; then
    branches_with_time=$(git for-each-ref --format='%(committerdate:raw):%(refname:short):%(committerdate:relative)' refs/heads/ | sort -rn | sed -E 's/^[^:]+://')
  elif [ ! -z "$1" ]; then
    echo "Invalid argument '$1'"
    echo 'Usage:'
    echo '  --sort (-s) sort branches by last commit time'
    return
  else
    branches_with_time=$(git for-each-ref --format='%(refname:short):%(committerdate:relative)' refs/heads/)
  fi
  activebranch=$(git rev-parse --abbrev-ref HEAD)
  descriptions=$(git config --get-regexp 'branch.*description' | tr -s '\n' | sed 's/branch.\(.*\).description \(.*\)/\1:\2/')
  echo "$branches_with_time" | while read branch_with_time; do
    branch=${branch_with_time%%:*}
    modified_at=${branch_with_time#*:}
    desc_kv=$(echo "$descriptions" | grep "^$branch:")
    desc="${desc_kv#*:} "
    desc_head=${desc%% *}
    desc_tail=${desc#* }
    desc_tail=${desc_tail% }
    if [ $branch = $activebranch ]; then
      branch="* \033[0;32m$branch\033[0m"
    else
      branch="  $branch"
    fi
    case $desc_head in
      '') ;;
      'wip')     desc_head=" \033[1;31m$desc_head\033[0m" ;;
      'rip')     desc_head=" \033[1;31m$desc_head\033[0m" ;;
      'ready')   desc_head=" \033[1;32m$desc_head\033[0m" ;;
      'review')  desc_head=" \033[1;33m$desc_head\033[0m" ;;
      'deploy')  desc_head=" \033[1;34m$desc_head\033[0m" ;;
      'pending') desc_head=" \033[1;34m$desc_head\033[0m" ;;
      'ice')     desc_head=" \033[0;34m$desc_head\033[0m" ;;
      *)         desc_head=" \033[0;36m$desc_head\033[0m"
    esac
    [ ! -z "$desc_tail" ] && desc_head="$desc_head "
    echo -e "$branch$desc_head\033[0;36m$desc_tail\033[0m \033[0;37m[$modified_at]\033[0m"
  done
}

# Finds commits (not counting merges) that do not contain an issue reference,
# specifically /refs #[0-9]{4}/, in the current branch since it was branched
# from origin/master, specifically origin/master..HEAD.
# Prints list of offending commits and returns 0 if such commits exist,
# returns 1.
function gnoref() {
  unreferenced=$(comm -23 <(git rev-list --no-merges origin/master..HEAD | sort) \
    <(git rev-list --no-merges -E --grep 'refs #[0-9]{4}' origin/master..HEAD | sort))
  if [ -z $unreferenced ]; then
    return 1
  else
    count=$(echo "$unreferenced" | wc -l | tr -d ' ')
    git log --abbrev-commit --no-walk $unreferenced
    if [[ $count -eq 1 ]]; then
      printf "\n\033[1;31mThis commit lacks proper issue reference.\033[0m\n"
    else
      printf "\n\033[1;31mThese $count commits lack proper issue references.\033[0m\n"
    fi
    return 0
  fi
}
