require "test_helper"

class ConfigTest < Test::Unit::TestCase
  def test_yield_configuration_class
    Paginate.setup do |config|
      config.param_name = :p
      config.size  = 50
    end

    assert_equal :p, Paginate::Config.param_name
    assert_equal 50, Paginate::Config.size
  end

  def test_return_config_as_hash
    Paginate.setup do |config|
      config.param_name = :p
      config.size = 25
    end

    options = {:param_name => :p, :size => 25}
    assert_equal options, Paginate::Config.to_hash
  end
end
