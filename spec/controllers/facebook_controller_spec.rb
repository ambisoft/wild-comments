require 'spec_helper'

describe FacebookController do

  include OauthSpec
  
  describe 'index with GET' do
    before do      
      oauth_spec_init
    end

    context 'when logged into facebook' do
      before do        
        oauth_user_login('1234567890', 42)
        @friends = mock('friends')
        @user.should_receive(:friends).and_return(@friends)
        get :index
      end

      it do
        response.should be_success
      end

      it 'should assign friends' do
        assigns[:friends].should == @friends
      end
    end

    context 'when not logged into facebook' do
      before do
        @oauth.should_receive(:get_user_info_from_cookie).and_return(nil)
        get :index
      end

      it 'should redirect to the login page' do
        response.should redirect_to(:action => :login)
      end
    end
  end

  describe 'login with GET' do
    before do
      get :login
    end

    it do
      response.should be_success
    end
  end
end
