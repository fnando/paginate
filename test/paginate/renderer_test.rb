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

  def test_simple_url
    @renderer.options[:url] = "/some/path"
    assert_equal "/some/path?page=1", @renderer.url_for(1)
  end

  def test_simple_url_with_page_param
    @renderer.options[:url] = "/some/path?page=3"
    assert_equal "/some/path?page=1", @renderer.url_for(1)
  end

  def test_simple_url_with_page_as_first_param
    @renderer.options[:url] = "/some/path?page=3&a=1&b=2&c=3"
    assert_equal "/some/path?a=1&amp;b=2&amp;c=3&amp;page=1", @renderer.url_for(1)
  end

  def test_simple_url_with_page_as_last_param
    @renderer.options[:url] = "/some/path?a=1&b=2&c=3&page=3"
    assert_equal "/some/path?a=1&amp;b=2&amp;c=3&amp;page=1", @renderer.url_for(1)
  end

  def test_simple_url_with_page_param_in_the_middle
    @renderer.options[:url] = "/some/path?a=1&b=2&page=3&c=3"
    assert_equal "/some/path?a=1&amp;b=2&amp;c=3&amp;page=1", @renderer.url_for(1)
  end

  def test_simple_url_with_page_as_text
    @renderer.options[:url] = "/some/path?a=1&b=2&c=3&page=abc"
    assert_equal "/some/path?a=1&amp;b=2&amp;c=3&amp;page=1", @renderer.url_for(1)
  end

  def test_escape_url_from_blocks
    @renderer.options[:url] = proc {|page| "/some/path/#{page}?a=1&b=2"}
    assert_equal "/some/path/1?a=1&amp;b=2", @renderer.url_for(1)
  end
end