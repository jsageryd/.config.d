HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
HISTIGNORE="l:ll::lll:ls:history:u:f:clear:reset"

export LANG=en_GB.UTF-8
export LC_COLLATE=C
export PROMPT_COMMAND='history -a'
export PS1="\D{%H%M} \h:\w \u\$([ \$? -eq 1 ] && printf \"\033[0;35m\")\\$\033[0m "
export EDITOR=vi
export PATH=$CONFIG_ROOT/bin:$PATH

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
fi
