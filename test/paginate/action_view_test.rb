require "test_helper"

class ActionViewTest < Test::Unit::TestCase
  def setup
    @request = OpenStruct.new
    @params = Hash.new

    @controller = ThingsController.new
    @controller.params = @params

    @view = ActionView::Base.new
    @view.controller = @controller
    @view.extend(Paginate::Helper)
    @view.stubs(:request).returns(@request)

    @helper = Object.new
    @helper.extend(Paginate::Helper)

    Paginate.setup do |config|
      config.param_name = :page
      config.size  = 10
    end

    I18n.locale = :en
  end

  def test_display_pagination_list
    @request.fullpath = "/some/path?page=1"
    html = render(:default, [])

    assert_equal 1, html.css("ul.paginate").count
    assert_equal 3, html.css("ul.paginate > li").count
  end

  def test_disabled
    @request.fullpath = "/some/path"
    html = render(:default, [])

    assert_not_nil html.css("ul.paginate.disabled").first
  end

  def test_display_next_page_link
    @request.fullpath = "/some/path?page=1"
    html = render(:default, Array.new(11))
    link = html.css("li.next-page > a").first

    assert_not_nil link
    assert_equal "/some/path?page=2", link["href"]
    assert_equal "Next page", link.text
  end

  def test_display_next_page_link_from_block
    @request.fullpath = "/some/path?page=1"
    html = render(:block_as_url, Array.new(11))
    link = html.css("li.next-page > a").first

    assert_not_nil link
    assert_equal "/some/path/2", link["href"]
    assert_equal "Next page", link.text
  end

  def test_display_previous_page_link
    @params[:page] = 2
    @request.fullpath = "/some/path?page=2"
    html = render(:default, Array.new(11))
    link = html.css("li.previous-page > a").first

    assert_not_nil link
    assert_equal "/some/path?page=1", link["href"]
    assert_equal "Previous page", link.text
  end

  def test_display_next_page_as_disabled
    @request.fullpath = "/some/path?page=1"
    html = render(:default, Array.new(10))
    link = html.css("li.next-page > a").first
    span = html.css("li.next-page.disabled > span").first

    assert_nil link
    assert_not_nil span
    assert_equal "Next page", span.text
  end

  def test_display_previous_page_as_disabled
    @request.fullpath = "/some/path?page=1"
    html = render(:default, Array.new(10))
    link = html.css("li.previous-page > a").first
    span = html.css("li.previous-page.disabled > span").first

    assert_nil link
    assert_not_nil span
    assert_equal "Previous page", span.text
  end

  def test_display_current_page
    @params[:page] = 10
    @request.fullpath = "/some/path?page=10"
    html = render(:default, [])
    span = html.css("li.page > span").first

    assert_not_nil span
    assert_equal "Page 10", span.text
  end

  def test_translate_strings
    I18n.locale = :pt

    @params[:page] = 10
    @request.fullpath = "/some/path?page=10"
    html = render(:default, Array.new(11))

    assert_equal "Página 10", html.css("li.page > span").text
    assert_equal "Próxima página", html.css("li.next-page > a").text
    assert_equal "Página anterior", html.css("li.previous-page > a").text
  end

  def test_iterate
    values = []
    items = Array.new(11) {|i| "User#{i}" }

    @helper.iterate items do |item|
      values << item
    end

    assert_equal items[0, 10], values
  end

  def test_iterate_with_index
    values = []
    indices = []
    items = Array.new(11) {|i| "User#{i}" }

    @helper.iterate items do |item, i|
      values << item
      indices << i
    end

    assert_equal items[0, 10], values
    assert_equal (0...10).to_a, indices
  end

  private
  def render(view_name, items)
    Nokogiri @view.render(:inline => load_view(view_name), :locals => {:items => items})
  end

  def load_view(name)
    File.read(File.dirname(__FILE__) + "/../resources/views/#{name}.erb")
  end
end
