require "test_helper"

class BaseTest < Minitest::Test
  setup do
    Paginate.configure do |config|
      config.param_name = :page
      config.size  = 10
    end

    I18n.locale = :en

    @renderer = Paginate::Renderer::Base.new(nil, {
      collection: Array.new(11),
      page: 1,
      fullpath: "/some/path"
    })
  end

  test "parses simple url" do
    @renderer.options[:url] = "/some/path"
    assert_equal "/some/path?page=1", @renderer.url_for(1)
  end

  test "parses url with page param" do
    @renderer.options[:url] = "/some/path?page=3"
    assert_equal "/some/path?page=1", @renderer.url_for(1)
  end

  test "parses url with page as first param" do
    @renderer.options[:url] = "/some/path?page=3&a=1&b=2&c=3"
    assert_equal "/some/path?a=1&amp;b=2&amp;c=3&amp;page=1", @renderer.url_for(1)
  end

  test "parses url with page as last param" do
    @renderer.options[:url] = "/some/path?a=1&b=2&c=3&page=3"
    assert_equal "/some/path?a=1&amp;b=2&amp;c=3&amp;page=1", @renderer.url_for(1)
  end

  test "parses url with page param in the middle" do
    @renderer.options[:url] = "/some/path?a=1&b=2&page=3&c=3"
    assert_equal "/some/path?a=1&amp;b=2&amp;c=3&amp;page=1", @renderer.url_for(1)
  end

  test "parses url with page as arbitrary string" do
    @renderer.options[:url] = "/some/path?a=1&b=2&c=3&page=abc"
    assert_equal "/some/path?a=1&amp;b=2&amp;c=3&amp;page=1", @renderer.url_for(1)
  end

  test "escapes url from blocks" do
    @renderer.options[:url] = proc {|page| "/some/path/#{page}?a=1&b=2"}
    assert_equal "/some/path/1?a=1&amp;b=2", @renderer.url_for(1)
  end
end
