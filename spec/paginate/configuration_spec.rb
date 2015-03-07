require "spec_helper"

describe Paginate::Configuration do
  context "sets default configuration" do
    it { expect(Paginate.configuration.param_name).to eql(:page) }
    it { expect(Paginate.configuration.renderer).to eql(Paginate::Renderer::List) }
    it { expect(Paginate.configuration.size).to eql(10) }
  end

  it "yields configuration class" do
    Paginate.configure do |config|
      config.param_name = :p
      config.size  = 50
    end

    expect(Paginate.configuration.param_name).to eql(:p)
    expect(Paginate.configuration.size).to eql(50)
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

    expect(Paginate.configuration.to_hash).to eql(options)
  end
end
