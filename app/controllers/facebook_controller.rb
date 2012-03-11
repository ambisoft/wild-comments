class FacebookController < ApplicationController
  
  before_filter :require_login, :except => :login  
  
  def index
    @friends = current_user.friends    
  end

  def login
  end  
    
end
