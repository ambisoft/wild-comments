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
