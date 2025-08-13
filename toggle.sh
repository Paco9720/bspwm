#!/usr/bin/env bash

# Este script inicia o detiene Polybar.

# Nombre del proceso de Polybar.
# Asegúrate de que coincida con el nombre de tu barra en el archivo de configuración.
BAR_NAME="main"

if pgrep -x "polybar" > /dev/null; then
  # Si Polybar está corriendo, lo mata.
  killall -q polybar
else
  # Si no está corriendo, lo inicia.
  # El comando 'polybar mi-barra' debe coincidir con el nombre de tu barra.
  polybar $BAR_NAME &
fi
