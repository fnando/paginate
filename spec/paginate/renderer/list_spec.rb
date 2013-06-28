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
end
