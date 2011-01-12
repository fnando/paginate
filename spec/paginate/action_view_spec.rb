# -*- encoding: utf-8 -*-
require "spec_helper"

describe "ActionView support" do
  before do
    @request = OpenStruct.new
    @params = Hash.new

    @controller = ThingsController.new
    @controller.params = @params

    @view = ActionView::Base.new
    @view.controller = @controller
    @view.extend(Paginate::Helper)
    @view.stub :request => @request

    @helper = Object.new
    @helper.extend(Paginate::Helper)

    Paginate.setup do |config|
      config.param_name = :page
      config.size  = 10
    end

    I18n.locale = :en
  end

  it "should display pagination list" do
    @request.fullpath = "/some/path?page=1"
    html = render(:default, [])

    html.css("ul.paginate").count.should == 1
    html.css("ul.paginate > li").count.should == 3
  end

  it "should add .disabled class when have no items" do
    @request.fullpath = "/some/path"
    html = render(:default, [])

    html.css("ul.paginate.disabled").first.should_not be_nil
  end

  it "should display next page link" do
    @request.fullpath = "/some/path?page=1"
    html = render(:default, Array.new(11))
    link = html.css("li.next-page > a").first

    link.should_not be_nil
    link["href"].should == "/some/path?page=2"
    link.text.should == "Next page"
  end

  it "should display next page link using proc as url" do
    @request.fullpath = "/some/path?page=1"
    html = render(:block_as_url, Array.new(11))
    link = html.css("li.next-page > a").first

    link.should_not be_nil
    link["href"].should == "/some/path/2"
    link.text.should == "Next page"
  end

  it "should display previous page link" do
    @params[:page] = 2
    @request.fullpath = "/some/path?page=2"
    html = render(:default, Array.new(11))
    link = html.css("li.previous-page > a").first

    link.should_not be_nil
    link["href"].should == "/some/path?page=1"
    link.text.should == "Previous page"
  end

  it "should disable element when have no next page" do
    @request.fullpath = "/some/path?page=1"
    html = render(:default, Array.new(10))
    link = html.css("li.next-page > a").first
    span = html.css("li.next-page.disabled > span").first

    link.should be_nil
    span.should_not be_nil
    span.text.should == "Next page"
  end

  it "should disable element when have no previous page" do
    @request.fullpath = "/some/path?page=1"
    html = render(:default, Array.new(10))
    link = html.css("li.previous-page > a").first
    span = html.css("li.previous-page.disabled > span").first

    link.should be_nil
    span.should_not be_nil
    span.text.should == "Previous page"
  end

  it "should display current page" do
    @params[:page] = 10
    @request.fullpath = "/some/path?page=10"
    html = render(:default, [])
    span = html.css("li.page > span").first

    span.should_not be_nil
    span.text.should == "Page 10"
  end

  it "should translate strings" do
    I18n.locale = :"pt-BR"

    @params[:page] = 10
    @request.fullpath = "/some/path?page=10"
    html = render(:default, Array.new(11))

    html.css("li.page > span").text.should == "Página 10"
    html.css("li.next-page > a").text.should == "Próxima página"
    html.css("li.previous-page > a").text.should == "Página anterior"
  end

  it "should skip the last item while iterating" do
    values = []
    items = Array.new(11) {|i| "User#{i}" }

    @helper.iterate items do |item|
      values << item
    end

    values.should == items[0, 10]
  end

  it "should iterate all items when have less records than size" do
    values = []
    items = Array.new(8) {|i| "User#{i}" }

    @helper.iterate items do |item|
      values << item
    end

    values.should == items[0, 8]
  end

  it "should yield iteration counter" do
    values = []
    indices = []
    items = Array.new(11) {|i| "User#{i}" }

    @helper.iterate items do |item, i|
      values << item
      indices << i
    end

    values.should == items[0, 10]
    indices.should == (0...10).to_a
  end

  private
  def render(view_name, items)
    Nokogiri @view.render(:inline => load_view(view_name), :locals => {:items => items})
  end

  def load_view(name)
    File.read(File.dirname(__FILE__) + "/../support/views/#{name}.erb")
  end
end
