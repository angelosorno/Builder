# 🌉 Bridge SH Docker Deploy

¡Bienvenido! Este repositorio te permitirá desplegar **Bridge**, una aplicación de gestión de datos construida con [Budibase](https://budibase.com/), utilizando **Docker Compose** de manera rápida y sencilla. 🌟

## 📝 Que puedes hacer con Budibase

**Bridge** es una poderosa herramienta para la gestión y automatización de procesos internos en tu organización. Con **Bridge**, puedes:

- **Transformar Procesos Internos:** Optimiza y automatiza tareas clave para maximizar la eficiencia.
- **Gestionar y Unificar Datos:** Conecta diferentes fuentes de datos, incluyendo hojas de cálculo, bases de datos SQL y APIs REST, para centralizar la información en un solo lugar.
- **Construir Aplicaciones Personalizadas:** Utiliza una interfaz intuitiva de arrastrar y soltar para crear aplicaciones adaptadas a tus necesidades, sin necesidad de código, o añade lógica avanzada con JavaScript si lo prefieres.
- **Automatizar Flujos de Trabajo:** Crea automatizaciones complejas con condiciones y lógica avanzada, conectando con servicios externos y enviando notificaciones.
- **Escalar y Controlar:** Gestiona y escala tu aplicación dentro de la organización con control de acceso basado en roles, SSO gratuito, y características avanzadas de seguridad.

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

4. **Otorga permisos de ejecución** al script `.Start.sh`:

    ```bash
    chmod +x .Start.sh
    ```

5. **Ejecuta el script de inicio** para verificar y arrancar el despliegue:

    ```bash
    ./Start.sh
    ```

    ⚠️ **IMPORTANTE:** El script te preguntará si has configurado correctamente los valores en el archivo `.env`. ¡Asegúrate de revisarlos antes de continuar! ✅

6. **Disfruta** de **Bridge** en funcionamiento. 🎉

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

✨ **Gracias por usar Bridge!** ✨
