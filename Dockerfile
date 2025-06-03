# Imagen base con SteamCMD
FROM cm2network/steamcmd

ENV HLDS_DIR=/home/steam/hlds

USER root
RUN apt-get update && apt-get install -y wget tar

RUN mkdir -p $HLDS_DIR && chown -R steam:steam $HLDS_DIR

USER steam

RUN ./steamcmd.sh +force_install_dir $HLDS_DIR \
    +login anonymous \
    +app_set_config 90 mod cstrike \
    +app_update 90 validate \
    +quit

# Copiamos el archivo .tar que contiene metamod.so y el link simbólico directo
COPY metamod.tar /tmp/metamod.tar.gz

# Descomprimimos directamente dentro de la ruta de destino
RUN mkdir -p $HLDS_DIR/cstrike/addons/metamod/dlls && \
    tar -xf /tmp/metamod.tar -C $HLDS_DIR/cstrike/addons/metamod/dlls

# Configuramos liblist.gam para usar metamod.so
RUN echo "gamedll_linux \"addons/metamod/dlls/metamod.so\"" > $HLDS_DIR/cstrike/liblist.gam

WORKDIR $HLDS_DIR

EXPOSE 27021/udp

CMD ["./hlds_run", "-game", "cstrike", "+maxplayers", "10", "+map", "de_dust2", "-port", "27021"]