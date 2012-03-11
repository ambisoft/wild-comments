class TalkersController < ApplicationController
  
  before_filter :resolve_friend!
  
  def index
    
    #entries = @friend.entries(100)
    #@talkers = @friend.max_talkers(entries)
    
    @talkers = [
      {
        :name => 'John Doe',
        :count  => 23        
      },
      {
        :name => 'Tommy Green',
        :count  => 22
      }
    ]
    
    stats = {
      :status         => 0,
      :entries_count  => 100,
      :comments_count => 59,
      :talkers        => @talkers
    }
    
    respond_to do |format|      
      format.html
      format.js { render :json => stats }
    end
  end    

end
