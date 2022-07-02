#!/bin/bash -e

# Docker
sudo sh ./setup-docker.sh

# IPFS and NGINX
sudo sh ./setup-ipfs.sh

# Start Shorbit
echo "Starting client"
#-p 4001:4003 -p 4001:4003/udp -p 127.0.0.1:8080:8080 -p 127.0.0.1:5001:5001
sudo docker run -d --name=post-peer --net=host daoxyz/social-peer
echo "--- Completed ---"