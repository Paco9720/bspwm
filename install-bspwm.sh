#!/bin/bash

set -e

echo "== Instalando dependencias de compilación =="

    sudo apt update

    sudo apt install -y \
        build-essential git pkg-config \
        libx11-dev libxinerama-dev \
        libxrandr-dev libxcb1-dev \
        libxcb-util-dev \
        libxcb-keysyms1-dev \
        polybar rofi picom dunst kitty \
        brightnessctl pavucontrol \
        pipewire wireplumber pulseaudio-utils \
        feh qt6ct \
        gvfs gvfs-backends gvfs-fuse \
        tumbler thunar thunar-volman \
        xdg-desktop-portal \
        xdg-desktop-portal-gtk \
        dbus-x11 \
	libxcb-xinerama0-dev \
	libxcb-util-dev \
	libxcb-keysyms1-dev \
	libxcb-xinerama0-dev \
	libxcb-icccm4-dev \
	libxcb-randr0-dev \
	libxcb-ewmh-dev \
	libxcb-render0-dev \
	libxcb-shape0-dev \
	libxcb-xkb-dev \
	libxkbcommon-x11-dev

    sudo apt install -y pamixer || true

echo "== Preparando carpeta de build =="

mkdir -p ~/build
cd ~/build

echo "== Compilando bspwm =="

rm -rf bspwm
git clone https://github.com/baskerville/bspwm.git

cd bspwm
make
sudo make install

echo "== Compilando sxhkd =="

cd ~/build

rm -rf sxhkd
git clone https://github.com/baskerville/sxhkd.git

cd sxhkd
make
sudo make install

echo
echo "====================================="
echo "bspwm y sxhkd compilados correctamente"
echo
echo "Versiones instaladas:"
echo
bspwm -v || true
sxhkd -v || true
echo
echo "Ahora ejecuta tu script de configuración"
echo "====================================="
