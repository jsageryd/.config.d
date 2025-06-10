function prompt_command() {
  local status=$?

  if [ "$COLOUR_SCHEME" = "light" ]; then
    local green='\001\e[38;5;22m\002'
    local red='\001\e[38;5;124m\002'
    local reset='\001\e[0m\002'
  else
    local green='\001\e[38;5;154m\002'
    local red='\001\e[38;5;160m\002'
    local reset='\001\e[0m\002'
  fi

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

# Helper copied from git-prompt contrib, to set custom colors
function __git_ps1_colorize_gitstring ()
{
  if [ "$COLOUR_SCHEME" = "light" ]; then
    local c_red=$'\001\e[38;5;124m\002'
    local c_green=$'\001\e[38;5;22m\002'
    local c_lblue=$'\001\e[38;5;33m\002'
    local c_clear=$'\001\e[0m\002'
  else
    local c_red=$'\001\e[38;5;160m\002'
    local c_green=$'\001\e[38;5;190m\002'
    local c_lblue=$'\001\e[38;5;45m\002'
    local c_clear=$'\001\e[0m\002'
  fi

	local bad_color=$c_red
	local ok_color=$c_green
	local flags_color="$c_lblue"

	local branch_color=""
	if [ $detached = no ]; then
		branch_color="$ok_color"
	else
		branch_color="$bad_color"
	fi
	if [ -n "$c" ]; then
		c="$branch_color$c$c_clear"
	fi
	b="$branch_color$b$c_clear"

	if [ -n "$w" ]; then
		w="$bad_color$w$c_clear"
	fi
	if [ -n "$i" ]; then
		i="$ok_color$i$c_clear"
	fi
	if [ -n "$s" ]; then
		s="$flags_color$s$c_clear"
	fi
	if [ -n "$u" ]; then
		u="$bad_color$u$c_clear"
	fi
}
