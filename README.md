**README.md**

# Script de Instalación y Configuración de Servidor Debian

Este script automatiza la instalación y configuración de un servidor Debian con Docker, Portainer y una IP estática. Es ideal para usuarios que desean configurar rápidamente un entorno de desarrollo.

---

## Requisitos

- Debes tener acceso a una version reciente de Debian.
- Debes tener configurado con lo basico y actualizado el sistema.
- Ejecutar el script como usuario root o con privilegios de sudo.

---

## Pasos para Utilizar el Script

1. **Descargar el Script**  
   Guarda el script en tu servidor Debian opcional(utiliza ssh para que sea mas sensillo) :
   ```bash
   git clone https://github.com/ReneAraniva/ip-statica-Portainer.git
   ```

2. **Dar Permisos de Ejecución**  
   Asegúrate de que el script tenga permisos de ejecución:
   ```bash
   chmod +x portainer-setup.sh
   ```

3. **Ejecutar el Script**  
   Ejecuta el script como root:
   ```bash
   sudo ./portainer-setup.sh
   ```

4. **Verificar la Configuración**  
   Al finalizar, el script mostrará la dirección IP del servidor y la URL de acceso a Portainer.

---

## Notas

- El script realiza una copia de seguridad de la configuración de red original.
- Portainer estará disponible en `https://IP_DEL_SERVIDOR:9443`.

---


¡Disfruta de tu nuevo servidor configurado! 🚀

