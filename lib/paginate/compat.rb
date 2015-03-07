require "i18n"
require "active_record"
require "paginate/base"
require "paginate/configuration"
require "paginate/helper"
require "paginate/renderer"
require "paginate/renderer/list"
require "paginate/renderer/more"
require "paginate/extension"
require "paginate/action_controller"

module Paginate
  class << self
    attr_accessor :configuration
  end

  self.configuration = Configuration.new

  def self.configure(&block)
    yield configuration
  end
end
