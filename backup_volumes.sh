#!/bin/bash


# Verificar si el demonio de Docker está activo
if ! docker info > /dev/null 2>&1; then
    echo "Docker no está corriendo. Por favor, inicia Docker antes de ejecutar este script."
    exit 1
fi

# Ruta al archivo compose.yml (asegúrate de estar en el mismo directorio que tu compose.yml)
COMPOSE_FILE="compose.yml"

# Extraer los nombres de los volúmenes definidos en el archivo compose.yml
VOLUMES=$(docker-compose -f $COMPOSE_FILE config | grep 'driver: local' -B 1 | grep 'volume:' | awk '{print $2}')

# Verificar si hay volúmenes listados
if [ -z "$VOLUMES" ]; then
    echo "No se encontraron volúmenes definidos en el archivo compose.yml"
    exit 1
fi

# Crear una carpeta para almacenar los backups
BACKUP_DIR="./data/volumes_backup"
mkdir -p $BACKUP_DIR

# Realizar un backup de cada volumen
for volume in $VOLUMES; do
    echo "Respaldo del volumen: $volume"
    
    # Verificar si el volumen existe en el sistema de Docker
    if docker volume inspect $volume > /dev/null 2>&1; then
        # Crear el backup del volumen en un archivo tar.gz
        docker run --rm -v ${volume}:/data -v $(pwd)/$BACKUP_DIR:/backup busybox tar czf /backup/${volume}.tar.gz -C /data .
        if [ $? -eq 0 ]; then
            echo "Volumen $volume respaldado correctamente en $BACKUP_DIR"
        else
            echo "Error al respaldar el volumen $volume"
        fi
    else
        echo "El volumen $volume no existe en el demonio Docker."
    fi
done

echo "Todos los volúmenes han sido respaldados en la carpeta $BACKUP_DIR"
