#!/bin/bash
sudo apt-get -y install jq
ipv4=$(dig @resolver4.opendns.com myip.opendns.com +short)
export domain=$(curl -X POST "https://bfbbnhwpfj2ptcmurz6lit4xlu0vjajw.lambda-url.us-east-1.on.aws" \
   -H "Content-Type: application/json" \
   -d '"'$ipv4'"' | jq -r '.domain') 

if [ -z "$domain" ] ; then
  echo "Failed to obtain domain name"
  exit 1
fi

mkdir -p user_conf.d && cp nginx-template.conf user_conf.d/default.conf
echo "" > user_conf.d/default.conf.original
sed -i user_conf.d/default.conf.original  -e 's/%DOMAIN%/'$domain'/g' user_conf.d/default.conf

# IPFS
export ipfs_staging=$(pwd)/ipfs/staging
export ipfs_data=$(pwd)/ipfs/data
sudo docker run -d --name ipfs_host -v $ipfs_staging:/export -v $ipfs_data:/data/ipfs -e IPFS_PROFILE=server --net=host ipfs/go-ipfs:latest daemon --enable-pubsub-experiment --migrate --routing=none
sleep 10s
sudo docker exec ipfs_host ipfs bootstrap rm --all
#sudo docker exec ipfs_host ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
sudo docker exec ipfs_host ipfs config Addresses.Swarm '["/ip4/0.0.0.0/tcp/4001", "/ip4/0.0.0.0/tcp/8081/ws", "/ip6/::/tcp/4001"]' --json
sudo docker exec ipfs_host ipfs config Discovery.MDNS '{
      "Enabled": false
    }' --json
export ipfs_id=$(sudo docker exec ipfs_host ipfs id | jq -r ".ID") 
sudo docker stop ipfs_host
sudo docker start ipfs_host

sed -i user_conf.d/default.conf.original  -e 's/%IPFS_ID%/'$ipfs_id'/g' user_conf.d/default.conf

# rm original conf of nginx before starting (to prevent it from beeing used)
rm user_conf.d/default.conf.original

# Start NGINX
sudo docker run -d --net=host \
    --env CERTBOT_EMAIL=marcus@dao.xyz \
    -v $(pwd)/nginx_secrets:/etc/letsencrypt \
    -v $(pwd)/user_conf.d:/etc/nginx/user_conf.d:ro \
    --name nginx-certbot jonasal/nginx-certbot:latest

echo "Setup complete"
echo "Peer is now live with domain"
echo $domain