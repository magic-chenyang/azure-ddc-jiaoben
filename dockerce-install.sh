#!/bin/bash
sudo su -
apt-get remove docker docker-engine
apt-get update
apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
docker run hello-world
docker -v
#wget https://download.docker.com/linux/ubuntu/dists/trusty/pool/stable/amd64/docker-ce_17.03.1~ce-0~ubuntu-trusty_amd64.deb
#sudo dpkg -i docker-ce_17.03.1~ce-0~ubuntu-trusty_amd64.deb
