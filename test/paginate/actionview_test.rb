require "test_helper"

class ActionviewTest < Minitest::Test
  setup do
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
    @view.stubs(:request).returns(@request)

    @helper = Object.new
    @helper.extend(Paginate::Helper)

    Paginate.configure do |config|
      config.param_name = :page
      config.size  = 10
    end

    I18n.locale = :en
  end

  test "overrides render method" do
    items = [*1..11].map do |i|
      OpenStruct.new(:to_partial_path => "number", :value => i)
    end

    html = render(:render, items)

    assert 10, html.css("p.number").size
    assert_equal ("1".."10").to_a, html.css("p.number").map(&:text)
  end

  private

  def render(view_name, items)
    @controller.params = @params
    view_info = Struct.new(:to_partial_path).new("#{view_name}")
    Nokogiri::HTML(@view.render(view_info, items: items))
  end

  def load_view(name)
    File.read(File.dirname(__FILE__) + "/../support/views/#{name}.erb")
  end
end
