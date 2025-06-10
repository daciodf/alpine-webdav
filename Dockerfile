# Usa a imagem oficial do Alpine Linux
FROM alpine:latest

# Instala pacotes necessários
RUN apk add --no-cache \
    apache2 \
    apache2-ssl \
    apache2-utils \
    apache2-webdav \
    openssl \
    && mkdir -p /run/apache2 \
    && mkdir -p /var/www/localhost/htdocs \
    && mkdir -p /media \
    && chown -R apache:apache /media

# Criação do usuário WebDAV com variáveis de ambiente
ENV WEBDAV_USER=admin
ENV WEBDAV_PASS=password

RUN htpasswd -bc /etc/apache2/webdav.password "$WEBDAV_USER" "$WEBDAV_PASS"

# Configuração do Apache com WebDAV e SSL
RUN echo "
ServerName localhost
LoadModule dav_module modules/mod_dav.so
LoadModule dav_fs_module modules/mod_dav_fs.so
LoadModule auth_digest_module modules/mod_auth_digest.so

<VirtualHost *:443>
    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/server.crt
    SSLCertificateKeyFile /etc/apache2/ssl/server.key
    DocumentRoot /var/www/localhost/htdocs

    Alias /webdav /media
    <Directory /media>
        Dav On
        AuthType Basic
        AuthName \"WebDAV Secure Server\"
        AuthUserFile /etc/apache2/webdav.password
        Require valid-user
    </Directory>
</VirtualHost>
" > /etc/apache2/httpd.conf

# Gera certificado SSL autoassinado
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/apache2/ssl/server.key \
    -out /etc/apache2/ssl/server.crt \
    -subj \"/C=US/ST=State/L=City/O=Organization/OU=IT Department/CN=localhost\"

# Exposição da porta HTTPS
EXPOSE 443

# Comando de inicialização
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

