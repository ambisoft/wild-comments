class FriendsController < ApplicationController
  
  before_filter :resolve_friend!
  
  def show    
    @entries = @friend.entries(10)    
  end      
  
end
