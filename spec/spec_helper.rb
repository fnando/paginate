ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)
require "bundler/setup"

require "logger"
require "rspec"
require "nokogiri"
require "ostruct"
require "sqlite3"
require "test_notifier/runner/rspec"
require "rails"

require "active_record"
require "active_support/all"
require "action_view"
require "action_controller"
require "paginate"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

load "spec/schema.rb"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|file| require file}
I18n.load_path << File.dirname(__FILE__) + "/support/translations.yml"

RSpec.configure do |config|
  config.before(:each) do
    Paginate.configuration = Paginate::Configuration.new
  end
end
