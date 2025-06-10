# Use Alpine Linux como imagem base
FROM alpine:latest

# Variáveis de ambiente para configuração
ENV USERNAME=webdav_user
ENV PASSWORD=webdav_pass
ENV SSL_CERT=/etc/ssl/certs/webdav.crt
ENV SSL_KEY=/etc/ssl/private/webdav.key
ENV PORT=443

# Instala os pacotes necessários
RUN apk add --no-cache \
    apache2 \
    apache2-utils \
    apache2-webdav \
    openssl \
    && mkdir -p /run/apache2 \
    && mkdir -p /media \
    && chown -R apache:apache /media

# Configuração do Apache
COPY webdav.conf /etc/apache2/conf.d/webdav.conf

# Script para gerar certificado autoassinado se não existir
COPY generate-ssl.sh /usr/local/bin/generate-ssl.sh
RUN chmod +x /usr/local/bin/generate-ssl.sh

# Expõe a porta HTTPS
EXPOSE ${PORT}

# Ponto de montagem para dados persistentes
VOLUME /media

# Script de entrada para configurar usuário/senha
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["httpd", "-D", "FOREGROUND"]
