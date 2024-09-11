#!/bin/bash

# Verificar si openssl está instalado
if ! command -v openssl &> /dev/null; then
    echo "openssl no está instalado. Instalando openssl..."
    sudo apt-get update
    sudo apt-get install openssl -y
fi

# Verificar si el archivo .env existe
if [ ! -f .env ]; then
    echo "El archivo .env no existe. Por favor, crea o copia uno primero."
    exit 1
fi

# Función para generar una cadena aleatoria de una longitud específica
generate_random_string() {
    openssl rand -hex 16
}

# Reemplazar claves secretas con nuevas cadenas aleatorias, excepto BB_ADMIN_USER_EMAIL y BB_ADMIN_USER_PASSWORD
sed -i "s/^API_ENCRYPTION_KEY=.*/API_ENCRYPTION_KEY=$(generate_random_string)/" .env
sed -i "s/^JWT_SECRET=.*/JWT_SECRET=$(generate_random_string)/" .env
sed -i "s/^MINIO_ACCESS_KEY=.*/MINIO_ACCESS_KEY=$(generate_random_string | cut -c1-20)/" .env
sed -i "s/^MINIO_SECRET_KEY=.*/MINIO_SECRET_KEY=$(generate_random_string | cut -c1-32)/" .env
sed -i "s/^COUCH_DB_PASSWORD=.*/COUCH_DB_PASSWORD=$(generate_random_string)/" .env
sed -i "s/^REDIS_PASSWORD=.*/REDIS_PASSWORD=$(generate_random_string)/" .env
sed -i "s/^INTERNAL_API_KEY=.*/INTERNAL_API_KEY=$(generate_random_string)/" .env

# Confirmar que las contraseñas han sido modificadas
echo "Las claves secretas del archivo .env han sido actualizadas con nuevas contraseñas aleatorias."
echo "Las credenciales del administrador no han sido modificadas."
