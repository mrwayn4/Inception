FROM debian:bullseye

RUN apt update -y && apt-get upgrade -y vsftpd && \
    apt-get install ftp -y && apt-get install vsftpd -y 

COPY /tools/ftp.sh /ftp.sh

ENTRYPOINT [ "bash", "./ftp.sh" ]