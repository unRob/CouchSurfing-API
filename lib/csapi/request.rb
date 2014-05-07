module CS

  class Request
    @api = nil

    attr_accesor :subject, :number, :arrival_flexible, :departure_flexible, :is_open_couchrequest, :from, :to, :arrival, :departure, :message

    @options = [:subject, :number, :arrival_flexible, :departure_flexible, :is_open_couchrequest, :from, :to, :arrival, :departure, :message]

    @defaults = {
      subject: "A ruby programmer wants to surf your couch!",
      number: 1,
      arrival_flexible: false,
      departure_flexible: false,
      is_open_couchrequest: false,
      from: nil,
      to: nil,
      arrival: Time.now,
      departure: (Time.now+3600),
      message: "I'm to lazy to write a proper couch request. HOST ME PLZ?"
    }


    def initialize options={}
      options = @defaults.merge(options)
      options.each do |k,v|
        self.send "@#{k}=", val
      end
    end


    def arrival= date
      raise ArgumentError.new("This does not seem like a Time instance") unless date.is_a? Time
      @arrival = date
    end


    def departure= date
      raise ArgumentError.new("This does not seem like a Time instance") unless date.is_a? Time
      @departure = date
    end


    def to_h
      params = {}
      @options.each {|key| params[key.to_sym] = instance_variable_get("@#{key}") }
      params
    end


    def send!
      raise CS::APIError('You have not authenticated with the service or did not provide a :username and :password') unless CS.instance

      data = self.to_h
      data[:arrival] = data[:arrival].strftime("%FT%TZ")
      data[:departure] = data[:departure].strftime("%FT%TZ")

      me = CS.instance.userdata['uid']
      data[:from] ||= me
      data[:to] ||= me

      CS::HTTP.instance.post('/couchrequests', body: data)

    end

  end
  
end