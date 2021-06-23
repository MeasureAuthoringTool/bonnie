#!/bin/bash

# Setup bamboouser existence
if ! id -u bamboouser > /dev/null; then
	echo "bamboouser doesn't exist"
	sudo adduser --disabled-password --gecos "" bamboouser
	sudo gpasswd -a bamboouser rvm
	echo "bamboouser created and added to rvm group"
else
	echo "bamboouser already exists"
	if ! test -d /home/bamboouser; then
		sudo mkdir /home/bamboouser
		sudo chown bamboouser:bamboouser /home/bamboouser
		echo "bamboouser home directory created"
	fi
	sudo gpasswd -a bamboouser rvm
	echo "bamboouser added to rvm group"
fi

if ! test -d /apps/stg/tacoma/ruby/bonnie; then
	echo "bonnie folder doesn't exist"
	sudo mkdir -p /apps/stg/tacoma/ruby/bonnie
	sudo mkdir -p /apps/stg/tacoma/ruby/repository
	sudo mkdir -p /apps/stg/tacoma/docker/repository
	sudo cp -r ./bonnie-skel/* /apps/stg/tacoma/ruby/bonnie
	sudo mkdir -p /apps/stg/tacoma/ruby/bonnie/shared/db/backups
	sudo mkdir -p /apps/stg/tacoma/ruby/bonnie/shared/log
	sudo mkdir -p /apps/stg/tacoma/ruby/bonnie/shared/tmp
	sudo mkdir -p /apps/stg/tacoma/ruby/bonnie/shared/public/assets
	sudo mkdir -p /apps/stg/tacoma/ruby/bonnie/releases
	sudo mkdir -p /apps/stg/tacoma/ruby/bonnie/repo
	sudo touch /apps/stg/tacoma/ruby/bonnie/revisions.log
	# backup script cron task
	(sudo -u bamboouser crontab -l 2>/dev/null; echo "0 23 * * * /apps/stg/tacoma/ruby/bonnie/mongodb_backup.sh > /dev/null 2>&1") | sudo -u bamboouser crontab -
	sudo chown -R bamboouser:bamboouser /apps/stg/tacoma/
else
	echo "bonnie folder already exists"
fi

if ! test -d /apps/stg/tacoma/ruby/repository/production; then
	echo "pulling down bonnie production"
	sudo -u bamboouser git clone --branch production https://github.com/projecttacoma/bonnie.git /apps/stg/tacoma/ruby/repository/production
else
	echo "bonnie at production seems to be pulled down already"
fi

if ! test -d /apps/stg/tacoma/docker/repository/bonnie-patch; then
	echo "pulling down cqm-execution-service bonnie-patch"
	sudo -u bamboouser git clone --branch bonnie-patch https://github.com/projecttacoma/cqm-execution-service.git /apps/stg/tacoma/docker/repository/bonnie-patch
else
	echo "cqm-execution-service at bonnie-patch seems to be pulled down already"
fi

# copy over bonnie apache config
if ! test -f /etc/apache2/sites-available/bonnie.conf; then
	echo "copied bonnie apache config over"
	sudo cp ./bonnie.conf /etc/apache2/sites-available/bonnie.conf
else
	echo "bonnie apache config already in place"
fi

# setup docker cqm-execution-service
cd /apps/stg/tacoma/docker/repository/bonnie-patch
sudo docker stop cqm-execution-service
sudo docker rm cqm-execution-service
sudo docker build -t tacoma/cqm-execution-service .
if [ $? -eq 0 ]; then
	echo "looks like docker build succeded"
	sudo docker run --log-driver json-file --log-opt max-size=10m --log-opt max-file=4 -p 8081:8081 --restart=always --name cqm-execution-service -d tacoma/cqm-execution-service
	echo "execution service should now be set to auto run"
fi

echo "Now follow the guide 3_bonnie_deploy.md"
