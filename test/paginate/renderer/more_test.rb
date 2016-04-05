require "test_helper"

class MoreTest < Minitest::Test
  setup do
    Paginate.configure do |config|
      config.param_name = :page
      config.size  = 10
    end

    I18n.locale = :en

    @renderer = Paginate::Renderer::More.new(nil, {
      collection: Array.new(11),
      page: 1,
      fullpath: "/some/path"
    })
  end

  test "returns safe html" do
    assert @renderer.render.html_safe?
  end

  test "returns label" do
    assert_equal I18n.t("paginate.more"), @renderer.more_label
  end

  test "returns nothing when have no next page" do
    @renderer.processor.stubs(next_page?: false)
    assert_nil @renderer.render
  end

  test "returns html when have next page" do
    html = Nokogiri::HTML(@renderer.render)
    selector = "p.paginate > a.more"

    assert_equal @renderer.more_label, html.css(selector).text
    assert_equal @renderer.next_url, html.css(selector).first[:href]
  end
end
