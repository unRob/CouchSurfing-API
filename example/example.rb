#!/usr/bin/env ruby
#encoding: utf-8

require '../lib/csapi.rb'

begin
  api = CS.new('username','password')
rescue CS::AuthError
  puts "Incorrect username or password"
  exit
end

# ===
# Get a user's info, by default ours
# ===
profile = api.profile('205974')

# ===
# Get a user's photos, by default ours
# ===
photos = api.photos('205974')

# ===
# Get a user's friends, by default ours
# ===
friends = api.friends('205974')

# ===
# Get a user's references, by default ours
# ===
references = api.references('205974')

# ===
# Get the current user's recent requests
# ===
limit = 10
requests = api.requests(limit)

# ===
# Create a new Couch Request
# ===
=begin
details = {
  subject: 'This is my request subject',
  number: 1, #How much people travel with you
  arrival: 1339543920, #a Unix Timestamp with your arrival date
  departure: 1339643920, #a Unix Timestamp with your departure date
  arrival_flexible: true,
  departure_flexible: false,
  is_open_couchrequest: false,
  to: 12345, #a numeric user id, I guess, have yet to figure this out ,
  message: 'This is my request message' #I've yet to figure out how to do the multi-part requests
}
couch_request = CS::Request.new(details)
=end

#api.requests(1).each do |key, value|
#  pp value
#end

# ===
#   Search for people in a city with various search constraints
# ===
options = {:city => 'venice', :gender => nil, :has-photo => true, :member-type => 'host', :vouched => nil, :verified => nil, :network => nil, :min-age => nil, :max-age => nil}
hits = api.search(options)
