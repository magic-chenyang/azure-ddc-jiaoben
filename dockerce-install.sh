#!/bin/bash

sudo apt-get purge docker-ce -y 
sudo rm -rf /var/lib/docker
sudo apt-get update
sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo echo "DOCKER_OPTS=\"\$DOCKER_OPTS --registry-mirror=https://24z731hs.mirror.aliyuncs.com\"" | sudo tee -a /etc/default/docker
sudo service docker restart
sudo docker run hello-world
sudo docker -v
#sudo apt-get install -y expect
#sudo expect <<EOF
#set timeout 300
#spawn docker run --rm -it --name ucp   -v /var/run/docker.sock:/var/run/docker.sock   docker/ucp:2.1.2 install  --host-address 10.1.0.4 --admin-username yangchen --admin-password yangchen --san 42.159.113.167 --interactive
#expect "Additional aliases:"
#send "\n"
#expect eof
#EOF

i=`hostname`|awk -F 0 `{print$2}`
a=$(ifconfig eth0 | grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}')
do
	if [ i -eq 1 ];
	then
	sudo apt-get install -y expect
sudo expect <<EOF
set timeout 300
spawn docker run --rm -it --name ucp   -v /var/run/docker.sock:/var/run/docker.sock   docker/ucp:2.1.2 install  --host-address 10.1.0.4 --admin-username yangchen --admin-password yangchen --san 42.159.113.167 --interactive
expect "Additional aliases:"
send "\n"
expect eof
EOF
		sudo apt-get update
		sudo apt-get install -y nfs-kernel-server
		sudo docker swarm join-token worker|awk 'NR>2{print$0}' > /opt/worker.sh
		sudo docker swarm join-token manager|awk 'NR>2{print$0}' > /opt/manager.sh
		sudo tee /etc/exports <<-'EOF' 
/opt/ *(rw,sync,no_root_squash,no_subtree_check)
EOF
		sudo rpc.mountd
		sudo service nfs-kernel-server restart

	elif [ i -le 3 ];
	then
		if [ i -ge 2 ];
		then
		sudo apt-get install -y nfs-common
		sudo mount -t nfs DDC-01:/opt /opt 
		sudo bash /opt/manager.sh
		fi
	elif [ i -eq 4 ];
	then
		sudo apt-get install nfs-common
		sudo mount -t nfs DDC-01:/opt /opt 
		sudo bash /opt/worker.sh
		sudo docker run -it --rm docker/dtr install \
  		--dtr-external-url https://$a \
  		--ucp-node $hostname \
  		--ucp-username $ucp_admin_username \
		--ucp-password $ucp_admin_password \
  		--ucp-insecure-tls \
  		--ucp-url https://$controller_slb_ip  \
	elif [ i -ge 5 ];
	then
		if [ i -le 6 ];
		then
		sudo apt-get install nfs-common
		sudo mount -t nfs DDC-01:/opt /opt 
		sudo bash /opt/worker.sh

		sudo docker run -it --rm docker/dtr join \
  		--dtr-external-url https://$a \
		--existing-replica-id ### \
  		--ucp-node $hostname \
  		--ucp-username $ucp_admin_username \
		--ucp-password $ucp_admin_password \
  		--ucp-insecure-tls \
  		--ucp-url https://$controller_slb_ip  \
		fi
	fi
done
