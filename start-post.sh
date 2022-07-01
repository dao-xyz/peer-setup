#!/bin/bash -e

# Docker
sudo sh ./setup-docker.sh

# IPFS and NGINX
sudo sh ./setup-ipfs.sh

# Start Shorbit
echo "Starting client"
#-p 4001:4003 -p 4001:4003/udp -p 127.0.0.1:8080:8080 -p 127.0.0.1:5001:5001
docker_ipfs_ip=$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs_host)
sudo docker run -d --name post-peer daoxyz/social-peer 
echo "--- Completed ---"