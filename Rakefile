require "rake/testtask"
require "jeweler"
require "lib/paginate/version"

Rake::TestTask.new do |t|
  t.libs += %w[ test lib ]
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
  t.ruby_opts = %w[ -rubygems ]
end

Jeweler::Tasks.new do |gem|
  gem.name = "paginate"
  gem.version = Paginate::Version::STRING
  gem.summary = "Paginate collections using SIZE+1 to determine if there is a next page. Includes ActiveRecord and ActionView support."
  gem.email = "fnando.vieira@gmail.com"
  gem.homepage = "http://github.com/fnando/paginate"
  gem.authors = ["Nando Vieira"]
  gem.files = FileList["lib/**/*", "Rakefile", "README.rdoc"]
end

Jeweler::GemcutterTasks.new
