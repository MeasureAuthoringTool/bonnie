#!/bin/bash

# Enable modules needed
sudo a2enconf mod_passenger
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod expires

# Turn off default site and enable bonnie
sudo a2dissite 000-default
sudo a2ensite bonnie

# Restart apache
sudo service apache2 restart
echo "Restarted Apache (This satsifies the above warning to reload or restart for things to take effect)"

# logrotate
sudo cp bonnie.logrotate /etc/logrotate.d/bonnie
echo "Logrotate entry added"

