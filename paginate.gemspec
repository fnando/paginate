require "./lib/paginate/version"

Gem::Specification.new do |s|
  s.name        = "paginate"
  s.version     = Paginate::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["fnando.vieira@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/paginate"
  s.summary     = "Paginate collections using SIZE+1 to determine if there is a next page. Includes ActiveRecord and ActionView support."
  s.description = s.summary
  s.required_ruby_version = ">= 2.0.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "nokogiri"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "rails"
  s.add_development_dependency "minitest", "~> 5.1"
  s.add_development_dependency "minitest-utils"
  s.add_development_dependency "pry-meta"
  s.add_development_dependency "mocha"
  s.add_development_dependency "codeclimate-test-reporter"
end
