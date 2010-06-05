require "test_helper"

class BaseTest < Test::Unit::TestCase
  def test_page_from_integer
    @base = Paginate::Base.new(12)
    assert_equal 12, @base.page
  end

  def test_page_from_string
    @base = Paginate::Base.new("12")
    assert_equal 12, @base.page
  end

  def test_default_page_value
    @base = Paginate::Base.new
    assert_equal 1, @base.page
  end

  def test_page
    @base = Paginate::Base.new(:page => 0)
    assert_equal 1, @base.page
  end

  def test_limit_from_config
    Paginate::Config.size = 25
    @base = Paginate::Base.new

    assert_equal 26, @base.limit
  end

  def test_limit_from_options
    Paginate::Config.size = 25
    @base = Paginate::Base.new(:size => 13)

    assert_equal 14, @base.limit
  end

  def test_default_limit
    Paginate::Config.size = nil
    @base = Paginate::Base.new

    assert_equal 11, @base.limit
  end

  def test_offset_from_config
    Paginate::Config.size = 15
    @base = Paginate::Base.new(:page => 2)

    assert_equal 16, @base.offset
  end

  def test_offset_from_options
    @base = Paginate::Base.new(:page => 2, :size => 5)

    assert_equal 6, @base.offset
  end

  def test_return_finder_options
    @base = Paginate::Base.new(:page => 3, :size => 5)

    options = {:limit => 6, :offset => 12}
    assert_equal options, @base.to_options
  end

  def test_next_page
    @base = Paginate::Base.new(:page => 1, :size => 5, :collection => Array.new(6))
    assert @base.next_page?
  end

  def test_no_next_page
    @base = Paginate::Base.new(:page => 1, :size => 5, :collection => Array.new(5))
    assert !@base.next_page?
  end

  def test_previous_page
    @base = Paginate::Base.new(:page => 2)
    assert @base.previous_page?
  end

  def test_no_previous_page
    @base = Paginate::Base.new(:page => 1)
    assert !@base.previous_page?
  end
end
