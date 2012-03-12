class FriendsController < ApplicationController
  
  before_filter :require_login
  before_filter :resolve_friend!
  
  def show    
    #@entries = @friend.entries(10)    
    @entries = []
  end      
  
end
