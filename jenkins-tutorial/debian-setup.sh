#!/bin/bash
set -e
# sudo -i
sudo apt update -y \
&& sudo apt upgrade -y \
&& sudo apt dist-upgrade -y
#su root  -c 'apt install sudo -y'

## Create our user

#sudo groupadd -r cryptoware
sudo useradd -m -s /bin/bash cryptoware
#sudo usermod -a -G cryptoware cryptoware
sudo cp /etc/sudoers /etc/sudoers.orig
# sudo usermod -a -G sudo cryptoware
sudo echo "cryptoware ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cryptoware

# Install go
#sudo wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz -O /tmp/go.tar.gz
sudo wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz -O /tmp/go.tar.gz
sudo tar -C /usr/local -xzf /tmp/go.tar.gz 
#sudo echo "export PATH=$PATH:/usr/local/go/bin" >> /home/cryptoware/.profile
#sudo chown cryptoware:cryptoware /home/cryptoware/.profile

sudo -H -i -u cryptoware -- env bash << EOF
whoami
echo ~cryptoware
cd /home/cryptoware
echo "export PATH=$PATH:/usr/local/go/bin" >> /home/cryptoware/.profile
EOF



# install postgresql
sudo apt install -y postgresql
sudo apt install -y unzip

# Centrifugo
sudo -H -i -u cryptoware -- env bash << EOF
cd /home/cryptoware
mkdir ~/temp
cd ~/temp

sudo apt install git -y
sudo apt install gcc g++ -y

wget https://github.com/centrifugal/centrifugo/releases/download/v1.8.0/centrifugo-1.8.0-linux-amd64.zip \
&& unzip centrifugo-1.8.0-linux-amd64.zip \
&& mkdir centrifugo \
&& mv centrifugo-1.8.0-linux-amd64/* centrifugo/

rm -R centrifugo-1.8.0-linux-amd64 \
&& rm centrifugo-1.8.0-linux-amd64.zip

sudo mkdir -p /opt/backenddir
sudo chown cryptoware /opt/backenddir/

mkdir -p /opt/backenddir/go-ibax
mkdir -p /opt/backenddir/go-ibax/node1
mkdir -p /opt/backenddir/centrifugo

mv ~/temp/centrifugo/centrifugo /opt/backenddir/centrifugo/
echo '{"secret":"CENT_SECRET"}' > /opt/backenddir/centrifugo/config.json

cd ~/temp
git clone https://github.com/IBAX-io/go-ibax.git
cd go-ibax

# This proxy is not stable.. so we are not going to use it.
# export GOPROXY=https://athens.azurefd.net
GO111MODULE=on go mod tidy -v
go build

cp ./go-ibax /opt/backenddir/go-ibax/


EOF
## change the password 
# echo '{"secret":"CENT_SECRET"}' >> /opt/backenddir/centrifugo/config.json

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '123456'"
sudo -u postgres psql -c "CREATE DATABASE chaindb"
# change config.toml ??

# Configure Centrifugo


