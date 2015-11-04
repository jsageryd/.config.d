#!/usr/bin/env sh

tmux new-session -d
tmux split-window -bv
tmux select-pane -t 1
tmux resize-pane -y 16
tmux split-window -h
tmux send-keys -t 2 'tl loop r -p today @eg' Enter
tmux select-pane -t 1
tmux attach
