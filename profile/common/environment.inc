HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
HISTIGNORE="l:ll::lll:ls:history:u:f:clear:reset"

_echo_coloured_exitcode() {
  c=$?
  [ $c -eq 0 ] && return
  echo -n "\[\e[38;5;160m\]$c\[\e[0m\] "
}

export LC_ALL=en_US.UTF-8
export PROMPT_COMMAND='history -a'
export PS1="$(_echo_coloured_exitcode)\D{%H%M} \h:\W \u\\$ "
export EDITOR=vi
export PATH=$HOME/bin:$CONFIG_ROOT/bin:$PATH

alias ..="cd .."
alias c="cd -P"
alias mv="mv -i"

if $OS_OSX ; then
  alias l="ls -alGvhT"
  alias ll="ls -altGvhT"
  alias lll="ls -alGvhTS"
  alias ls="ls -Gv"
else
  alias l="ls -alvh --color=auto"
  alias ll="ls -altvh --color=auto"
  alias lll="ls -alvhS --color=auto"
  alias ls="ls -v --color=auto"
fi

if $OS_OSX || $OS_LINUX ; then
  shopt -s cdspell
  shopt -s histappend
  shopt -s no_empty_cmd_completion
fi
