#!/bin/sh

# Configura usuário e senha
if [ ! -f "/etc/apache2/webdav.password" ]; then
    htpasswd -bc /etc/apache2/webdav.password "${USERNAME}" "${PASSWORD}"
else
    htpasswd -b /etc/apache2/webdav.password "${USERNAME}" "${PASSWORD}"
fi

# Gera certificado SSL se necessário
generate-ssl.sh

# Ajusta permissões
chown -R apache:apache /media

# Executa o comando principal
exec "$@"
