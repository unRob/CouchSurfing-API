require 'nokogiri'

class SearchHelper

  def get_url(options)
    city = options[:city]
    member_type = options[:member_type]
    language = options[:language]
    has_photo = options[:has_photo]
    vouched = options[:vouched]
    verified = options[:verified]
    network = options[:network]
    min_age = options[:min_age]
    max_age = options[:max_age]
    url = "/msearch?platform=android&location=#{city}"
    url += "&member-type=#{member_type}" if !member_type.nil?
    url += "&language=#{language}" if !language.nil?
    url += "&has-photo=#{has_photo}" if !has_photo.nil?
    url += "&vouched=#{vouched}" if !vouched.nil?
    url += "&verified=#{verified}" if !verified.nil?
    url += "&network=#{network}" if !network.nil?
    url += "&min-age=#{min_age}" if !min_age.nil?
    url += "&max-age=#{max_age}" if !max_age.nil?
    url
  end

  def parse(html_string, &block)
    doc = Nokogiri::HTML(html_string)

    if block_given? then
      parse_document(doc, &block)
    else
      list = []
      parse_document(doc) do |res|
        list << res
      end
      list
    end
  end

  def parse_document(doc)
    doc.xpath('//article').each do |article|
      couch = /person couch-([A-Z])/.match(article["class"])[1]
      id = %r".*users/([0-9]+)".match(article.children.at_css("a.profile-link").attr("href"))[1]
      location = article.children.at_css("div.location").content
      name = article.children.at_css("h2").content
      yield({"id" => id, "name" => name, "couch" => couch, "location" => location})
    end
  end
end