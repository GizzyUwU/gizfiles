#!/bin/bash
sudo -v &>/dev/null
if [ $? -ne 0 ]; then
    echo "Error: Script requires sudo permissions to run."
    exit 1
fi

packages=(
    "base-devel"
    "git"
    "wget"
    "curl"
    "paru"
    "ripgep"
    "waybar"
    "kitty"
    "vicinae"
    "qt6-svg"
    "qt6-declarative"
    "qt5-quickcontrols2"
    "fastfetch"
    "hyfetch"
    "zinit"
)

for package in "${packages[@]}"; do
    if !sudo pacman -Q "$package" &>/dev/null; then
        if [ "$package" == "paru" ]; then
            git clone https://aur.archlinux.org/paru.git /tmp/paru
            makepkg -si --noconfirm -C -D /tmp/paru
        else
            if !sudo pacman -Q "paru" &>/dev/null; then
                echo "$package is missing"
                pacman -S --noconfirm $package
                if [ $? -ne 0 ]; then
                    echo "Error: failed to install '$package' with pacman."
                    exit 1;
                fi
            else
                echo "$package is missing. Installing it"
                paru -S --noconfirm $package
                if [ $? -ne 0 ]; then
                    echo "Error: failed to install '$package' with paru."
                    exit 1;
                fi
            fi
        fi
    fi
done

if [ -d "/usr/share/sddm/themes/catppuccin-macchiato-teal" ]; then
    echo "Folder with \"catppuccin-macchiato-teal\" name already exists in /usr/share/sddm/themes"
else
    echo "Installing Cattpuccin Macchiato Teal SDDM Theme"
    wget https://github.com/catppuccin/sddm/releases/download/v1.1.2/catppuccin-macchiato-teal-sddm.zip -O /tmp/catppuccin.zip
    unzip /tmp/catppuccin.zip -d /tmp
    sudo mv /tmp/catppuccin-macchiato-teal /usr/share/sddm/themes
fi

if [ ! -f "/etc/sddm.conf" ]; then
    echo "[Theme]" | sudo tee /etc/sddm.conf > /dev/null
    echo "Current=catppuccin-macchiato-teal" | sudo tee -a /etc/sddm.conf > /dev/null
else
    if ! rg -q "^\[Theme\]" "/etc/sddm.conf"; then
        echo "[Theme]" | sudo tee /etc/sddm.conf > /dev/null
        echo "Current=catppuccin-macchiato-teal" | sudo tee -a /etc/sddm.conf > /dev/null
    fi
fi

if [ "$(pwd)" != "$HOME/.config/dotfiles" ]; then
    if [ ! -d "$HOME/.config/dotfiles" ]; then
        mkdir -p $HOME/.config/dotfiles
        git clone https://github.com/GizzyUwU/gizfiles $HOME/.config/dotfiles
    fi
fi

echo "The gizfiles finished installing!"