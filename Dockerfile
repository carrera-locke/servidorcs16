# Usamos una imagen base con SteamCMD
FROM cm2network/steamcmd

ENV HLDS_DIR=/home/steam/hlds

USER root

RUN apt-get update && apt-get install -y wget

RUN mkdir -p $HLDS_DIR && chown -R steam:steam $HLDS_DIR

USER steam

# Instalamos HLDS con SteamCMD
RUN ./steamcmd.sh +force_install_dir $HLDS_DIR \
    +login anonymous \
    +app_set_config 90 mod cstrike \
    +app_update 90 validate \
    +quit

# Copiamos los archivos de Metamod desde el contexto (del repositorio clonado)
COPY metamod/ $HLDS_DIR/cstrike/addons/metamod/

# Activamos Metamod en liblist.gam
RUN echo "linux addons/metamod/dlls/metamod.so" > $HLDS_DIR/cstrike/liblist.gam

WORKDIR $HLDS_DIR

EXPOSE 27021/udp

CMD ["./hlds_run", "-game", "cstrike", "+maxplayers", "10", "+map", "de_dust2", "-port", "27021"]