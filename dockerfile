# Usa la imagen base oficial de n8n
FROM n8nio/n8n:latest

# --- INICIO DE SECCIÓN CRÍTICA DE INSTALACIÓN ---
# Cambia temporalmente al usuario root para instalar yt-dlp y ffmpeg
USER root

# PASO 1: Instala las herramientas básicas y dependencias de Python (ffmpeg, python3, pip, y python3-dev)
# Es crucial tener python3-dev para que pip pueda compilar las dependencias de yt-dlp.
RUN apk add --no-cache ffmpeg python3 py3-pip python3-dev

# PASO 2: Instala yt-dlp y limpia el entorno
# Separamos la instalación de pip3 en un comando RUN diferente para resolver conflictos.
# Eliminamos los paquetes de desarrollo después de usarlos para reducir el tamaño final de la imagen.
RUN pip3 install yt-dlp \
    && apk del python3-dev

# --- FIN DE SECCIÓN CRÍTICA DE INSTALACIÓN ---

# Configuración estándar de Render/n8n para el volumen de datos:
# Crea el directorio /data (si no existe) y asigna la propiedad al usuario 'node'
RUN mkdir -p /data && chown -R node:node /data

# Vuelve al usuario 'node', recomendado para ejecutar la aplicación de forma segura
USER node

# Declara /data como un volumen persistente
VOLUME /data

# Expone el puerto 8080, que es donde n8n se ejecuta por defecto
EXPOSE 8080
