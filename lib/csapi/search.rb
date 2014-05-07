module CS

  class CouchSearch
    attr_accessor :results, :options

    @results = nil
    @@instance = nil

    def self.instance
      @@instance
    end

    def initialize options={}
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

      @options = options.merge(defaults)
      @@instance = self
      
    end


    def execute
      html = HTTP.get('/msearch', :query => @options)
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
          string_id: article.attr('rel'),
          name: article.children.at_css("h2").content,
          location: article.children.at_css("div.location").content,
          status: statuses[article['class'].match(/couch-([A-Z])/)[1]],
          pic: article.at_css('img').attr('src')
        }
        users[id] = user
      end
      
      @results = CS::SearchResults.new(users)
      @results
    end


    def more
      @options[:page] = (@options[:page]||0)+1
      @options[:exclude_ids] = results.collect {|k, u| u[:string_id]}
      results
    end

  end

	class SearchResults
    include Enumerable
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def method_missing meth, *args, &block
      @data.send(meth.to_sym, *args, &block)
    end

    def more
      CS::CouchSearch.instance.more
    end
  
	end
end