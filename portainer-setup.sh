#!/bin/bash 

# ========================================
#  Script de instalación y configuración
#  Servidor Debian con Docker + Portainer + IP Estática automática
#  By: Nazarhet
# ========================================

# --- Colores ---
verde="\e[32m"
azul="\e[34m"
amarillo="\e[33m"
rojo="\e[31m"
reset="\e[0m"

echo -e "${verde}🚀 Iniciando configuración del servidor...${reset}"

# ================================
# Comprobar si es root
# ================================
if [[ $EUID -ne 0 ]]; then
    echo -e "${rojo}❌ Debes ejecutar este script como root.${reset}"
    exit 1
fi

# ================================
# Actualizar el sistema
# ================================
apt update && apt upgrade -y

# ================================
# Instalar herramientas básicas
# ================================
apt install -y curl wget git unzip zip net-tools htop ufw openssh-server sudo ipcalc

# ================================
# Configuración SSH
# ================================
systemctl enable ssh
systemctl start ssh

# ================================
# Autodetectar y configurar IP estática
# ================================
echo -e "${azul}📌 Detectando y configurando IP estática...${reset}"

IP_ACTUAL=$(hostname -I | awk '{print $1}')
INTERFAZ=$(ip route | grep '^default' | awk '{print $5}')
GATEWAY=$(ip route | grep '^default' | awk '{print $3}')
MASCARA_CIDR=$(ip -o -f inet addr show $INTERFAZ | awk '{print $4}' | cut -d/ -f2)
MASCARA=$(ipcalc -m $IP_ACTUAL/$MASCARA_CIDR | cut -d= -f2)

echo -e "${amarillo}IP:${reset} $IP_ACTUAL"
echo -e "${amarillo}Interfaz:${reset} $INTERFAZ"
echo -e "${amarillo}Gateway:${reset} $GATEWAY"
echo -e "${amarillo}Máscara:${reset} $MASCARA"

# Backup configuración original
cp /etc/network/interfaces /etc/network/interfaces.bak

# Configuración nueva
cat > /etc/network/interfaces <<EOL
auto lo
iface lo inet loopback

auto $INTERFAZ
iface $INTERFAZ inet static
    address $IP_ACTUAL
    netmask $MASCARA
    gateway $GATEWAY
    dns-nameservers 8.8.8.8 1.1.1.1
EOL

systemctl restart networking
echo -e "${verde}✅ IP estática configurada.${reset}"

# ================================
# Mensaje de bienvenida
# ================================
clear
cat << "EOF"
___       __    ______                                 _____                                                  
__ |     / /_______  /__________________ ________      __  /______     ______________________   ______________
__ | /| / /_  _ \_  /_  ___/  __ \_  __ `__ \  _ \     _  __/  __ \    __  ___/  _ \_  ___/_ | / /  _ \_  ___/
__ |/ |/ / /  __/  / / /__ / /_/ /  / / / / /  __/     / /_ / /_/ /    _(__  )/  __/  /   __ |/ //  __/  /    
____/|__/  \___//_/  \___/ \____//_/ /_/ /_/\___/      \__/ \____/     /____/ \___//_/    _____/ \___//_/     
EOF
echo -e "${amarillo}Bienvenido. Servidor configurándose...${reset}"

# ================================
# Instalar Docker
# ================================
echo -e "${azul}🐳 Instalando Docker...${reset}"
curl -fsSL https://get.docker.com | sh
systemctl enable docker
systemctl start docker

# ================================
# Instalar Portainer
# ================================
echo -e "${azul}📦 Instalando Portainer...${reset}"
docker volume create portainer_data
docker run -d \
  -p 8000:8000 \
  -p 9443:9443 \
  --name=portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

# ================================
# Configuración firewall
# ================================
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 9443/tcp
ufw --force enable

# ================================
# Estructura de carpetas para web
# ================================
mkdir -p ~/servidor_web/{proyectos,scripts,backups}

# ================================
# Mensaje final
# ================================
clear
echo -e "${verde}✅ Configuración completa.${reset}"
echo -e "${azul}🌐 Portainer disponible en: https://$IP_ACTUAL:9443${reset}"
echo -e "${amarillo}💻 Proyectos web en: ~/servidor_web${reset}"
