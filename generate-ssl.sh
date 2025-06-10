#!/bin/sh

SSL_KEY=/etc/ssl/private/webdav.key

if [ ! -f "${SSL_CERT}" ] || [ ! -f "${SSL_KEY}" ]; then
    echo "Generating self-signed certificate..."
    mkdir -p $(dirname ${SSL_CERT}) $(dirname ${SSL_KEY})
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
        -keyout ${SSL_KEY} -out ${SSL_CERT} \
        -subj "/C=US/ST=California/L=San Francisco/O=WebDAV/CN=webdav.local"
    chmod 400 ${SSL_KEY}
fi
