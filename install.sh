#!/bin/bash

# Variables
STEAMCMD_DIR="/steamcmd"
INSTALL_DIR="/home/steam/hlds"

# Instala HLDS con SteamCMD y el mod Counter-Strike (cstrike)
$STEAMCMD_DIR/steamcmd.sh +login anonymous \
    +force_install_dir $INSTALL_DIR \
    +app_set_config 90 mod cstrike \
    +app_update 90 validate \
    +quit

# Instala Metamod
cd $INSTALL_DIR/cstrike
mkdir -p addons/metamod/dlls
wget -O addons/metamod/dlls/metamod.so https://github.com/Metamod-P/metamod-p/releases/download/v1.21/metamod_i386.so

# Configura Metamod
echo "linux addons/metamod/dlls/metamod.so" > liblist.gam

# Muestra mensaje final
echo "HLDS + Counter-Strike + Metamod instalado correctamente."
