# Ruby Passenger Setup

## Notes
This installs the following versions.

  RUBY = 2.4.5
  PASSENGER = 5.3.7

## Become Root

```
sudo -i
```

## Setup Ruby

```
rvm install 2.4.5
rvm use 2.4.5
rvm --default 2.4.5
gem install bundler -v '< 2.0'
```

## Setup Gems

```
gem install capistrano -v 3.2.1
gem install capistrano-bundler -v 1.1.2
gem install capistrano-rails -v 1.1.1
gem install rack -v 1.6.4
gem install rvm1-capistrano3 -v 1.2.2
```

## Reboot and Become Root Again

Reboot the server
```
reboot
```

Then become root again.
```
sudo -i
```

## Setup Passenger

```
gem install passenger -v 5.3.7
passenger-install-apache2-module
```

This will ask you questions about what environments you want to run. Uncheck (spacebar, arrows) python and node.js, leaving just ruby checked. Continue (enter).

After compilation completes it will tell you about the module change you need to make. To do this, open a new ssh session in another tab. In the new session, copy `install-ubuntu/mod_passenger.conf` to `/etc/apache2/conf-available/mod_passenger.conf`.
```
sudo cp install-ubuntu/mod_passenger.conf /etc/apache2/conf-available/mod_passenger.conf
```
*Make sure the paths given in the passenger installer ssh session tab match what you copied.*

**BEFORE RETURNING TO OTHER SSH SESSION** Enable the config and restart Apache. This should be done before returning to the installer.
```
sudo a2enconf mod_passenger
sudo service apache2 restart
```

Now you can close this ssh session and go back to original session where the installer is paused. Press enter to continue the passenger installer. It should be pleased about the setup.

## RVM Group

Back in your user account you may want to add yourself to the `rvm` group before continuing.
```
sudo gpasswd -a `whoami` rvm
```

Disconnect your ssh session, and connect a new one for `rvm` to be ready to go before continuing.

To continue, run `2_bonnie.sh`.