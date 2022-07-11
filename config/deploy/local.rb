# Capistrano is run on the deploy-to server via a Bamboo hook, so just deploy to the current host and user
# account into a directory relative to our current directory

# Deploy with production environment
set :stage, :production

# Tell RVM to use the current ruby when running capistrano
set :rvm1_ruby_version, '2.7.2'

# Set the branch to the currently checked out branch
set :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Keep a few older releases
set :keep_releases, 3

# Hostname and secret token get specified in config files local to the server
set :linked_files, (fetch(:linked_files) || []).concat(%w{config/server.yml config/newrelic.yml config/secrets.yml config/email.yml})

# Repository gets cloned to /apps/dev/tacoma/ruby/repository/bonnie, bonnie gets deployed to /apps/dev/tacoma/ruby/bonnie
set :deploy_to, File.join(File.dirname(File.dirname(Dir.pwd)), 'bonnie')

# Login using the username running the cap process (not necessarily the login user returned by Etc.getlogin!)
role :app, "#{Etc.getpwuid(Process.uid).name}@localhost"
role :web, "#{Etc.getpwuid(Process.uid).name}@localhost"
role :db,  "#{Etc.getpwuid(Process.uid).name}@localhost"
