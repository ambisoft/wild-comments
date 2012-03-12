require 'spec_helper'

describe Friend do
  
  before do
    @graph = mock('graph api')
    @uid = 999
    @name = 'Mark'
    @friend = Friend.new(@graph, @uid, @name)
  end
  
  describe 'accessors' do
    it 'should return his user id' do
      @friend.uid.should == 999
    end
    
    it 'should return his name' do
      @friend.name.should == 'Mark'
    end
    
  end
  
  describe "entries" do
    it "should fetch 2 feed entries" do
      feed = [
        { :name => 'Entry #1' },
        { :name => 'Entry #2' }
      ]
      
      @graph.should_receive(:get_connections).with(@friend.uid, 'feed').once.and_return(feed)
      entries = @friend.entries(2)
      entries.should == feed      
    end
    
    it "should fetch 5 feed entries with paging" do
      
      feed_entries = [
        { :name => 'Entry #1' },
        { :name => 'Entry #2' },
        { :name => 'Entry #3' },
        { :name => 'Entry #4' },
        { :name => 'Entry #5' }
      ]
                     
      feed_with_paging = FeedWithPaging.new(feed_entries, 2)
      
      @graph.should_receive(:get_connections).with(@friend.uid, 'feed').once.and_return(feed_with_paging)
      entries = @friend.entries(5)
      entries.should == feed_entries   
    end
    
  end
  
  
  describe 'sorting commenters' do
    
    it 'should return commenters with most number of comments first' do
      
      commenters = [
        { :name => 'John Smith', :count => 3 },
        { :name => 'Mark Smith', :count => 4 },
        { :name => 'Tim Jones', :count => 5 }
      ]
      
      @friend.sort_talkers(commenters).should == [
        { :name => 'Tim Jones', :count => 5 },
        { :name => 'Mark Smith', :count => 4 },
        { :name => 'John Smith', :count => 3 }        
      ]
      
    end
  end
  
end
