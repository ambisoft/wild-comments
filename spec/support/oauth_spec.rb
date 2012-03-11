module OauthSpec
  
  def oauth_spec_init    
    @oauth = mock('oauth')
    @graph = mock('graph')
    Koala::Facebook::OAuth.should_receive(:new).and_return(@oauth)
  end
  
  def oauth_user_login(access_token, uid)    
    
    user_info = {'access_token' => access_token, 'uid' => uid}
    @oauth.should_receive(:get_user_info_from_cookie).and_return(user_info)
    Koala::Facebook::API.should_receive(:new).with(access_token).and_return(@graph)
    
    @user = User.new(mock('graph'), uid)
    User.should_receive(:new).and_return(@user)        
  end
  
end