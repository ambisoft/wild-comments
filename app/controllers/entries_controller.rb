class EntriesController < ApplicationController
  
  before_filter :require_login
  before_filter :resolve_friend!
  
  def index    
    @entries = @friend.entries(10)        
    respond_to do |format|      
      format.html { render :layout => false }
      format.js { render :json => entries }
    end
  end    

end
