require 'spec_helper'

describe FeedWithPaging do
  
  describe "empty feed" do
    
    before do
      @feed = FeedWithPaging.new([], 10)
    end
    
    it "should be empty" do
      @feed.should be_empty
    end
    
    it "should have count 0" do
      @feed.count.should == 0
    end
    
    it "should return empty array" do
      @feed.to_a.should == []
    end
    
  end
  
  describe "5-element feed with 10-element page" do
    
    before do
      @feed = FeedWithPaging.new((1..5).to_a, 10)
    end
    
    it "should return all 5 elements" do
      @feed.to_a.should == (1..5).to_a
    end
    
    it "should not be empty" do
      @feed.should_not be_empty
    end
    
    it "should return count 5" do
      @feed.count.should == 5
    end
    
  end
  
  describe "10-element feed with 10-element page" do
    before do
      @feed = FeedWithPaging.new((1..10).to_a, 10)
    end
    
    it "should return count 10" do
      @feed.count.should == 10
    end
    
    it "should return all 10 elements" do
      @feed.to_a.should == (1..10).to_a
    end
    
  end
  
  describe "11-element feed with 10-element page" do
    before do
      @feed = FeedWithPaging.new((1..11).to_a, 10)
    end
    
    it "should return count 10" do
      @feed.count.should == 10
    end
    
    it "should return first 10 elements" do
      @feed.to_a.should == (1..10).to_a
    end
    
    it "for 2nd page should return the last element (11)" do
      @feed.next_page.to_a.should == [11]
    end
    
    it "for 2nd page count should return 1" do
      @feed.next_page.count.should == 1
    end
    
    it "for 3rd page should return empty array" do
      @feed.next_page.next_page.to_a.should == []
    end
    
    it "3rd page should be empty" do
      @feed.next_page.next_page.should be_empty
    end
    
  end
  
end
