require "test_helper"

class BaseTest < Minitest::Test
  setup do
    Paginate.configure do |config|
      config.param_name = :page
      config.size  = 10
    end

    I18n.locale = :en

    @renderer = Paginate::Renderer::List.new(nil, {
      collection: Array.new(11),
      page: 1,
      fullpath: "/some/path"
    })
  end

  test "returns safe html" do
    assert @renderer.render.html_safe?
  end

  test "returns labels" do
    assert_equal I18n.t("paginate.previous"), @renderer.previous_label
    assert_equal I18n.t("paginate.next"), @renderer.next_label
    assert_equal I18n.t("paginate.page", page: 1), @renderer.page_label
  end

  test "displays current page" do
    @renderer.processor.stubs(page: 1234)

    html = Nokogiri::HTML(@renderer.render)
    span = html.css("li.page > span").first

    assert span
    assert_equal "Page 1234", span.text
  end

  test "translates strings" do
    I18n.locale = "pt-BR"
    @renderer.processor.stubs(page: 10)

    html = Nokogiri::HTML(@renderer.render)

    assert_equal "Página 10", html.css("li.page > span").text
    assert_equal "Próxima página", html.css("li.next-page > a").text
    assert_equal "Página anterior", html.css("li.previous-page > a").text
  end

  test "displays previous page link" do
    @renderer.processor.stubs(page: 2)

    html = Nokogiri::HTML(@renderer.render)
    link = html.css("li.previous-page > a").first

    assert link
    assert_equal "/some/path?page=1", link["href"]
    assert_equal "Previous page", link.text
  end

  test "displays next page link" do
    @renderer.processor.stubs(page: 1)

    html = Nokogiri::HTML(@renderer.render)
    link = html.css("li.next-page > a").first

    assert link
    assert_equal "/some/path?page=2", link["href"]
    assert_equal "Next page", link.text
  end

  test "displays pagination list" do
    html = Nokogiri::HTML(@renderer.render)

    assert_equal 1, html.css("ul.paginate").count
    assert_equal 3, html.css("ul.paginate > li").count
  end

  test "adds .disabled class to the list when have no items" do
    @renderer.processor.stubs(next_page?: false, previous_page?: false)

    html = Nokogiri::HTML(@renderer.render)
    assert html.css("ul.paginate.disabled").first
  end

  test "disables element when have no next page" do
    @renderer.processor.stubs(next_page?: false)

    html = Nokogiri::HTML(@renderer.render)
    link = html.css("li.next-page > a").first
    span = html.css("li.next-page.disabled > span").first

    assert span
    refute link
    assert_equal "Next page", span.text
  end

  test "disables element when have no previous page" do
    @renderer.processor.stubs(previous_page?: false)

    html = Nokogiri::HTML(@renderer.render)
    link = html.css("li.previous-page > a").first
    span = html.css("li.previous-page.disabled > span").first

    assert span
    refute link
    assert_equal "Previous page", span.text
  end
end
