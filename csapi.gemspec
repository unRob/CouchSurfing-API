spec = Gem::Specification.new do |s|
  s.name = 'csapi'
  s.version = '0.0.2'
  s.summary = "Couchsurfing API."
  s.description = %{Simple wrapper of couchsurfing.org API for accessing profile, friends, searching, etc.}
  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_path = 'lib'
  s.autorequire = 'csapi'
  s.has_rdoc = false
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.authors = ["Roberto Hidalgo", "Peter Nosko"]
  s.email = "rob@unrob.com; peter.nosko@gmail.com"
  s.homepage = "http://unrob.com"

  # Manifest
#  s.files         = `git ls-files`.split("\n")
#  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
#  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Dependencies
  s.add_runtime_dependency 'httparty'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'nokogiri'
end