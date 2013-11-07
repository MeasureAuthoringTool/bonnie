namespace :bonnie do
  namespace :users do

    desc %{Grant an existing popHealth user administrator privileges.

    You must identify the user by USER_ID or EMAIL:

    $ rake pophealth:users:grant_admin USER_ID=###
    or
    $ rake pophealth:users:grant_admin EMAIL=xxx}
    task :grant_admin => :environment do
      user = User.find_by email: ENV['EMAIL']
      user.grant_admin()
      puts "#{ENV['EMAIL']} is now an administrator."
    end

    desc %{Remove the administrator role from an existing popHealth user.

    You must identify the user by USER_ID or EMAIL:

    $ rake pophealth:users:revoke_admin USER_ID=###
    or
    $ rake pophealth:users:revoke_admin EMAIL=xxx}
    task :revoke_admin => :environment do
      user = User.find_by email: ENV["EMAIL"]
      user.revoke_admin()
      puts "#{ENV['EMAIL']} is no longer an administrator."
    end
  end
end
