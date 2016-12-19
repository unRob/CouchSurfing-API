#!/usr/bin/env ruby
#encoding: utf-8

=begin

Licensed under The MIT License
Copyright (c) 2012 Partido Surrealista Mexicano
=end

require 'httparty'
require 'json'
require 'nokogiri'

require_relative 'csapi/version.rb'
require_relative 'csapi/errors.rb'
require_relative 'csapi/messages.rb'
require_relative 'csapi/request.rb'
require_relative 'csapi/search.rb'

module CS

  @@instance = nil

  def self.instance
    @@instance
  end

  def self.instance= instance
    @@instance = instance
  end

  class HTTP
    include HTTParty
    base_uri 'https://api.couchsurfing.org'
    headers "Content-Type" => 'application/json'
    follow_redirects false
    #debug_output $stderr
  end

  class Api

    attr_accessor :uid;
    @uid = '0'

    def initialize(username, password)
      @username = username
      r = HTTP.post('/sessions', body:{username: username, password: password}.to_json)

      raise CS::APIError.new('Unsupported API version') if r.headers['X-CS-Error'] == 'clientVersionNotSupportedAnymore'
      raise CS::AuthError.new("Could not login") if r.code != 200

      @cookies = []
      @cookies=r.headers['Set-Cookie'].split(/;/).first
      #end

      data = JSON.parse r.body
      @uid = data['url'].gsub(/[^\d]/, '')
      @profile = data.keep_if {|k,v| ['realname', 'username', 'profile_image', 'gender', 'address'].include?(k)}
      @profile['uid'] = @uid
      HTTP.headers 'Cookie' => @cookies
      CS.instance = self
    end


    def requests(limit=10)
      url = "/users/#{@uid}/couchrequests"
      q = {
          limit: limit
      }
      r = HTTP.get(url, query:q)
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
      r = HTTP.get(url)
      JSON.parse r.body
    end


    def messages(*args)
      CS::Messages.getMessages(*args)
    end


    def message(url)
      r = HTTP.get(url)
      JSON.parse r.body
    end


    def userdata
      @profile
    end


    def profile(user=@uid)
      url = "/users/#{user}/profile"
      r = HTTP.get(url)
      JSON.parse r.body
    end


    def photos(user=@uid)
      url = "/users/#{user}/photos"
      r = HTTP.get(url)
      JSON.parse r.body
    end


    def friends(user=@uid)
      url = "/users/#{user}/friends"
      r = HTTP.get(url)
      JSON.parse r.body
    end


    def references(user=@uid)
      url = "/users/#{user}/references"
      r = HTTP.get(url)
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


    end
  end

end
