# debian-webdav

Servidor webdav leve e funcional com debian Linux 12

Construa a imagem

**docker build -t webdav-server .**

Execute o container

**docker run -d \\
  -p 80:80 \\
  -e WEBDAV_USERNAME=seuusuario \\
  -e WEBDAV_PASSWORD=suasenha \\
  -v /caminho/para/dados:/var/www/webdav \\
  --name webdav \\
  webdav-server**
