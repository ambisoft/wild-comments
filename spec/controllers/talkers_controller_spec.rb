require 'spec_helper'

describe TalkersController do

  include OauthSpec
  
  describe "GET index" do
    
    before do
      oauth_spec_init      
    end
    
    context 'when logged into facebook' do
      
      before do
        oauth_user_login('1234567890', 42)        
        
        @friend = Friend.new(@graph, 1000, 'Tom')      
        @user.should_receive(:friend).with(@friend.uid).and_return(@friend)      
        
      end
    
      it "returns http success" do      
        
        feed = []        
        @graph.should_receive(:get_connections).with(@friend.uid, 'feed').and_return(feed)
        
        get :index, :friend_id => @friend.uid        
        response.should be_success
        
      end
      
      it "returns commenters in JSON sorted by # of comments" do      
        
        user_john = { 'id' => 1, 'name' => 'John' }
        user_tom = { 'id' => 2, 'name' => 'Tom' }
      
        feed = [
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
                
        feed_with_paging = FeedWithPaging.new(feed, feed.count)
        
        @graph.should_receive(:get_connections).with(@friend.uid, 'feed').and_return(feed_with_paging)
        
        get :index, :friend_id => @friend.uid, :format => :js
        
        result = ActiveSupport::JSON.decode response.body
        result['talkers'].first['name'].should == 'John'
        result['talkers'].first['count'].should == 3
        
        result['talkers'][1]['name'].should == 'Tom'
        result['talkers'][1]['count'].should == 2
                
      end
      
    end
    
    context 'when not logged into facebook' do
      before do
        @oauth.should_receive(:get_user_info_from_cookie).and_return(nil)
        get :index, :friend_id => 1000
      end

      it 'should redirect to the login page' do
        response.should redirect_to(:controller => :facebook, :action => :login)
      end
    end
    
  end

end
