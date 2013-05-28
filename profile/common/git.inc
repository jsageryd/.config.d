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
#
# Use `gb cherry <branch>` to run git cherry for each branch against <branch>
# to see if the branch is integrated into <branch>. Integrated branches will be
# output with prefix `⊇` (for '(<branch> is a) superset of branch') and
# highlighted. If specified <branch> is a local branch; it will be prefixed with
# `⊆` (for '(branch is a) subset of <branch>').
#
# Example:
#
#   gb cherry master
#
# ...will show which branches are integrated into master:
#
#   ⊆ master (marked branches are subset of master branch)
#   ⊇ branch_a (master branch is a superset of branch_a)
#   ⊇ branch_b (master branch is a superset of branch_b)
#     branch_c (not subset of master)
function gb() {
  branches=$(git for-each-ref --format='%(refname)' refs/heads/ | sed 's|refs/heads/||')
  branches_sorted=$(
    for branch in $branches; do
      echo "$(git log -1 --format='%ct' refs/heads/$branch) $branch"
    done | sort -rn | cut -f 2- -d ' '
  )
  cherrying=false
  if [ "$1" = 'cherry' ]; then
    if $(git show-ref -q "$2" > /dev/null 2>&1); then
      cherrying=true
    else
      echo "Ref '$2' does not exist." >&2
      return 1
    fi
  fi
  activebranch=$(git rev-parse --abbrev-ref HEAD)
  superset="\033[1;34m⊇\033[0m"
  subset="\033[1;33m⊆\033[0m"
  for branch in $branches_sorted; do
    modified=$(git log -1 --format='%cr' refs/heads/$branch)
    desc=$(git config branch.$branch.description)
    desc_head=$(echo "$desc" | cut -f 1 -d ' ')
    desc_tail=$(echo "$desc" | cut -f 2- -d ' ')
    mark_as_superset_of=false
    mark_as_subset_of=false
    if $cherrying; then
      if [ "$2" = $branch ]; then
        mark_as_superset_of=true
      elif ! $(git cherry "$2" $branch | grep -q +); then
        mark_as_subset_of=true
      fi
    fi
    if [ $branch = $activebranch ]; then
      if $mark_as_subset_of; then
        mark=$superset
      elif $mark_as_superset_of; then
        mark=$subset
      else
        mark='*'
      fi
      branch="$mark \033[0;32m$branch\033[0m"
    elif $mark_as_subset_of; then
      branch="$superset \033[1;34m$branch\033[0m"
    elif $mark_as_superset_of; then
      branch="$subset \033[1;33m$branch\033[0m"
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
