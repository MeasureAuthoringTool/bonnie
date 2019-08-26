# Bonnie Ubuntu Install Scripts

Run/follow numbered files using a sudo privileged user on server. Some commands that the scripts run may print out info about futher things you should do. Do not worry about those, they are addressed by other commands that run in the scripts or steps.

0. Sets up the system pre-reqs.
1. Steps for setting up ruby and passenger.
2. Sets up bamboouser, bonnie directory, and cqm-execution-service.
3. Steps for preparing and running initial deploy.
4. Sets up Apache server config, and logrotate.

To zip these up for a quick SCP to the target server you can do:
```
tar -zcvf install-ubuntu.tar.gz install-ubuntu/
scp install-ubuntu.tar.gz user@server-ip:~/
```
On server to get started.
```
tar xvf install-ubuntu.tar.gz
cd install-ubuntu
./0_prereqs.sh
```

## Notes

This does not take care of the backup folder on a separate partion. If the server does not have a public route, which appears to be the current case for Ubuntu 18 staging servers, then the setup can be tested with ssh tunneling:
```
ssh -L 127.0.0.1:8080:localhost:80 user@server-ip
```
Then go to `http://localhost:8080`.
