module CS

	class SearchResults
    include Enumerable
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def method_missing meth, *args, &block
      @data.send(meth.to_sym, *args, &block)
    end

    def next_page= proc
      @next_page = proc
    end

    def next_page
      @next_page.call()
    end

	end
end