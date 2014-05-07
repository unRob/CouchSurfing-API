module CS
  
  class Messages
    include Enumerable

    attr_accessor :data, :after, :q

    def self.getMessages(type='inbox', limit=5, start=nil)
      types = ['inbox', 'sent'];
      throw ArgumentError.new("Can't fetch messages of kind #{type}") unless types.include? type;
      
      url = "/users/#{@uid}/messages"
      q = {
        type: type,
        limit: limit
      }
      
      if (start)
        q[:start] = start
      end
      
      r = HTTP.instance.get(url, query:q);
      object = JSON.parse r.body
      
      CS::Messages.new(object, q); 
    end

    
    def initialize(object, q)
      @after = object['after'] if object.include? 'after';
      @q = q;
      @data = object['object']
    end
    
    
    def method_missing meth, *args, &block
      @data.send(meth.to_sym, *args, &block)
    end
    

    def has_more?
      return @after != nil
    end

    
    def more
      more = CS::Messages.getMessages(@q[:type], @q[:limit], @after)
      @data = more['object']
      @after = more.include?('after') ?  more['after'] : nil; 
      return self
    end
    
  end

end