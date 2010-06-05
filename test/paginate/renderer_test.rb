require "test_helper"

class RendererTest < Test::Unit::TestCase
  def setup
    Paginate.setup do |config|
      config.param_name = :page
      config.size  = 10
    end

    I18n.locale = :en

    @renderer = Paginate::Renderer.new({
      :collection => Array.new(11),
      :page => 1,
      :fullpath => "/some/path"
    })
  end

  def test_safe_html
    string = String.new
    string.expects(:respond_to?).with(:html_safe).returns(true)
    string.expects(:html_safe)
    String.expects(:new).returns(string)

    @renderer.render
  end

  def test_no_safe_html
    string = String.new
    string.expects(:respond_to?).with(:html_safe).returns(false)
    string.expects(:html_safe).never
    String.expects(:new).returns(string)

    @renderer.render
  end
end