require "i18n"
require "active_record"
require "paginate/renderer"
require "paginate/base"
require "paginate/config"
require "paginate/helper"
require "paginate/active_record"
require "paginate/action_controller"

module Paginate
  def self.configure(&block)
    yield Config
  end

  def self.setup(&block)
    warn "Paginate.setup is deprecated; use Paginate.configure instead."
    configure(&block)
  end
end

Paginate.configure do |config|
  config.param_name = :page
  config.size  = 10
  config.renderer = Paginate::Renderer::Basic
end
