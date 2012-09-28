require 'httparty'

class CSConnector
  include HTTParty

  base_uri 'https://api.couchsurfing.org'
  headers "Content-Type" => 'application/json'
  follow_redirects false

  def login(username, password)
    r = self.class.post('/sessions', body: {username: username, password: password}.to_json)
    raise CS::AuthError.new("Could not login") if r.code != 200
    @cookies = []
    r.headers['Set-Cookie'].split(/, (?!\d)/).each do |cookie|
      key, value = cookie.split(';')[0].split('=')
      @cookies = "#{key}=#{value}"
    end
    self.class.headers 'Cookie' => @cookies
    JSON.parse r.body
  end

  def requests(limit)
    url = "/users/#{@uid}/couchrequests"
    q = {
        limit: limit
    }
    r = self.class.get(url, query: q)
    JSON.parse r.body
  end

  def request(id)
    url = "/couchrequests/#{id}"
    r = self.class.get(url)
    JSON.parse r.body
  end

  def photos(user)
    url = "/users/#{user}/photos"
    r = self.class.get(url)
    JSON.parse r.body
  end

  def profile(user)
    url = "/users/#{user}/profile"
    r = self.class.get(url)
    JSON.parse r.body
  end

  def references(user)
    url = "/users/#{user}/references"
    r = self.class.get(url)
    JSON.parse r.body
  end

  def friends(user)
    url = "/users/#{user}/friends"
    r = self.class.get(url)
    JSON.parse r.body
  end
end