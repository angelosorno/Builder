#!/bin/bash

#!/bin/bash

# Verificar si el demonio de Docker está activo
if ! docker info > /dev/null 2>&1; then
    echo "Docker no está corriendo. Por favor, inicia Docker antes de ejecutar este script."
    exit 1
fi

# Resto del script de restauración...


# Ruta a la carpeta donde están los backups
BACKUP_DIR="./data/volumes_backup"

# Verificar si la carpeta de backups existe
if [ ! -d "$BACKUP_DIR" ]; then
    echo "No se encontró la carpeta $BACKUP_DIR con los volúmenes respaldados."
    exit 1
fi

# Nombres de los volúmenes a restaurar (basado en los nombres de los archivos tar.gz)
VOLUMES=$(ls $BACKUP_DIR/*.tar.gz | xargs -n 1 basename | sed 's/.tar.gz//')

# Restaurar cada volumen
for volume in $VOLUMES; do
    echo "Restaurando el volumen: $volume"
    
    # Crear el volumen en Docker
    docker volume create $volume
    
    # Verificar si la creación fue exitosa
    if [ $? -ne 0 ]; then
        echo "Error al crear el volumen $volume"
        exit 1
    fi
    
    # Descomprimir el backup en el volumen correspondiente
    docker run --rm -v ${volume}:/data -v $(pwd)/$BACKUP_DIR:/backup busybox tar xzf /backup/${volume}.tar.gz -C /data
    if [ $? -eq 0 ]; then
        echo "Volumen $volume restaurado correctamente."
    else
        echo "Error al restaurar el volumen $volume"
    fi
done

echo "Todos los volúmenes han sido restaurados."
