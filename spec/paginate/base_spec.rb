require "spec_helper"

describe Paginate::Base do
  it "returns page from integer" do
    expect(Paginate::Base.new(12).page).to eql(12)
  end

  it "returns page from string" do
    expect(Paginate::Base.new("12").page).to eql(12)
  end

  it "defaults to page 1" do
    expect(Paginate::Base.new.page).to eql(1)
  end

  it "returns page from options" do
    expect(Paginate::Base.new(:page => 12).page).to eql(12)
  end

  it "returns limit from configuration" do
    Paginate::Config.size = 25
    expect(Paginate::Base.new.limit).to eql(26)
  end

  it "returns limit from options" do
    Paginate::Config.size = 25
    expect(Paginate::Base.new(:size => 13).limit).to eql(14)
  end

  it "returns default limit" do
    Paginate::Config.size = nil
    expect(Paginate::Base.new.limit).to eql(11)
  end

  it "returns offset from configuration" do
    Paginate::Config.size = 15
    expect(Paginate::Base.new(:page => 2).offset).to eql(15)
  end

  it "returns offset from options" do
    expect(Paginate::Base.new(:page => 2, :size => 5).offset).to eql(5)
  end

  it "returns finder options" do
    actual = Paginate::Base.new(:page => 3, :size => 5).to_options
    expected = {:limit => 6, :offset => 10}

    expect(actual).to eql(expected)
  end

  specify {
    Paginate::Base.new(:page => 1, :size => 5, :collection => Array.new(6))
      .should have_next_page
  }

  specify {
    Paginate::Base.new(:page => 1, :size => 5, :collection => Array.new(5))
      .should_not have_next_page
  }

  specify {
    Paginate::Base.new(:page => 2).should have_previous_page
  }

  specify {
    Paginate::Base.new(:page => 1).should_not have_previous_page
  }
end
