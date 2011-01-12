require "spec_helper"

describe Paginate::Base do
  it "should return page from integer" do
    Paginate::Base.new(12).page.should == 12
  end

  it "should return page from string" do
    Paginate::Base.new("12").page.should == 12
  end

  it "should default to page 1" do
    Paginate::Base.new.page == 1
  end

  it "should return page from options" do
    Paginate::Base.new(:page => 12).page == 12
  end

  it "should return limit from configuration" do
    Paginate::Config.size = 25
    Paginate::Base.new.limit.should == 26
  end

  it "should return limit from options" do
    Paginate::Config.size = 25
    Paginate::Base.new(:size => 13).limit.should == 14
  end

  it "should return default limit" do
    Paginate::Config.size = nil
    Paginate::Base.new.limit.should == 11
  end

  it "should return offset from configuration" do
    Paginate::Config.size = 15
    Paginate::Base.new(:page => 2).offset.should == 16
  end

  it "should return offset from options" do
    Paginate::Base.new(:page => 2, :size => 5).offset.should == 6
  end

  it "should return finder options" do
    actual = Paginate::Base.new(:page => 3, :size => 5).to_options
    expected = {:limit => 6, :offset => 12}

    actual.should == expected
  end

  specify {
    Paginate::Base.new(:page => 1, :size => 5, :collection => Array.new(6)).should have_next_page
  }

  specify {
    Paginate::Base.new(:page => 1, :size => 5, :collection => Array.new(5)).should_not have_next_page
  }

  specify {
    Paginate::Base.new(:page => 2).should have_previous_page
  }

  specify {
    Paginate::Base.new(:page => 1).should_not have_previous_page
  }
end
