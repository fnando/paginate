gem "test-unit"

require "test/unit"
require "mocha"
require "nokogiri"
require "ostruct"
require "active_support/all"
require "active_record"
require "action_view"
require "action_controller"
require "sqlite3"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

Rails = OpenStruct.new(:version => ActiveRecord::VERSION::STRING)

require "paginate"

load "resources/schema.rb"
require "resources/model"
require "resources/controller"
