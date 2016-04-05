require "test_helper"

class ConfigurationTest < Minitest::Test
  test "sets default configuration" do
    assert_equal :page, Paginate.configuration.param_name
    assert_equal Paginate::Renderer::List, Paginate.configuration.renderer
    assert_equal 10, Paginate.configuration.size
  end

  test "yields configuration class" do
    Paginate.configure do |config|
      config.param_name = :p
      config.size  = 50
    end

    assert_equal :p, Paginate.configuration.param_name
    assert_equal 50, Paginate.configuration.size
  end

  test "returns configuration as hash" do
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

    assert_equal options, Paginate.configuration.to_hash
  end
end
