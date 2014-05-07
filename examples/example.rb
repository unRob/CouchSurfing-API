#!/usr/bin/env ruby
#encoding: utf-8

require_relative '../lib/CSApi.rb'
require 'pp'

user = ENV['USER'] || 'user'
password = ENV['PASSWORD'] || 'password'

begin
  api = CS::Api.new(user,password)
rescue CS::AuthError
  puts "Incorrect username or password"
  exit
end

# ===
# Get a user's info, by default ours
# ===
profile = api.profile('205974')

## ===
## Get a user's photos, by default ours
## ===
photos = api.photos('205974')

## ===
## Get a user's friends, by default ours
## ===
friends = api.friends('205974')

## ===
## Get a user's references, by default ours
## ===
references = api.references('205974')

## ===
## Get the current user's recent requests
## ===
limit = 10
requests = api.requests(limit)

# ===
# Get the current user's inbox messages
# ===
messages = api.messages('inbox', 1)

messages.each do |m|
  puts m.to_h
end


if messages.has_more?
  p messages.more.count
else
  p "end of messages"
end


# ===
# Create a new Couch Request
# ===
details = {
  subject: 'This is my request subject',
  number: 1, #How many people travel with you
  arrival: Time.at(1339543920), #a Time instance
  departure: Time.at(1339643920), #a Time instance
  arrival_flexible: true,
  departure_flexible: false,
  is_open_couchrequest: false,
  to: 12345, #a numeric user id, I guess, have yet to figure this out ,
  message: 'This is my request message' #I've yet to figure out how to do the multi-part requests
}
#couch_request = CS::Request.new(details)

api.requests(1).each do |key, value|
  pp value
end

## ===
##   Search for people in a city with various search constraints
## ===
options = {
  location: 'mexico city',
  gender: 'female',
  :'has-photo' => false,
  :'member-type' => 'host' ,
  vouched: nil,
  verified: nil,
  network: nil,
  :'min-age' => nil,
  :'max-age' => nil,
}
search = CS::CouchSearch.new(options)
results = search.execute

results.each do |id, user|
  puts "Found (UID:#{id}) #{user[:name]} in #{user[:location]} with a couch status of #{user[:status]} and a photo #{user[:pic]}\n\n"
end

puts results.more.count
