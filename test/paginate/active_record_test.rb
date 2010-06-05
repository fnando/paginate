require "test_helper"

class ActiveRecordTest < Test::Unit::TestCase
  def setup
    15.times {|i| Thing.create(:name => "Thing #{i}") }
    Paginate::Config.size = 10
  end

  def test_respond_to_paginate_method
    assert_respond_to Thing, :paginate
  end

  def test_paginate_with_defaults
    things = Thing.all(:limit => 11)
    assert_equal things, Thing.paginate.all

    things = Thing.all(:limit => 11, :offset => 11)
    assert_equal things, Thing.paginate(:page => 2).all
  end

  def test_paginate_with_options
    things = Thing.all(:limit => 6)
    assert_equal things, Thing.paginate(:size => 5)

    things = Thing.all(:limit => 6, :offset => 6)
    assert_equal things, Thing.paginate(:size => 5, :page => 2)
  end
end
