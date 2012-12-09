# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Criticometer_session',
  :secret      => 'ac7ca3e4b19136975485c8dbe3a3a3c4871f35433055611eec4c7dc0fc37f5d8461ad6a53316a8a88a10a7b619e7fe6c4037f1c9a55bb787bc42030fc47ec83d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
