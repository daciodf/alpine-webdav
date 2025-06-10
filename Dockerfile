# Use a imagem base do Debian 12
FROM debian:bookworm-slim

# Variáveis de ambiente para configuração
ENV WEBDAV_USERNAME=admin
ENV WEBDAV_PASSWORD=password
ENV WEBDAV_PORT=80

# Instala dependências
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apache2 \
    apache2-utils \
    && rm -rf /var/lib/apt/lists/*

# Configura o Apache para WebDAV
RUN a2enmod dav && \
    a2enmod dav_fs && \
    a2enmod auth_digest && \
    a2enmod authn_core && \
    a2enmod auth_basic && \
    a2enmod authz_user

# Cria diretório para dados WebDAV
RUN mkdir -p /var/www/webdav && \
    chown -R www-data:www-data /var/www/webdav && \
    mkdir -p /media && \
    chown -R www-data:www-data /media

# Configuração do VirtualHost
COPY webdav.conf /etc/apache2/sites-available/webdav.conf
RUN a2dissite 000-default && \
    a2ensite webdav

# Script para configurar usuário/senha
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expõe a porta do WebDAV
EXPOSE ${WEBDAV_PORT}

# Ponto de montagem para dados persistentes
VOLUME ["/var/www/webdav", "/media"]

# Comando de inicialização
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"]
