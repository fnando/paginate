require "spec_helper"

describe Paginate::Config do
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
    end

    options = {:param_name => :p, :size => 25}
    expect(Paginate::Config.to_hash).to eql(options)
  end
end
