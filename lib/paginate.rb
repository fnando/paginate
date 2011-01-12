require "i18n"
require "active_record"
require "paginate/base"
require "paginate/config"
require "paginate/helper"
require "paginate/renderer"
require "paginate/active_record"
require "paginate/action_controller"

module Paginate
  def self.setup(&block)
    yield Config
  end
end

Paginate.setup do |config|
  config.param_name = :page
  config.size  = 10
end
