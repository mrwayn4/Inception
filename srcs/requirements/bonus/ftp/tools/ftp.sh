#!/bin/bash

echo "Starting vsftpd temporarily for initial setup..."
service vsftpd start

echo "Creating FTP user: $FTP_USER"
adduser --disabled-password --gecos "" "$FTP_USER"

echo "Setting password for user: $FTP_USER"
echo -e "$FTP_PASS\n$FTP_PASS" | passwd "$FTP_USER"

echo "Creating home directory for $FTP_USER at $FTP_HOME_DIR"
mkdir -p $FTP_HOME_DIR
chown -R "$FTP_USER:$FTP_USER" $FTP_HOME_DIR

echo "Adding $FTP_USER to /etc/vsftpd.userlist"
if ! grep -q "$FTP_USER" /etc/vsftpd.userlist; then
    echo "$FTP_USER" >> /etc/vsftpd.userlist
fi

echo "Configuring vsftpd..."
cat << EOF >> /etc/vsftpd.conf
# Basic settings
anonymous_enable=NO
local_enable=YES
write_enable=YES
allow_writeable_chroot=YES

# User configuration
local_root=$FTP_HOME_DIR

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