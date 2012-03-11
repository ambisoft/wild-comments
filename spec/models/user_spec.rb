require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid)
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
