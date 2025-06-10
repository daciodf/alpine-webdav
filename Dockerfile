FROM alpine:latest

# Variáveis de ambiente não sensíveis
ENV USERNAME=webdav_user
ENV SSL_CERT=/etc/ssl/certs/webdav.crt
ENV PORT=443

# Instala os pacotes necessários (incluindo apache2-ssl)
RUN apk add --no-cache \
    apache2 \
    apache2-utils \
    apache2-webdav \
    apache2-ssl \
    openssl \
    && mkdir -p /run/apache2 \
    && mkdir -p /media \
    && chown -R apache:apache /media

# Configuração do Apache
COPY webdav.conf /etc/apache2/conf.d/webdav.conf

# Script para gerar certificado autoassinado
COPY generate-ssl.sh /usr/local/bin/generate-ssl.sh
RUN chmod +x /usr/local/bin/generate-ssl.sh

# Script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE ${PORT}
VOLUME /media

ENTRYPOINT ["/entrypoint.sh"]
CMD ["httpd", "-D", "FOREGROUND"]
