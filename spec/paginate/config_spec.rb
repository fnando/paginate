require "spec_helper"

describe Paginate::Config do
  it "yields configuration class" do
    Paginate.configure do |config|
      config.param_name = :p
      config.size  = 50
    end

    Paginate::Config.param_name.should == :p
    Paginate::Config.size.should == 50
    Paginate::Config.renderer.should == Paginate::Renderer::Basic
  end

  it "deprecates Paginate.setup method" do
    Paginate.should_receive(:warn).once
    Paginate.setup {}
  end

  it "returns configuration as hash" do
    Paginate.configure do |config|
      config.param_name = :p
      config.size = 25
    end

    options = {:param_name => :p, :size => 25}
    Paginate::Config.to_hash.should == options
  end
end
