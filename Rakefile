require "bundler"
Bundler::GemHelper.install_tasks

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs += %w[ test lib ]
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
  t.ruby_opts = %w[ -rubygems ]
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new
