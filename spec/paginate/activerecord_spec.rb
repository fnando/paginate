require "spec_helper"

describe Thing do
  let!(:things) { Array.new(15) {|i| Thing.create!(name: "THING") } }
  before { Paginate::Config.size = 10 }

  it { expect(Thing).to respond_to(:paginate) }

  it "uses default options" do
    items = Thing.limit(11).to_a
    expect(Thing.paginate.to_a).to eql(items)

    items = Thing.limit(11).offset(10).to_a
    expect(Thing.paginate(page: 2).to_a).to eql(items)
  end

  it "uses custom options" do
    items = Thing.limit(6).to_a
    expect(Thing.paginate(size: 5).to_a).to eql(items)

    items = Thing.limit(6).offset(5).to_a
    expect(Thing.paginate(size: 5, page: 2).to_a).to eql(items)
  end
end
