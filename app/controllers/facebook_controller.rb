class FacebookController < ApplicationController
  
  before_filter :require_login, :except => :login  
  
  def index
    #@likes_by_category = current_user.likes_by_category        
    @likes_by_category = []
    @friends = current_user.friends    
  end

  def login
  end  
    
end
