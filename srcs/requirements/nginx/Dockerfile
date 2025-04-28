FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
     -subj "/C=MO/ST=KH/L=KH/O=1337/OU=1337/CN=ibouram.42.fr/UID=ibouram"

COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]