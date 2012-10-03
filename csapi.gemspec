# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csapi/version'

Gem::Specification.new do |gem|
  gem.name          = "CSApi"
  gem.version       = CS::VERSION
  gem.authors       = ["Roberto Hidalgo"]
  gem.email         = ["un@rob.mx"]
  gem.description   = "Simple wrapper of couchsurfing.org API for accessing profile, friends, searching, etc."
  gem.summary       = "I have no idea what is this"
  gem.homepage      = "https://github.com/unRob/CouchSurfing-API"
  gem.has_rdoc = false

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  
  gem.add_runtime_dependency 'httparty'
  gem.add_runtime_dependency 'json'
  gem.add_runtime_dependency 'nokogiri'
  
end
