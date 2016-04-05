require "test_helper"

class ActiverecordTest < Minitest::Test
  let(:things) { Array.new(15) {|i| Thing.create!(name: "THING") } }

  setup do
    things
    Paginate.configuration.size = 10
  end

  test "responds to paginate" do
    assert Thing.respond_to?(:paginate)
  end

  test "uses default options" do
    items = Thing.limit(11).to_a
    assert_equal items, Thing.paginate.to_a

    items = Thing.limit(11).offset(10).to_a
    assert_equal items, Thing.paginate(page: 2).to_a
  end

  test "uses custom options" do
    items = Thing.limit(6).to_a
    assert_equal items, Thing.paginate(size: 5).to_a

    items = Thing.limit(6).offset(5).to_a
    assert_equal items, Thing.paginate(size: 5, page: 2).to_a
  end
end
