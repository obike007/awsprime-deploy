# FROM ubuntu
# WORKDIR /var/www/html

# RUN apt update && apt install apache2 systemd -y
# #RUN systemctl enable apache2 && systemctl restart apache2

# COPY index.html style.css /var/www/html/

# CMD ["tail", "-f", "/dev/null"]

FROM httpd:2.4
 
COPY index.html style.css /usr/local/apache2/htdocs/
