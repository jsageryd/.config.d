HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
HISTIGNORE="l:ll::lll:ls:history:u:f:clear:reset"

if $OS_OSX ; then
  export TERM=xterm-256color
elif $OS_LINUX ; then
  export TERM=xterm-color
elif $OS_WINDOWS ; then
  export TERM=msys
fi

export LANG=en_GB.UTF-8
export LC_COLLATE=C
export PS1="\$(date +%H%M) \h:\w \u\$ "

alias ..="cd .."
alias c="cd -P"
alias mv="mv -i"

if $OS_OSX ; then
  alias l="ls -alGvhTf"
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
fi
