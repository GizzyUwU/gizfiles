#!/bin/bash
chosen=$(find /usr/share/wallpapers -type f | vicinae dmenu -p 'Pick a wallpaper...')
if [ -n "$chosen" ]; then
    cp -f "$chosen" $HOME/.config/dotfiles/wallpaper
    swww img $chosen
fi