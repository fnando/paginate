require "spec_helper"

describe Paginate::Config do
  context "sets default configuration" do
    before do
      load "paginate.rb"
    end

    it { expect(Paginate::Config.param_name).to eql(:page) }
    it { expect(Paginate::Config.renderer).to eql(Paginate::Renderer::List) }
    it { expect(Paginate::Config.size).to eql(10) }
  end

  it "yields configuration class" do
    Paginate.configure do |config|
      config.param_name = :p
      config.size  = 50
    end

    expect(Paginate::Config.param_name).to eql(:p)
    expect(Paginate::Config.size).to eql(50)
  end

  it "returns configuration as hash" do
    Paginate.configure do |config|
      config.param_name = :p
      config.size = 25
      config.renderer = Paginate::Renderer::List
    end

    options = {
      param_name: :p,
      size: 25,
      renderer: Paginate::Renderer::List
    }

    expect(Paginate::Config.to_hash).to eql(options)
  end
end
