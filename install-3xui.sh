#!/bin/bash

# ============================================
# Instalador 3X-UI Panel Web
# ============================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           🌐 INSTALADOR 3X-UI PANEL WEB 🌐"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${NC}"

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Este script debe ejecutarse como root${NC}"
    exit 1
fi

# Instalar 3X-UI
echo -e "${YELLOW}📦 Instalando 3X-UI...${NC}"
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)

echo ""
echo -e "${GREEN}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    ✅ INSTALACIÓN COMPLETADA ✅"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${NC}"
echo ""
echo -e "${YELLOW}📋 COMANDOS ÚTILES:${NC}"
echo ""
echo -e "${GREEN}x-ui${NC}              - Menú de administración"
echo -e "${GREEN}x-ui restart${NC}      - Reiniciar panel"
echo -e "${GREEN}x-ui status${NC}       - Ver estado"
echo -e "${GREEN}x-ui settings${NC}     - Ver configuración"
echo ""
echo -e "${CYAN}🌐 Accede al panel web desde tu navegador${NC}"
echo ""
