require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid, 'Blake Jones')
  end
  
  describe "to_hash" do
    it "should return hash representation" do
      @user.to_hash.should == {
        'id'    => @user.uid,
        'name'  => @user.name
      }
    end
    
  end
  
  describe "retrieving friends" do
    before do 
      @friends = [
        { 'id' => 100, 'name' => 'John'},
        { 'id' => 101, 'name' => 'Tom'}
      ]
      @graph.should_receive(:get_connections).with(@uid, 'friends').once.and_return(@friends)
    end
  
    describe 'friends' do
      it 'should retrieve friends via the graph api' do
        @user.friends.should == @friends
      end
    end

  end
  
  
end
