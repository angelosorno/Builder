# 🚀 Despliegue de Aplicación con Docker Compose

¡Bienvenido! Este repositorio te permitirá desplegar tu aplicación utilizando **Docker Compose** de manera rápida y sencilla. 🌟

## 🛠️ Requisitos

Antes de comenzar, asegúrate de tener lo siguiente instalado en tu sistema:

- **Docker** 🐳
- **Docker Compose** 🧩

## 📋 Pasos para el Despliegue

1. **Clona el repositorio** en tu máquina local:

    ```bash
    git clone https://github.com/angelosorno/Builder
    cd Builder
    ```

2. **Copia el archivo `.env`** desde el archivo de ejemplo:

    ```bash
    cp example.env .env
    ```

3. **Edita el archivo `.env`** con los valores correctos. 📝

4. **Ejecuta el script de inicio** para verificar y arrancar el despliegue:

    ```bash
    ./Start.sh
    ```

    ⚠️ **IMPORTANTE:** El script te preguntará si has configurado correctamente los valores en el archivo `.env`. ¡Asegúrate de revisarlos antes de continuar! ✅

5. **Disfruta** de tu aplicación en funcionamiento. 🎉

## 🚨 Notas Importantes

- **Revisa** siempre los valores en tu archivo `.env` antes de ejecutar el despliegue.
- **Docker Compose** levantará los servicios en segundo plano. Puedes verificar el estado de los contenedores con:

    ```bash
    docker compose ps
    ```

- Si deseas detener todos los servicios, ejecuta:

    ```bash
    docker compose down
    ```

## 🧑‍💻 Contribuciones

¡Las contribuciones son bienvenidas! Si deseas mejorar este proyecto, no dudes en hacer un **fork** y enviarnos un **pull request**. 🙌

## 📄 Licencia

Este proyecto está bajo la licencia **MIT**. Consulta el archivo `LICENSE` para más detalles.
---

✨ **Gracias por usar este repositorio!** ✨