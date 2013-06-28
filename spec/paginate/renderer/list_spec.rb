require "spec_helper"

describe Paginate::Renderer::List do
  before do
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

  it { expect(@renderer.render).to be_html_safe }
  it { expect(@renderer.previous_label).to eql(I18n.t("paginate.previous")) }
  it { expect(@renderer.next_label).to eql(I18n.t("paginate.next")) }
  it { expect(@renderer.page_label).to eql(I18n.t("paginate.page", page: 1)) }

  it "displays current page" do
    @renderer.processor.stub page: 1234

    html = Nokogiri::HTML(@renderer.render)
    span = html.css("li.page > span").first

    expect(span).to be
    expect(span.text).to eql("Page 1234")
  end

  it "translates strings" do
    I18n.locale = "pt-BR"
    @renderer.processor.stub page: 10

    html = Nokogiri::HTML(@renderer.render)

    expect(html.css("li.page > span").text).to eql("Página 10")
    expect(html.css("li.next-page > a").text).to eql("Próxima página")
    expect(html.css("li.previous-page > a").text).to eql("Página anterior")
  end

  it "displays previous page link" do
    @renderer.processor.stub page: 2

    html = Nokogiri::HTML(@renderer.render)
    link = html.css("li.previous-page > a").first

    expect(link).to be
    expect(link["href"]).to eql("/some/path?page=1")
    expect(link.text).to eql("Previous page")
  end

  it "displays next page link" do
    @renderer.processor.stub page: 1

    html = Nokogiri::HTML(@renderer.render)
    link = html.css("li.next-page > a").first

    expect(link).to be
    expect(link["href"]).to eql("/some/path?page=2")
    expect(link.text).to eql("Next page")
  end

  it "displays pagination list" do
    html = Nokogiri::HTML(@renderer.render)

    expect(html.css("ul.paginate").count).to eql(1)
    expect(html.css("ul.paginate > li").count).to eql(3)
  end

  context "when have no items" do
    it "adds .disabled class to the list" do
      @renderer.processor.stub next_page?: false, previous_page?: false

      html = Nokogiri::HTML(@renderer.render)
      expect(html.css("ul.paginate.disabled").first).to be
    end
  end

  context "when have no next page" do
    it "disables the element" do
      @renderer.processor.stub :next_page?

      html = Nokogiri::HTML(@renderer.render)
      link = html.css("li.next-page > a").first
      span = html.css("li.next-page.disabled > span").first

      expect(link).not_to be
      expect(span).to be
      expect(span.text).to eql("Next page")
    end
  end

  context "when no previous page" do
    it "disables the element" do
      @renderer.processor.stub :previous_page?

      html = Nokogiri::HTML(@renderer.render)
      link = html.css("li.previous-page > a").first
      span = html.css("li.previous-page.disabled > span").first

      expect(link).not_to be
      expect(span).to be
      expect(span.text).to eql("Previous page")
    end
  end
end
