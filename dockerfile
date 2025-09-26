# Usa la imagen base oficial de n8n
FROM n8nio/n8n:latest

# --- INICIO DE SECCIÓN CRÍTICA DE INSTALACIÓN ---
# Cambia temporalmente al usuario root para instalar yt-dlp y ffmpeg
USER root

# Actualiza la lista de paquetes e instala ffmpeg, Python y yt-dlp
# FFmpeg es necesario para muchos procesos de video/audio que yt-dlp puede requerir.
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-pip \
    && pip3 install yt-dlp

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
