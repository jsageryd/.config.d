export TERM=xterm-256color

# Make path_helper set MANPATH from /etc/manpaths.d/*
export MANPATH=
if [ -x /usr/libexec/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
