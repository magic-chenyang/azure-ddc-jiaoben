#!/bin/bash

apt-get remove -y docker docker-engine
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
docker -v
echo "DOCKER_OPTS=\"\$DOCKER_OPTS --registry-mirror=https://24z731hs.mirror.aliyuncs.com\"" | sudo tee -a /etc/default/docker
service docker restart
docker run hello-world
docker -v
#wget https://download.docker.com/linux/ubuntu/dists/trusty/pool/stable/amd64/docker-ce_17.03.1~ce-0~ubuntu-trusty_amd64.deb
#sudo dpkg -i docker-ce_17.03.1~ce-0~ubuntu-trusty_amd64.deb
