# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Registration::Application.config.secret_key_base = '53d2aade8dfed5bbeb0a02ff1cac85730468f1c971f12ea02aa33f6e60399a8624dcf20a41266f296aa5d411dd2895aa31ffca4df4018bbe425fa76f20b0a7aa'
