#!/usr/bin/env ruby
#encoding: utf-8

require_relative '../lib/csapi'
#require_relative '../lib/search_helper'

cred = File.open('./example/files/cred.txt').read
creds = cred.split(';')

begin
  api = CS.new(creds[0], creds[1])
rescue CS::AuthError
  puts "Incorrect username or password"
  exit
end


my_profile = api.profile()
print my_profile

options = {:city => 'venice', :gender => nil, :has_photo => true, :member_type => 'host', :vouched => nil, :verified => nil, :network => nil, :min_age => nil, :max_age => nil}
s = api.search(options)
print '\r\n'
printt s
