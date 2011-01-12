require "spec_helper"

describe Thing do
  let(:things) { Array.new(15) {|i| Thing.create(:name => "Thing #{i}") } }
  before { Paginate::Config.size = 10 }

  specify { Thing.should respond_to(:paginate) }

  it "should use default options" do
    Thing.paginate.all.should == Thing.all(:limit => 11)
    Thing.paginate(:page => 2).all.should == Thing.all(:limit => 11, :offset => 11)
  end

  it "should use custom options" do
    Thing.paginate(:size => 5).should == Thing.all(:limit => 6)
    Thing.paginate(:size => 5, :page => 2).should == Thing.all(:limit => 6, :offset => 6)
  end
end
