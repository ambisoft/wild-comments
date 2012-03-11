class TalkersController < ApplicationController
  
  before_filter :require_login
  before_filter :resolve_friend!
  
  def index
    
    entries = @friend.entries(100)
    @talkers = @friend.max_talkers(entries)
        
    #Rails::logger.debug(@talkers)
    
    stats = {
      :status         => 0,
      :entries_count  => 0,
      :comments_count => 0,
      :talkers        => @talkers
    }
    
    respond_to do |format|      
      format.html
      format.js { render :json => stats }
    end
  end    

end
