#!/bin/bash

echo "Setting up pre-requirements for bonnie"

apt_install () {
	if ! dpkg -s $1 >/dev/null 2>&1; then
		sudo apt install -y $1
	else
		echo "$1 already installed"
	fi
}

# APT package based requirements
sudo apt update

apt_install "git"
apt_install "apache2"
apt_install "apt-transport-https"
apt_install "ca-certificates"
apt_install "curl"
apt_install "gnupg-agent"
apt_install "software-properties-common"
apt_install "libcurl4-openssl-dev"
apt_install "apache2-dev"
apt_install "libapr1-dev"
apt_install "libaprutil1-dev"

if ! test -f "/etc/apt/sources.list.d/mongodb-org-3.4.list"; then
	# setup MongoDB repo. this command needs editing to run behind a proxy
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
	echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee "/etc/apt/sources.list.d/mongodb-org-3.4.list"
	sudo apt-get update
	sudo apt-get install -y mongodb-org=3.4.4 mongodb-org-server=3.4.4 mongodb-org-shell=3.4.4 mongodb-org-mongos=3.4.4 mongodb-org-tools=3.4.4
	
	# This should stop apt upgrade from updating these
	echo "mongodb-org hold" | sudo dpkg --set-selections &&
	echo "mongodb-org-server hold" | sudo dpkg --set-selections &&
	echo "mongodb-org-shell hold" | sudo dpkg --set-selections &&
	echo "mongodb-org-mongos hold" | sudo dpkg --set-selections &&
	echo "mongodb-org-tools hold" | sudo dpkg --set-selections
	sudo systemctl enable mongod.service
else
	echo "MongoDB is assumed to be installed already"
fi

if ! grep maxBSONDepth /etc/mongod.conf > /dev/null; then
	echo "MongoDB, adding to config file"
	echo "setParameter:" | sudo tee -a /etc/mongod.conf
	echo "  maxBSONDepth: 500" | sudo tee -a /etc/mongod.conf
	sudo service mongod restart
else
	echo "MongoDB does not need config additions"
fi

sudo service mongod start

# Install RVM
if ! which rvm >/dev/null 2>&1; then
	curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -
	curl -sSL https://rvm.io/pkuczynski.asc | sudo gpg --import -
	curl -sSL https://get.rvm.io | sudo bash -s stable
else
	echo "RVM already installed"
fi

# Install Docker
if ! dpkg -s docker-ce >/dev/null 2>&1; then
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io
else
	echo "Docker already installed"
fi

# Install Yarn
if ! dpkg -s yarn >/dev/null 2>&1; then
	curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
	sudo apt-get install -y nodejs
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt-get update
	sudo apt-get install -y yarn
else
	echo "yarn and node already installed"
fi

echo "Now follow the guide 1_ruby_passenger.md"
