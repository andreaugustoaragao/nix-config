#!/bin/sh
tmux split-window -v -p 40 #"./activate-and-watch.sh"
tmux split-window -h "./activate-and-watch.sh"
#<S-F4>tmux send-keys 'nvim TODO.md' C-m
tmux select-pane -t 0
tmux send-keys 'nvim' C-m
#tmux split-window -h
#tmux send-keys 'fastfetch' C-m
#tmux select-pane -t 0
