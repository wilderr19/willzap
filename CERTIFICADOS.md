# 🔐 Guía de Instalación de Certificados TLS

## 📋 Requisitos Previos

- Dominio apuntando a tu VPS (registro A en DNS)
- Puerto 80 libre (detener nginx/apache si están corriendo)
- Acceso root a la VPS

---

## 🚀 Instalación Paso a Paso

### **1. Instalar acme.sh**

```bash
curl https://get.acme.sh | sh
source ~/.bashrc
```

### **2. Registrar tu Email**

```bash
~/.acme.sh/acme.sh --register-account -m tuemail@ejemplo.com
```

### **3. Detener Servicios en Puerto 80**

```bash
systemctl stop nginx 2>/dev/null
systemctl stop apache2 2>/dev/null
```

### **4. Obtener Certificado**

```bash
# Detener cualquier servicio en puerto 80
systemctl stop nginx 2>/dev/null
systemctl stop apache2 2>/dev/null
pkill -9 -f "python.*8080" 2>/dev/null

# Esperar
sleep 5

# Generar certificado con Let's Encrypt
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --issue -d tudominio.com --standalone --force

# Reemplaza "tudominio.com" con tu dominio real
# Ejemplo: ~/.acme.sh/acme.sh --issue -d vip.winzapg.online --standalone --force
```

### **5. Verificar Certificados**

```bash
# Buscar tu dominio
ls -la ~/.acme.sh/ | grep canalx.winzapg.online

# Ver archivos del certificado
ls -la ~/.acme.sh/ls canalx.winzapg.online_ecc/
```

Deberías ver:
- `fullchain.cer` - Certificado público
- `tudominio.com.key` - Clave privada
- `ca.cer` - Certificado CA

---

## 🌐 Configurar en 3X-UI

### **1. Abrir Panel Web**

```bash
# Ver URL de acceso
x-ui settings
```

### **2. Crear/Editar Entrada**

1. Ve a **"Entradas"** (Inbounds)
2. Clic en **"+ Agregar Entrada"** o edita una existente
3. Configura:
   - **Puerto**: 443
   - **Protocolo**: VLESS
   - **Red**: WebSocket
   - **Seguridad**: TLS

### **3. Configurar Certificados**

En la sección **"Certificado Digital"**:

**Opción: Ruta Cert**

```
Clave Pública:
/root/.acme.sh/tudominio.com_ecc/fullchain.cer

Clave Privada:
/root/.acme.sh/tudominio.com_ecc/tudominio.com.key
```

### **4. Guardar y Reiniciar**

```bash
x-ui restart
```

### **5. Verificar Puerto**

```bash
ss -tulpn | grep 443
```

Deberías ver:
```
tcp     LISTEN   0        4096                   *:443                  *:*      users:(("xray",pid=XXXX,fd=X))
```

---

## 🔄 Renovación Automática

Los certificados se renuevan automáticamente cada 90 días.

**Verificar cron job:**
```bash
crontab -l | grep acme
```

**Renovar manualmente (opcional):**
```bash
~/.acme.sh/acme.sh --renew -d tudominio.com --force
x-ui restart
```

---

## 📝 Notas Importantes

### **Mismo Dominio en Múltiples Puertos**

Si usas el mismo dominio en varios puertos, usa las mismas rutas:

```
Puerto 443: /root/.acme.sh/tudominio.com_ecc/fullchain.cer
Puerto 8443: /root/.acme.sh/tudominio.com_ecc/fullchain.cer
Puerto 2096: /root/.acme.sh/tudominio.com_ecc/fullchain.cer
```

### **Múltiples Dominios**

Para cada dominio diferente, crea un certificado nuevo:

```bash
~/.acme.sh/acme.sh --issue -d dominio1.com --standalone
~/.acme.sh/acme.sh --issue -d dominio2.com --standalone
```

Cada uno tendrá su propia ruta:
```
/root/.acme.sh/dominio1.com_ecc/
/root/.acme.sh/dominio2.com_ecc/
```

---

## ⚠️ Solución de Problemas

### **Error: Puerto 80 ocupado**

```bash
# Ver qué usa el puerto 80
ss -tulpn | grep :80

# Detener el servicio
systemctl stop nginx
systemctl stop apache2
```

### **Error: Dominio no apunta a la VPS**

Verifica tu DNS:
```bash
# Verificar IP del dominio
nslookup tudominio.com

# Debe mostrar la IP de tu VPS
```

### **Error: Certificado no se carga**

```bash
# Verificar permisos
ls -la ~/.acme.sh/tudominio.com_ecc/

# Verificar que existan los archivos
cat ~/.acme.sh/tudominio.com_ecc/fullchain.cer
```

### **Ver logs de 3X-UI**

```bash
x-ui log
```

---

## 📋 Resumen Rápido

```bash
# 1. Instalar acme.sh
curl https://get.acme.sh | sh && source ~/.bashrc

# 2. Registrar email
~/.acme.sh/acme.sh --register-account -m tuemail@ejemplo.com

# 3. Detener servicios
systemctl stop nginx 2>/dev/null
systemctl stop apache2 2>/dev/null
pkill -9 -f "python.*8080" 2>/dev/null
sleep 5

# 4. Obtener certificado con Let's Encrypt
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --issue -d tudominio.com --standalone --force

# 5. Ver ubicación
ls -la ~/.acme.sh/tudominio.com_ecc/

# 6. Configurar en panel web:
# Certificado: /root/.acme.sh/tudominio.com_ecc/fullchain.cer
# Clave: /root/.acme.sh/tudominio.com_ecc/tudominio.com.key

# 7. Reiniciar
x-ui restart
```

---

## 🎯 Ejemplo Completo

```bash
# Dominio: vip.winzapg.online
# VPS IP: 102.129.137.225

# 1. Instalar acme.sh
curl https://get.acme.sh | sh
source ~/.bashrc

# 2. Registrar
~/.acme.sh/acme.sh --register-account -m admin@winzapg.online

# 3. Obtener certificado
systemctl stop nginx 2>/dev/null
systemctl stop apache2 2>/dev/null
pkill -9 -f "python.*8080" 2>/dev/null
sleep 5
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --issue -d vip.winzapg.online --standalone --force

# 4. Verificar
ls -la ~/.acme.sh/vip.winzapg.online_ecc/

# 5. En el panel web usar:
# /root/.acme.sh/vip.winzapg.online_ecc/fullchain.cer
# /root/.acme.sh/vip.winzapg.online_ecc/vip.winzapg.online.key

# 6. Reiniciar
x-ui restart

# 7. Verificar
ss -tulpn | grep 443
```

---

**✅ Los certificados se renovarán automáticamente cada 90 días**
