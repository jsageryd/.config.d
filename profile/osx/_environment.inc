# Make path_helper set MANPATH from /etc/manpaths.d/*
export MANPATH=
if [ -x /usr/libexec/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

export BASH_SILENCE_DEPRECATION_WARNING=1

# Dark/light mode
if [ "$ITERM_PROFILE" = "_ $" ]; then
  export COLOR_SCHEME="light"
else
  export COLOR_SCHEME="dark"
fi
