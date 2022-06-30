#!/bin/bash

sudo apt-get -y install jq
ipv4=$(dig @resolver4.opendns.com myip.opendns.com +short)
domain=$(curl -X POST "https://bfbbnhwpfj2ptcmurz6lit4xlu0vjajw.lambda-url.us-east-1.on.aws" \
   -H "Content-Type: application/json" \
   -d '"'$ipv4'"' | jq -r '.domain') 

mkdir user_conf.d && cp nginxtempl.conf user_conf.d/default.conf
echo "" > user_conf.d/default.conf.original
sed -i user_conf.d/default.conf.original  -e 's/%DOMAIN%/'$domain'/g' user_conf.d/default.conf

# IPFS
export ipfs_staging=$(pwd)/ipfs/staging
export ipfs_data=$(pwd)/ipfs/data
sudo docker run -d --name ipfs_host -e IPFS_PROFILE=server -v $ipfs_staging:/export -v $ipfs_data:/data/ipfs -p 4001:4001 -p 127.0.0.1:8080:8080 -p 127.0.0.1:5001:5001 ipfs/go-ipfs:latest --enable-pubsub-experiment
docker_ipfs_ip=$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ipfs_host)
sed -i user_conf.d/default.conf.original  -e 's/%IPFS_IP%/'$docker_ipfs_ip'/g' user_conf.d/default.conf

rm user_conf.d/default.conf.original

# Start NGINX
sudo docker run -d -p 80:80 -p 443:443 -p 4002:4002 \
    --env CERTBOT_EMAIL=marcus@dao.xyz \
    -v $(pwd)/nginx_secrets:/etc/letsencrypt \
    -v $(pwd)/user_conf.d:/etc/nginx/user_conf.d:ro \
    --name nginx-certbot jonasal/nginx-certbot:latest


echo "Setup complete"
echo "Peer is now live with domain"
echo $domain


c7a6e70a2b0cbc04fa9942026f32d62de7a171e5.peerchecker.com