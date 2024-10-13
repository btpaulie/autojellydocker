# Autojellydocker

Scripts to automate the deployment of a Jellyfin media server in an environment with an SMB server housing media files and /config data in separate shares. Tested on an Ubuntu 24.04 LXC. 

In my case, the media directory user only has read permissions, while the server data user has read/write. I run a cron job to push the `/srv/config` folder to the `mount2` directory nightly.  

## Prerequisites

- curl
```
apt install curl
```

## Installation

```
curl -O https://raw.githubusercontent.com/btpaulie/autojellydocker/refs/heads/main/setup.sh
```

```
chmod +x setup.sh && ./setup.sh
```

## To-do

- [ ] Make data pull optional
- [ ] Make script generate backup script & edit crontab

TEST