module CS
  
  class Messages
    include Enumerable

    attr_accessor :data, :after, :q

    def self.getMessages(type='inbox', limit=5, start=nil)
      types = ['inbox', 'sent'];
      throw ArgumentError.new("Can't fetch messages of kind #{type}") unless types.include? type;
      
      url = "/users/#{CS::instance.uid}/messages"
      q = {
        type: type,
        limit: limit
      }
      
      if (start)
        q[:start] = start
      end
      
      r = HTTP.get(url, query:q);
      object = JSON.parse r.body
      
      CS::Messages.new(object, q); 
    end

    
    def initialize(object, q)
      @after = object['after'] if object.include? 'after';
      @q = q;
      @data = object['object'].map {|u| Message.new(u) }
    end
    

    def method_missing meth, *args, &block
      @data.send(meth.to_sym, *args, &block)
    end
    

    def has_more?
      return @after != nil
    end

    
    def more limit=nil
      Messages.getMessages(@q[:type], (limit || @q[:limit]), @after)
    end
    
  end

  class Message

    @url = nil
    @fetched = false
    @data = nil
    @vars = [:title, :message, :date, :user_is_sender, :is_unread, :user, :url, :couch_request]
    #attr_accessor *@vars

    def initialize(url)
      @url = url
      @fetched = false
    end

    def fetch
      req = HTTP.get(@url)
      @data = JSON.parse req.body
    end

    def to_h
      fetch unless @fetched
      @data
    end

    def date
      fetch unless @fetched
      Date.parse(@date)
    end

    def unread?
      fetch unless @fetched
      @is_unread
    end

    def is_sender?
      fetch unless @fetched
      @user_is_sender
    end

    def method_missing meth
      if vars.include? meth
        fetch unless @fetched
        @data[meth.to_s]
      else
        raise ArgumentError.new
      end
    end

  end

end