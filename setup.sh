#!/bin/bash
# Setup script for bt-joly, using Jellyfin via Docker. Runs through full install from a fresh container or VM.

# Updates, upgrades, software
echo "============================================================================="
echo "Updating, upgrading, and installing stuff."
echo "============================================================================="
apt update -y && apt upgrade -y
apt install cifs-utils docker-compose -y

# Set hostname
echo "============================================================================="
echo "Setting hostname."
echo "============================================================================="
read -pr "Set hostname:" hostName
hostname "$hostName"

# Create local directories
echo "============================================================================="
echo "Creating directories, setting SMB credentials."
echo "============================================================================="
mkdir /mnt/mount1 && chmod 777 /mnt/mount1
mkdir /mnt/mount2 && chmod 777 /mnt/mount2

# Get credentials from user - media
echo "Credentials for media directory"
read -pr "SMB username:" SMBUSER
read -pr "SMB password:" SMBPW

# Create credential file - media
cat <<EOF > /etc/.cred
username=$SMBUSER
password=$SMBPW
EOF

# Get credentials from user - config
echo "Credentials for server data." 
read -pr "SMB username:" SMBUSER2
read -pr "SMB password:" SMBPW2

# Create credential file - config
cat <<EOF > /etc/.cred2
username=$SMBUSER2
password=$SMBPW2
EOF

#set permissions on credential files
chmod 600 /etc/.cred
chmod 600 /etc/.cred2

#fstab entries
read -pr "SMB server address? (ex. 10.10.10.100) :" smbSrv
read -pr "Media share name:" mdShr
read -pr "Server data name:" sdShr
cat <<EOF > /etc/fstab
//$smbSrv/$mdShr /mnt/mount1 cifs credentials=/etc/.cred,uid=1000,gid=1000 0 0 #
//$smbSrv/$sdShr /mnt/mount2 cifs credentials=/etc/.cred2,uid=1000,gid=1000 0 0 #
EOF

#Mount drive(s)
echo "============================================================================="
echo "Mounting drives."
echo "============================================================================="
mount -a

# Get compose
echo "============================================================================="
echo "Retreiving docker-compose from public repo."
echo "============================================================================="
wget -P /srv "https://raw.githubusercontent.com/btpaulie/autojellydocker/refs/heads/main/docker-compose.yml"

# Copy config (create this structure manually first)
echo "============================================================================="
echo "Pulling config from server (must be created first /mnt/<mountpoint>/<hostname>/config"
echo "============================================================================="
cp -r /mnt/mount2/"$hostName"/config /srv

# run docker
echo "============================================================================="
echo "Starting container."
echo "============================================================================="
docker-compose up -d

#cronjob
echo "0,15,30,45 * * * * cp -r /srv/config /mnt/mount2/\"$hostName\"" >> /etc/cron.d/configbu
