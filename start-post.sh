# IPFS and NGINX
./setup.sh

# Start Shorbit
sudo docker run -p 4001:4003 -p 4001:4003/udp -p 127.0.0.1:8080:8080 -p 127.0.0.1:5001:5001 daoxyz/social-peer