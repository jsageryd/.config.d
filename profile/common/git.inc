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

# Shows branches with descriptions sorted descending after last commit date
# The first word in the description is specially highlighted:
# - wip means work in progress
# - ready means branch is ready for review but has not yet been sent for review
# - review means branch is under review
# - deploy means branch is reviewed and ready to be sent for deploy
function gb() {
  branches=$(git for-each-ref --format='%(refname)' refs/heads/ | sed 's|refs/heads/||')
  branches_sorted=$(
    for branch in $branches; do
      echo "$(git log -1 --format='%ct' refs/heads/$branch) $branch"
    done | sort -rn | cut -f 2- -d ' '
  )
  for branch in $branches_sorted; do
    modified=$(git log -1 --format='%cr' refs/heads/$branch)
    desc=$(git config branch.$branch.description)
    desc_head=$(echo "$desc" | cut -f 1 -d ' ')
    desc_tail=$(echo "$desc" | cut -f 2- -d ' ')
    if [ $branch = $(git rev-parse --abbrev-ref HEAD) ]; then
      branch="* \033[0;32m$branch\033[0m"
    else
      branch="  $branch"
    fi
    case $desc_head in
      '') ;;
      'wip') desc_head=" \033[1;31m$desc_head\033[0m " ;;
      'ready') desc_head=" \033[1;32m$desc_head\033[0m " ;;
      'review') desc_head=" \033[1;33m$desc_head\033[0m " ;;
      'deploy') desc_head=" \033[1;34m$desc_head\033[0m " ;;
      *) desc_head=" \033[0;36m$desc_head\033[0m "
    esac
    echo -e "$branch$desc_head\033[0;36m$desc_tail\033[0m \033[0;37m[$modified]\033[0m"
  done
}
