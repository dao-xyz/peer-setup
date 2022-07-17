#!/bin/bash -e

# Docker
sudo sh ./setup-docker.sh

# IPFS and NGINX
sudo sh ./setup-ipfs.sh

# Start Shorbit
echo "Starting client"
sudo docker run -d --name=post-peer --net=host daoxyz/social-peer
echo "--- Completed ---"
echo "" 
echo "Go to:"
echo "$domain"
echo "To learn more about your peer!"
echo "" 
echo "-----------------"