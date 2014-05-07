module CS

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