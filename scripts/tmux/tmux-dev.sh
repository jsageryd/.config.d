#!/usr/bin/env sh

tmux new-session -d
tmux split-window -v
tmux split-window -v
tmux split-window -h
tmux split-window -h
tmux resize-pane -x 120 -y 16 -t 2
tmux resize-pane -x 120 -t 3
tmux select-pane -t 0
tmux split-window -h
tmux split-window -h
tmux resize-pane -x 66 -y 20 -t 0
tmux resize-pane -x 100 -t 2
tmux select-pane -t 3
tmux split-window -h -p 45
tmux select-pane -t 0
tmux send-keys -t 0 'tl loop r -p today @bg' Enter
tmux send-keys -t 1 'cd ~/Documents/ledger/time/ ; clear' Enter
tmux send-keys -t 2 'cd ~/Documents/ledger/personal/ ; clear' Enter
tmux send-keys -t 3 'cd ~/Documents/bonnier/sparkle/ ; clear' Enter
tmux send-keys -t 4 'cd ~/Documents/bonnier/sparkle/ ; clear' Enter
tmux send-keys -t 5 'cd ~/Documents/bonnier/sparkle-deploy/ ; clear' Enter
tmux send-keys -t 6 'cd ~/Documents/bonnier/sparkle-deploy/ ; clear' Enter
tmux send-keys -t 7 'cd ~/Documents/bonnier/sparkle-deploy/ ; clear' Enter
tmux select-pane -t 3
tmux attach
