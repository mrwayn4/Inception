#!/bin/bash

echo "Starting vsftpd temporarily for initial setup..."
service vsftpd start

echo "Creating FTP user: $FTP_USER"
adduser --disabled-password --gecos "" "$FTP_USER"

echo "Setting password for user: $FTP_USER"
echo -e "$FTP_PASS\n$FTP_PASS" | passwd "$FTP_USER"

echo "Creating home directory for $FTP_USER at /home/$FTP_USER/ftp"
mkdir -p /home/$FTP_USER/ftp
chown -R "$FTP_USER:$FTP_USER" /home/$FTP_USER/ftp

echo "Adding $FTP_USER to /etc/vsftpd.userlist"
echo "$FTP_USER" >> /etc/vsftpd.userlist

echo "Configuring vsftpd..."
cat << EOF >> /etc/vsftpd.conf
# Basic settings
anonymous_enable=NO
local_enable=YES
write_enable=YES
allow_writeable_chroot=YES

# User configuration
user_sub_token=$FTP_USER
local_root=/home/$FTP_USER/ftp

# Passive mode settings
pasv_enable=YES
pasv_min_port=21100
pasv_max_port=21100

# User access control
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO
EOF

echo "Stopping temporary vsftpd service..."
service vsftpd stop

echo "Starting vsftpd with the final configuration..."
exec vsftpd