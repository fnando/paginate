require "spec_helper"

describe Paginate::Config do
  it "should yield configuration class" do
    Paginate.setup do |config|
      config.param_name = :p
      config.size  = 50
    end

    Paginate::Config.param_name.should == :p
    Paginate::Config.size.should == 50
  end

  it "should return configuration as hash" do
    Paginate.setup do |config|
      config.param_name = :p
      config.size = 25
    end

    options = {:param_name => :p, :size => 25}
    Paginate::Config.to_hash.should == options
  end
end
