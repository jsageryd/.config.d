#!/usr/bin/env sh

tmux new-session -d
tmux split-window -v
tmux split-window -v
tmux split-window -h
tmux select-pane -t 0
tmux split-window -h
tmux split-window -h
tmux resize-pane -x 66 -y 20 -t 0
tmux resize-pane -x 100 -t 2
tmux select-pane -t 3
tmux split-window -h -p 45
tmux select-pane -t 0
tmux attach
