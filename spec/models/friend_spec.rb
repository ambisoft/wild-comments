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
  
  describe 'comments for entry' do
    
    it 'should return comments in the record if all are there' do
      
      comments = [
        { 'from' => 'User 1' },
        { 'from' => 'User 2' }
      ]
      
      entry = {
        'comments' => {
          'count' => 2,
          'data'  => comments
        }
      }
      
      @friend.comments_for_entry(entry).should == comments
      
    end
    
    it 'should fetch comments from the Graph if not all are in the record' do
      
      all_comments = [
        { 'from' => 'User 1' },
        { 'from' => 'User 2' },
        { 'from' => 'User 3' },
        { 'from' => 'User 4' },
        { 'from' => 'User 5' }        
      ]
      
      entry = {
        'id'  => 123,
        'comments' => {
          'count' => 5,
          'data'  => [
            { 'from' => 'User 1' },
            { 'from' => 'User 2' }
          ]
        }
      }
      
      full_entry = {
        'comments' => {
          'count' => 5,
          'data'  => all_comments
        }
      }
      
      @graph.should_receive(:get_object).with(entry['id']).once.and_return(full_entry)
      
      @friend.comments_for_entry(entry).should == all_comments
      
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
  
  describe 'max_talkers' do 
        
    it 'should return empty list if there are no entries' do
      @friend.max_talkers([]).should == []
    end
    
    it 'should return empty list if there are no comments' do     
      entries = [
        { 'id'  => 123 },
        { 'id'  => 124 }
      ]      
      @friend.max_talkers(entries).should == []
    end
    
    it 'should return John who has 5 comments' do
      
      user_john = { 'id' => 1, 'name' => 'John' }
      user_tom = { 'id' => 2, 'name' => 'Tom' }
      
      entries = [
      {
        'id'  => 123,
        'comments' => {
          'count' => 2,
          'data'  => [
            { 'from' => user_john },
            { 'from' => user_tom }
          ]
        }
      },
      {
        'id'  => 124,
        'comments' => {
          'count' => 3,
          'data'  => [
            { 'from' => user_john },
            { 'from' => user_john },
            { 'from' => user_tom },
          ]
        }
      }
      ]
      
      @friend.max_talkers(entries).should == [  
        {
          :uid   => 1,
          :name => 'John',
          :count => 3
        },
        {
          :uid   => 2,
          :name => 'Tom',
          :count => 2
        }
      ]
      
    end
    
  end
  
end
