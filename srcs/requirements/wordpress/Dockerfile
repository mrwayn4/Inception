FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl git wget php php7.4-fpm \
    php-mysql mariadb-client

COPY  conf/wordpress.sh /

RUN chmod +x wordpress.sh

ENTRYPOINT [ "./wordpress.sh" ]