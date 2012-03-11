class TalkersController < ApplicationController
  
  before_filter :resolve_friend!
  
  def index
    
    entries = @friend.entries(1)
    @talkers = @friend.max_talkers(entries)
    
    respond_to do |format|      
      format.html
      format.js { render :json => @talkers }
    end
  end    

end
