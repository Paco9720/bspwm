#!/bin/bash

set -e

echo "== Instalando paquetes =="

    sudo apt install -y \
    polybar rofi picom dunst kitty \
    brightnessctl pavucontrol pipewire \
    wireplumber pulseaudio-utils \
    feh qt6ct \
    gvfs gvfs-backends tumbler \
    dbus-x11

sudo apt install -y pamixer || true
echo "== Creando carpetas =="

mkdir -p ~/.config/{bspwm,sxhkd,polybar,picom,rofi,dunst}

########################################
# BSPWMRC
########################################

cat > ~/.config/bspwm/bspwmrc << 'EOF'
#!/bin/sh

# Escritorios
bspc monitor -d 1 2 3 4 5 6 7 8 9 10

# Configuración general
bspc config border_width         0
bspc config window_gap           0
bspc config split_ratio         0.52

bspc config borderless_monocle true
bspc config gapless_monocle true

# Bordes
bspc config normal_border_color "#222222"
bspc config focused_border_color "#909090"
bspc config active_border_color "#606060"
bspc config presel_feedback_color "#FFFFFF"

bspc config focus_follows_pointer false

# Reglas
bspc rule -a Pavucontrol state=floating
bspc rule -a feh state=floating
bspc rule -a nm-connection-editor state=floating
EOF

chmod +x ~/.config/bspwm/bspwmrc

########################################
# SXHKDRC
########################################

cat > ~/.config/sxhkd/sxhkdrc << 'EOF'
#
# Programas
#

super + Return
	kitty

super + space
	rofi -show drun

super + Escape
	pkill -USR1 -x sxhkd

#
# Brillo
#

XF86MonBrightnessDown
	brightnessctl set 10%-

XF86MonBrightnessUp
	brightnessctl set +10%

super + F11
	brightnessctl set 10%-

super + F12
	brightnessctl set +10%

#
# Volumen
#

XF86AudioRaiseVolume
	pamixer --increase 5

XF86AudioLowerVolume
	pamixer --decrease 5

XF86AudioMute
	pamixer -t

super + F3
	pamixer --increase 5

super + F2
	pamixer --decrease 5

#
# bspwm
#

super + alt + {e,r}
	bspc {quit,wm -r}

super + {_,shift + }q
	bspc node -{c,k}

super + m
	bspc desktop -l next

super + {t,shift + t,s,f}
	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

super + ctrl + {m,x,y,z}
	bspc node -g {marked,locked,sticky,private}

super + {Left,Down,Up,Right}
	bspc node -f {west,south,north,east}

super + {_,shift + }{1-9,0}
	bspc {desktop -f,node -d} '^{1-9,10}'

super + alt + {Left,Right}
	bspc desktop -f {prev,next}.local

super + Tab
	bspc desktop -f last

super + alt + {Left,Down,Up,Right}
	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}
EOF

########################################
# POLYBAR
########################################

cat > ~/.config/polybar/config.ini << 'EOF'
[colors]
background = #000000
background-alt = #2b2b2b
foreground = #FFFFFF
primary = #909090
secondary = #707070
alert = #A54242
disabled = #707880

[bar/main]
width = 100%
height = 16
radius = 0

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 0
border-size = 0

padding-left = 1
padding-right = 1

module-margin = 0

separator = |
separator-foreground = ${colors.disabled}

font-0 = Liberation Mono:size=10;2

modules-left = xworkspaces xwindow
modules-right = memory cpu date

enable-ipc = true
wm-restack = bspwm

[module/xworkspaces]
type = internal/xworkspaces

label-active = %name%
label-active-background = ${colors.background-alt}
label-active-underline = ${colors.primary}
label-active-padding = 1

label-occupied = %name%
label-occupied-padding = 1

label-empty = %name%
label-empty-foreground = ${colors.disabled}
label-empty-padding = 1

[module/xwindow]
type = internal/xwindow
label = %title:0:50:...%

[module/pulseaudio]
type = internal/pulseaudio
label-volume = VOL %percentage%%
label-muted = muted

[module/memory]
type = internal/memory
interval = 2
label = RAM %percentage_used%%

[module/cpu]
type = internal/cpu
interval = 2
label = CPU %percentage%%

[module/date]
type = internal/date
interval = 1
date = %Y-%m-%d %H:%M
label = %date%

[module/systray]
type = internal/tray
EOF

cat > ~/.config/polybar/launch.sh << 'EOF'
#!/bin/sh

killall -q polybar

while pgrep -u "$UID" -x polybar >/dev/null; do
	sleep 1
done

polybar main &
EOF

chmod +x ~/.config/polybar/launch.sh

########################################
# PICOM
########################################

cat > ~/.config/picom/picom.conf << 'EOF'
backend = "glx";
vsync = true;

blur-background = true;
blur-method = "kernel";
blur-strength = 5;

inactive-opacity = 0.90;
active-opacity = 1.0;
frame-opacity = 0.95;

fading = true;
fade-in-step = 0.03;
fade-out-step = 0.03;

shadow = true;

opacity-rule = [
  "95:class_g = 'Polybar'",
  "90:class_g = 'kitty'"
];
EOF

########################################
# DUNST
########################################

cat > ~/.config/dunst/dunstrc << 'EOF'
[global]
monitor = 0
follow = mouse
width = 300
height = 300
offset = 20x50
origin = top-right
transparency = 10
frame_width = 2
corner_radius = 8
font = Sans 10
separator_height = 2
padding = 12
horizontal_padding = 12

background = "#000000"
foreground = "#FFFFFF"
frame_color = "#909090"

[urgency_low]
timeout = 4

[urgency_normal]
timeout = 6

[urgency_critical]
background = "#A54242"
foreground = "#FFFFFF"
timeout = 0
EOF

########################################
# XINITRC
########################################

cat > ~/.xinitrc << 'EOF'
#!/bin/sh

export GTK_THEME=Adwaita-dark
export QT_QPA_PLATFORMTHEME=qt6ct
export XDG_CURRENT_DESKTOP=bspwm

xsetroot -cursor_name left_ptr

# Wallpaper
#feh --bg-fill ~/Pictures/wallpaper.jpg &

# Servicios
sxhkd &
picom --config ~/.config/picom/picom.conf &
dunst &
~/.config/polybar/launch.sh &

exec dbus-run-session bspwm

EOF

chmod +x ~/.xinitrc

########################################
# Permisos brillo
########################################

if getent group video >/dev/null; then
    sudo usermod -aG video "$USER" || true
fi

echo
echo "====================================="
echo "Instalación completada"
echo
echo "Pon tu wallpaper en:"
echo "~/Pictures/wallpaper.jpg"
echo
echo "Inicia sesión con:"
echo "startx"
echo "====================================="
