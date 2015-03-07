# -*- encoding: utf-8 -*-
require "spec_helper"

describe "ActionView support" do
  before do
    @request = OpenStruct.new
    @params = Hash.new

    @controller = ThingsController.new
    @controller.params = @params

    @view = ActionView::Base.new(
      File.expand_path("../../support/views", __FILE__)
    )
    @view.lookup_context.prefixes << "application"
    @view.controller = @controller
    @view.extend(Paginate::Helper)
    allow(@view).to receive_messages request: @request

    @helper = Object.new
    @helper.extend(Paginate::Helper)

    Paginate.configure do |config|
      config.param_name = :page
      config.size  = 10
    end

    I18n.locale = :en
  end

  it "overrides render method" do
    items = [*1..11].map do |i|
      OpenStruct.new(:to_partial_path => "number", :value => i)
    end

    html = render(:render, items)
  end

  private
  def render(view_name, items)
    @controller.params = @params
    view_info = Struct.new(:to_partial_path).new("#{view_name}")
    Nokogiri @view.render(view_info, items: items)
  end

  def load_view(name)
    File.read(File.dirname(__FILE__) + "/../support/views/#{name}.erb")
  end
end
