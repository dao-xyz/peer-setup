# Startup commands

## Post node
Stores post data
```sh
wget https://github.com/dao-xyz/peer-setup/archive/master.tar.gz
tar -zxvf master.tar.gz
cd peer-setup-master
sudo sh ./start-post.sh
```

## User data node
*NOT LIVE*

Stores info about users
```sh
wget https://github.com/dao-xyz/peer-setup/archive/master.tar.gz
tar -zxvf master.tar.gz
cd peer-setup-master
sudo sh ./start-user.sh
```

## Trust/key chain node
*NOT LIVE*

Stores trust relationships between keys. 
"A trust B and B trust C". 
```sh
wget https://github.com/dao-xyz/peer-setup/archive/master.tar.gz
tar -zxvf master.tar.gz
cd peer-setup-master
sudo sh ./start-trust.sh
```