# Bonnie Initial Deploy

## Become Bamboouser

For most of these steps you need to be bamboouser.
```
sudo -u bamboouser -i
```

## Setup SSH Key for Capistrano Use

Create a ssh key pair with the default location and no passphrase. i.e. Just press enter on the prompts.
```
ssh-keygen -t rsa -b 4096 -C "bamboouser@localhost"
cp .ssh/id_rsa.pub .ssh/authorized_keys
```

## Bundle Install

Go to the repo and install gems. Change branches, re-clone if desired.
```
cd /apps/stg/tacoma/ruby/repository/production
bundle install --path vendor/bundle
```

## Rails Secret Key Base

Rails needs a secret seed that it will get from SECRET_KEY_BASE environment variable. We will add this to the passenger apache config.

Generate the key using a rake command:
```
bundle exec rake secret
```
Take the output of this command into your clipboard. It's a super long alpha-numeric string.

Leave sudo interactive to become yourself again. Using `sudo` open an editor for `/etc/apache2/sites-available/bonnie.conf`.

Take the output above command in your clipboard and add it, before the close of `<VirtualHost>` in a `SetEnv` directive. i.e.:
```
  </Directory>
  SetEnv SECRET_KEY_BASE asdf133asfasdfdsaf23adssa
</VirtualHost>
```

## Become Bamboouser (again)

Need to become bamboouser again.
```
sudo -u bamboouser -i
```

## Config

The following files in `/apps/stg/tacoma/ruby/bonnie/shared/config/` need to be adjusted to match the server environment for hostname and email settings.
 - `bonnie.yml`
 - `email.yml`
 - `server.yml`

## Initial Deploy

If all went well, capistrano deploy should work.
```
cd /apps/stg/tacoma/ruby/repository/production
bundle exec cap local deploy
```

NOTE: Bonnie will not be available from the web yet. We still need some Apache setup to happen.

## Configure RVM for cron

RVM can set up the bamboouser crontab for us to have RVM/Ruby loaded. This is needed to make the database backup work.
```
rvm cron setup
```

## DB Restore

Now is a good time to restore the database that you wish to use.
```
tar xvf bonnie_production___.tar.gz
cd bonnie_production___
mongorestore --drop --db bonnie_production bonnie_production
```

To continue, go back to your user and run `4_apache_cron.sh`.
