class FriendsController < ApplicationController
  
  def show        
    
    @friend = current_user.friend(params[:id])
    return redirect_to root_path unless @friend    
    
  end
  
end
