module CS

	class SearchResults
    include Enumerable
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def each &block
      @data.each &block
    end

    def next_page= proc
      @next_page = proc
    end

    def [](key)
      @data[key]
    end

    def next_page
      @next_page.call()
    end

	end
end