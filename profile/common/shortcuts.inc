# Disk usage
alias u="du -hs ."
alias f="df -h ."

# Tmux
alias ta="tmux attach"

# Week number
alias week="date +%V"

alias nh='unset HISTFILE; if [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ]; then tmux set-option -p -t "$TMUX_PANE" @nohist 1 >/dev/null 2>&1; fi; true'
