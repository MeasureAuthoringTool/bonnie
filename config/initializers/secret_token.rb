# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Bonnie::Application.config.secret_token = if Rails.env.development? or Rails.env.test?
  ('x' * 30) # Bogus default for developent and testing purposes
else
  ENV['SECRET_TOKEN'] # Defer to environment for secret token on deployed systems
end
