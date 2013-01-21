# -*- encoding: utf-8 -*-
require "spec_helper"

describe "ActionView support" do
  before do
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
    @view.stub :request => @request

    @helper = Object.new
    @helper.extend(Paginate::Helper)

    Paginate.configure do |config|
      config.param_name = :page
      config.size  = 10
    end

    I18n.locale = :en
  end

  it "displays pagination list" do
    @request.fullpath = "/some/path?page=1"
    html = render(:default, [])

    expect(html.css("ul.paginate").count).to eql(1)
    expect(html.css("ul.paginate > li").count).to eql(3)
  end

  it "adds .disabled class when have no items" do
    @request.fullpath = "/some/path"
    html = render(:default, [])

    expect(html.css("ul.paginate.disabled").first).to be
  end

  it "displays next page link" do
    @request.fullpath = "/some/path?page=1"
    html = render(:default, Array.new(11))
    link = html.css("li.next-page > a").first

    expect(link).to be
    expect(link["href"]).to eql("/some/path?page=2")
    expect(link.text).to eql("Next page")
  end

  it "displays next page link using proc as url" do
    @request.fullpath = "/some/path?page=1"
    html = render(:block_as_url, Array.new(11))
    link = html.css("li.next-page > a").first

    expect(link).to be
    expect(link["href"]).to eql("/some/path/2")
    expect(link.text).to eql("Next page")
  end

  it "displays previous page link" do
    @params[:page] = 2
    @request.fullpath = "/some/path?page=2"
    html = render(:default, Array.new(11))
    link = html.css("li.previous-page > a").first

    expect(link).to be
    expect(link["href"]).to eql("/some/path?page=1")
    expect(link.text).to eql("Previous page")
  end

  it "disables element when have no next page" do
    @request.fullpath = "/some/path?page=1"
    html = render(:default, Array.new(10))
    link = html.css("li.next-page > a").first
    span = html.css("li.next-page.disabled > span").first

    expect(link).not_to be
    expect(span).to be
    expect(span.text).to eql("Next page")
  end

  it "disables element when have no previous page" do
    @request.fullpath = "/some/path?page=1"
    html = render(:default, Array.new(10))
    link = html.css("li.previous-page > a").first
    span = html.css("li.previous-page.disabled > span").first

    expect(link).not_to be
    expect(span).to be
    expect(span.text).to eql("Previous page")
  end

  it "displays current page" do
    @params[:page] = 10
    @request.fullpath = "/some/path?page=10"
    html = render(:default, [])
    span = html.css("li.page > span").first

    expect(span).to be
    expect(span.text).to eql("Page 10")
  end

  it "overrides render method" do
    items = [*1..11].map do |i|
      OpenStruct.new(:to_partial_path => "number", :value => i)
    end

    html = render(:render, items)
  end

  it "translates strings" do
    I18n.locale = :"pt-BR"

    @params[:page] = 10
    @request.fullpath = "/some/path?page=10"
    html = render(:default, Array.new(11))

    expect(html.css("li.page > span").text).to eql("Página 10")
    expect(html.css("li.next-page > a").text).to eql("Próxima página")
    expect(html.css("li.previous-page > a").text).to eql("Página anterior")
  end

  it "skips the last item while iterating" do
    values = []
    items = Array.new(11) {|i| "User#{i}" }

    @helper.iterate items do |item|
      values << item
    end

    expect(values).to eql(items[0, 10])
  end

  it "iterates all items when have less records than size" do
    values = []
    items = Array.new(8) {|i| "User#{i}" }

    @helper.iterate items do |item|
      values << item
    end

    expect(values).to eql(items[0, 8])
  end

  it "yields iteration counter" do
    values = []
    indices = []
    items = Array.new(11) {|i| "User#{i}" }

    @helper.iterate items do |item, i|
      values << item
      indices << i
    end

    expect(values).to eql(items[0, 10])
    expect(indices).to eql([*0...10])
  end

  private
  def render(view_name, items)
    view_info = Struct.new(:to_partial_path).new("#{view_name}")
    Nokogiri @view.render(view_info, :items => items)
  end

  def load_view(name)
    File.read(File.dirname(__FILE__) + "/../support/views/#{name}.erb")
  end
end
