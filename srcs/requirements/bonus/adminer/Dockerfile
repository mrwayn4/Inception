FROM debian:bullseye

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y wget php php-mysql -y && \
    mkdir -p /var/www/html && \
    wget -O /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]