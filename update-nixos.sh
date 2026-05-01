#!/bin/sh

rm -rf $HOME/.config/xfce4/xfconf
rm -rf $HOME/.config/mimeapps.list
sudo nixos-rebuild --flake .#$(hostname) switch
