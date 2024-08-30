#!/bin/bash

# Verificar si existe el archivo .env
if [ ! -f .env ]; then
    echo "El archivo .env no existe. Creando una copia de example.env como .env..."
    cp example.env .env
    echo "El archivo .env ha sido creado."
else
    echo "El archivo .env ya existe."
fi

# Preguntar al usuario si ha configurado el archivo .env correctamente
read -p "¿Has configurado los valores correctos en el archivo .env? (s/n): " confirm

if [[ $confirm == "s" || $confirm == "S" ]]; then
    echo "Iniciando Docker Compose..."
    docker-compose up -d
else
    echo "Por favor, configura el archivo .env antes de iniciar Docker Compose."
    exit 1
fi
