#!/bin/bash

# Configura usuário e senha se fornecidos
if [ -n "$WEBDAV_USERNAME" ] && [ -n "$WEBDAV_PASSWORD" ]; then
    htpasswd -cb /etc/apache2/webdav.password "$WEBDAV_USERNAME" "$WEBDAV_PASSWORD"
    chown www-data:www-data /etc/apache2/webdav.password
    chmod 640 /etc/apache2/webdav.password
fi

# Substitui variáveis no arquivo de configuração
envsubst < /etc/apache2/sites-available/webdav.conf > /etc/apache2/sites-available/webdav.conf.tmp && \
mv /etc/apache2/sites-available/webdav.conf.tmp /etc/apache2/sites-available/webdav.conf

# Executa o comando principal
exec "$@"
