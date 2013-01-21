require "spec_helper"

describe Thing do
  let!(:things) { Array.new(15) {|i| Thing.create!(:name => "THING") } }
  before { Paginate::Config.size = 10 }

  it { expect(Thing).to respond_to(:paginate) }

  it "uses default options" do
    items = Thing.limit(11).all
    expect(Thing.paginate.all).to eql(items)

    items = Thing.limit(11).offset(10).all
    expect(Thing.paginate(:page => 2).all).to eql(items)
  end

  it "uses custom options" do
    items = Thing.limit(6).all
    expect(Thing.paginate(:size => 5).all).to eql(items)

    items = Thing.limit(6).offset(5).all
    expect(Thing.paginate(:size => 5, :page => 2).all).to eql(items)
  end
end
