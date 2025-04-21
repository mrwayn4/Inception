FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y \
	&& apt-get install -y redis

ENTRYPOINT [ "redis-server", "--protected-mode", "no", 			\
							 "--maxmemory", "256mb", 			\
							 "--maxmemory-policy", "allkeys-lru" ]