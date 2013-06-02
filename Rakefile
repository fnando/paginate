require "bundler"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new

desc "Run specs against all gemfiles"
task "spec:all" do
  %w[Gemfile gemfiles/rails4.gemfile].each do |gemfile|
    ENV["BUNDLE_GEMFILE"] = gemfile
    Rake::Task["spec"].reenable
    Rake::Task["spec"].invoke
  end
end

task :default => "spec:all"
