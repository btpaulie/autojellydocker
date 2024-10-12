# Autojellydocker

Scripts to automate the deployment of a Jellyfin media server in an environment with an SMB server housing media files and /config data in separate shares. This is intended for an Ubuntu 22.04 container. In this instance, the media directory user only has read permissions, while the server data user has read/write. 

## Prerequisites

`curl` (`apt install curl`)

## Installation

```
curl -O https://raw.githubusercontent.com/btpaulie/autojellydocker/refs/heads/main/setup.sh
```

```
chmod +x setup.sh && ./setup.sh
```


