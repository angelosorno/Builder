#!/bin/bash

# Verificar si existe el archivo .env
if [ ! -f .env ]; then
    echo "El archivo .env no existe. Creando una copia de example.env como .env..."
    cp example.env .env
    echo "El archivo .env ha sido creado."

    # Ejecutar el script .RandomENV.sh para modificar el archivo .env con claves aleatorias
    echo "Ejecutando .RandomENV.sh para generar nuevas contraseñas..."
    ./.RandomENV.sh

else
    echo "El archivo .env ya existe."
fi

# Preguntar al usuario si ha configurado el archivo .env correctamente
read -p "¿Has configurado los valores correctos en el archivo .env? (S/N): " confirm

if [[ $confirm == "s" || $confirm == "S" ]]; then
    echo "Iniciando Docker Compose..."
    docker compose up -d
else
    echo "Es necesario editar el archivo .env antes de continuar."

    # Verificar si 'nano' está instalado
    if ! command -v nano &> /dev/null; then
        echo "El editor 'nano' no está instalado. Instalando 'nano'..."
        
        # Instalar 'nano' según el sistema operativo (esto asume un sistema basado en Debian/Ubuntu)
        sudo apt-get update
        sudo apt-get install nano -y
    fi

    # Preguntar al usuario si desea editar el archivo .env con nano
    read -p "¿Quieres editar el archivo .env ahora con el editor nano? (S/N): " edit_now

    if [[ $edit_now == "s" || $edit_now == "S" ]]; then
        echo "Abriendo el archivo .env con nano para su edición..."
        nano .env
        echo "Edición completada. Por favor, vuelve a ejecutar el script después de guardar los cambios."
    else
        echo "Es necesario editar el archivo .env para continuar. Por favor, edítalo manualmente y luego vuelve a ejecutar este script."
        exit 1
    fi
fi
