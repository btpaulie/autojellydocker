#!/bin/bash

cd /srv
touch backup.sh
cat <<EOF > /srv/backup.sh
cp -r /srv/config /mnt/mount2/
EOF

chmod +x /srv/backup.sh
./srv/backup.sh

