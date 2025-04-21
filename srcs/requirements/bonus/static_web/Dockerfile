FROM debian:bullseye

RUN apt-get update && apt-get install -y php curl

COPY tools/index.html /var/www/html/index.html
COPY tools/style.css /var/www/html/css/style.css

ENTRYPOINT ["php", "-S", "0.0.0.0:8000", "-t", "/var/www/html/"]