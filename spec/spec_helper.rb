require "bundler"
Bundler.setup
Bundler.require(:default, :development)

require "rspec"
require "nokogiri"
require "ostruct"
require "sqlite3"
require "test_notifier/runner/rspec"

require "active_support/all"
require "action_view"
require "action_controller"

ActiveRecord::Base
  .establish_connection(:adapter => "sqlite3", :database => ":memory:")
Rails = OpenStruct.new(:version => ActiveRecord::VERSION::STRING)

require "paginate"

load "spec/schema.rb"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|file| require file}
I18n.load_path << File.dirname(__FILE__) + "/support/translations.yml"
