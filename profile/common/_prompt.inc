function prompt_command() {
  local status=$?

  local green='\001\e[38;5;154m\002'
  local red='\001\e[38;5;160m\002'
  local reset='\001\e[0m\002'

  # last status
  unset STATUS
  if [ $status -ne 0 ]; then
    STATUS=$(printf "$red%d$reset " $status)
  fi

  # job count
  unset JOBCOUNT
  local jobcount=$(jobs -p | wc -l)
  if [ $jobcount -ne 0 ]; then
    JOBCOUNT=$(printf "$green[%d]$reset " $jobcount)
  fi

  # git
  if type __git_ps1 >/dev/null 2>&1; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWCOLORHINTS=1
    GIT_PS1_SHOWUPSTREAM="verbose"
    GIT_PS1_DESCRIBE_STYLE="branch"
    GITPROMPT=$(__git_ps1 "[%s] ")
  fi
}

PROMPT_COMMAND=prompt_command

PS1='${STATUS}${JOBCOUNT}\D{%H%M} \h:\W ${GITPROMPT}\u\$ '
