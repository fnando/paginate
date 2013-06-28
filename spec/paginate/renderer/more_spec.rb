require "spec_helper"

describe Paginate::Renderer::More do
  before do
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

  it { expect(@renderer.render).to be_html_safe }
  it { expect(@renderer.more_label).to eql(I18n.t("paginate.more")) }

  context "when have no next page" do
    it "returns nil" do
      @renderer.processor.stub :next_page?
      expect(@renderer.render).to be_nil
    end
  end

  context "when have next page" do
    it "returns html" do
      html = Nokogiri::HTML(@renderer.render)
      selector = "p.paginate > a.more"

      expect(html.css(selector).text).to eql(@renderer.more_label)
      expect(html.css(selector).first[:href]).to eql(@renderer.next_url)
    end
  end
end
