module FriendsHelper

  def friend_link(friend, label)
    link_to label, friend_path(friend['id']), 
            :title => 'See details of ' + friend['name']
  end
  

  def friend_url_picture(friend)
    Friend.url_picture(friend['id'])
  end
end
