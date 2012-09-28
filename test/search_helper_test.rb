require_relative '../lib/search_helper'
require "test/unit"

class SearchHelperTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake test
  def test_search_parse
    response = File.open('attempt.txt').read()
    helper = SearchHelper.new()
    result = helper.parse(response)
    assert_not_nil(result)
  end

  def test_search_get_url_basic
    options = {:city => 'rome', :gender => nil, :has_photo => nil, :member_type => nil, :vouched => nil, :verified => nil, :network => nil, :min_age => nil, :max_age => nil}
    helper = SearchHelper.new()
    url = helper.get_url(options)
    assert_equal("/msearch?platform=android&location=rome", url)
  end

  def test_search_get_url_has_photo
    options = {:city => 'rome', :gender => nil, :has_photo => true, :member_type => nil, :vouched => nil, :verified => nil, :network => nil, :min_age => nil, :max_age => nil}
    helper = SearchHelper.new()
    url = helper.get_url(options)
    assert_equal("/msearch?platform=android&location=rome&has-photo=true", url)
  end
end