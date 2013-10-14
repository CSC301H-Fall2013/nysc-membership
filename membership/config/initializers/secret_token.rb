# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Membership::Application.config.secret_key_base = '7c958bf02ee642f937ae1c72cf6575a71d07bd0497186fe9cf4de7c9868b6313e4558294976f95167cd802f5e11b64fa6b27c2100203ced7840979b2851b56d3'
