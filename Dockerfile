# Cambiamos a root para instalar dependencias
USER root
RUN apt-get update && apt-get install -y wget

# Creamos el directorio HLDS y asignamos permisos al usuario steam
RUN mkdir -p $HLDS_DIR && chown -R steam:steam $HLDS_DIR

# Volvemos al usuario steam para ejecutar SteamCMD
USER steam

# Instalamos HLDS con el mod cstrike
RUN ./steamcmd.sh +force_install_dir $HLDS_DIR \
    +login anonymous \
    +app_set_config 90 mod cstrike \
    +app_update 90 validate \
    +quit

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR $HLDS_DIR

# Copiamos los archivos de Metamod desde el contexto de construcción
COPY metamod /home/steam/hlds/cstrike/addons/metamod

# Configuramos liblist.gam para que cargue Metamod
RUN echo "linux addons/metamod/dlls/metamod.so" > /home/steam/hlds/cstrike/liblist.gam

# Exponemos el puerto del servidor
EXPOSE 27021/udp

# Comando por defecto para iniciar el servidor
CMD ["./hlds_run", "-game", "cstrike", "+maxplayers", "10", "+map", "de_dust2", "-port", "27021"]