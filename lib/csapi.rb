#!/usr/bin/env ruby
#encoding: utf-8

=begin

Licensed under The MIT License
Copyright (c) 2012 Partido Surrealista Mexicano  
=end

require 'httparty'
require 'json'
require 'nokogiri'

class CS
  include HTTParty
  base_uri 'https://api.couchsurfing.org'
  headers "Content-Type" => 'application/json'
  follow_redirects false
  @uid = '0'

  def initialize(username, password)
    @username = username
    r = self.class.post('/sessions', body:{username: username, password: password}.to_json)
    raise CS::AuthError.new("Could not login") if r.code != 200
    @cookies = []
    r.headers['Set-Cookie'].split(/, (?!\d)/).each do |cookie|
      key, value = cookie.split(';')[0].split('=')
      @cookies = "#{key}=#{value}"
    end
    data = JSON.parse r.body
    @uid = data['url'].gsub(/[^\d]/, '')
    @profile = data.keep_if {|k,v| ['realname', 'username', 'profile_image', 'gender', 'address'].include?(k)}
    @profile['uid'] = @uid
    self.class.headers 'Cookie' => @cookies
    @@instance = self
  end

  def CS::instance
    @@instance
  end

  def requests(limit=10)
    url = "/users/#{@uid}/couchrequests"
    q = {
        limit: limit
    }
    r = self.class.get(url, query:q)
    requests = {}
    response = JSON.parse r.body
    response['object'].each do |req|
      key = req.gsub(/[^\d]/, '')
      requests[key] = self.request(key)
    end
    requests
  end


  def request(id)
    url = "/couchrequests/#{id}"
    r = self.class.get(url)
    JSON.parse r.body
  end

  def userdata
    @profile
  end

  def profile(user=@uid)
    url = "/users/#{user}/profile"
    r = self.class.get(url)
    JSON.parse r.body
  end

  def photos(user=@uid)
    url = "/users/#{user}/photos"
    r = self.class.get(url)
    JSON.parse r.body
  end

  def friends(user=@uid)
    url = "/users/#{user}/friends"
    r = self.class.get(url)
    JSON.parse r.body
  end

  def references(user=@uid)
    url = "/users/#{user}/references"
    r = self.class.get(url)
    JSON.parse r.body
  end

  def search(options)
    
    defaults = {
      location: nil,
      gender: nil,
      :'has-photo' => nil,
      :'member-type' => 'host' ,
      vouched: nil,
      verified: nil,
      network: nil,
      :'min-age' => nil,
      :'max-age' => nil,
      :platform => 'android'
    }
    
    options = defaults.merge(options)
    html = self.class.get('/msearch', :query => options)
    doc = Nokogiri::HTML(html);
    users = {}
    statuses = {
      'M' => 'maybe',
      'T' => 'travelling',
      'Y' => 'available',
      'N' => 'unavailable'
    }
    doc.xpath('//article').each do |article|
      id = article.at_css('a').attr('href').split('/').last
      user = {
        name: article.children.at_css("h2").content,
        location: article.children.at_css("div.location").content,
        status: statuses[article['class'].match(/couch-([A-Z])/)[1]],
        pic: article.at_css('img').attr('src')
      }
      users[id] = user
    end
    
    users;
  end

  class AuthError < StandardError
  end

  class APIError < StandardError
  end

  class Request
    @api = nil

    def initialize(options={})
      if options[:username] && options[:password]
        api = CS.new(options[:username], options[:password])
        options.del(:username)
        options.del(:password)
      else
        api = CS::instance
        if api==nil
          raise CS::APIError('You have not authenticated with the service or did not provide a :username and :password')
        end
      end

      #pp api.userdata
      options[:subject] = options[:subject] || "#{api.userdata['realname']} from #{api.userdata['address']['country']} sent you a new CouchRequest!"
      options[:number] = options[:number] || 1
      options[:arrival_flexible] = options[:arrival_flexible] || false
      options[:departure_flexible] = options[:departure_flexible] || false
      options[:is_open_couchrequest] = options[:is_open_couchrequest] || false
      options[:from] = api.userdata['uid']
      options[:to] = options[:to] || api.userdata['uid']
      options[:arrival] = Time.at(options[:arrival]).strftime("%FT%TZ") || (Time.now()+86400).strftime("%FT%TZ")
      options[:departure] = Time.at(options[:departure]).strftime("%FT%TZ") || (Time.now()+86400*3).strftime("%FT%TZ")
      options[:message] = options[:message] || "I'm to lazy to write a proper couch request. HOST ME PLZ?"
      #puts options.to_json

      url = "/couchrequests"
      api.post(url, body:options.to_json)

      #pp response.code
      #pp response.body

    end
  end
end