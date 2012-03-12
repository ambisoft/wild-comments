require 'spec_helper'

describe FriendsController do

  include OauthSpec
  
  describe "GET 'show'" do
    
    before do
      oauth_spec_init      
    end
    
    context 'when logged into facebook' do
      
      before do
        oauth_user_login('1234567890', 42)        
      end
       
      it "returns http success" do        
        @entries = []        
        @friend = Friend.new(@graph, 1000, 'Tom')      
        @user.should_receive(:friend).with(1000).and_return(@friend)
        
        # with async feed fetch it does not happen anymore
        #@graph.should_receive(:get_connections).with(1000, 'feed').and_return(@entries)
        
        get :show, :id => @friend.uid
        response.should be_success
        
      end
      
    end
  end

end
