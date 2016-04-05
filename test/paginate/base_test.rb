require "test_helper"

class BaseTest < Minitest::Test
  let(:scope) { mock }

  test "returns page from integer" do
    assert_equal 12, Paginate::Base.new(scope, 12).page
  end

  test "returns page from string" do
    assert_equal 12, Paginate::Base.new(scope, "12").page
  end

  test "defaults to page 1" do
    assert_equal 1, Paginate::Base.new(scope).page
  end

  test "returns page from options" do
    assert_equal 12, Paginate::Base.new(scope, page: 12).page
  end

  test "returns limtest from configuration" do
    Paginate.configuration.size = 25
    assert_equal 26, Paginate::Base.new(scope).limit
  end

  test "returns limtest from options" do
    Paginate.configuration.size = 25
    assert_equal 14, Paginate::Base.new(scope, size: 13).limit
  end

  test "returns default limit" do
    Paginate.configuration.size = nil
    assert_equal 11, Paginate::Base.new(scope).limit
  end

  test "returns offset from configuration" do
    Paginate.configuration.size = 15
    assert_equal 15, Paginate::Base.new(scope, page: 2).offset
  end

  test "returns offset from options" do
    assert_equal 5, Paginate::Base.new(scope, page: 2, size: 5).offset
  end

  test "returns finder options" do
    actual = Paginate::Base.new(scope, page: 3, size: 5).to_options
    expected = {limit: 6, offset: 10}

    assert_equal expected, actual
  end

  test "has next page" do
    paginate = Paginate::Base.new(scope, page: 1, size: 5, collection: Array.new(6))
    assert paginate.next_page?
  end

  test "doesn't have next page" do
    paginate = Paginate::Base.new(scope, page: 1, size: 5, collection: Array.new(5))
    refute paginate.next_page?
  end

  test "has previous page" do
    paginate = Paginate::Base.new(scope, page: 2)
    assert paginate.previous_page?
  end

  test "doesn't have previous page" do
    paginate = Paginate::Base.new(scope, page: 1)
    refute paginate.previous_page?
  end
end
