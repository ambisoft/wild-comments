class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end
  
  def friend(friend_id)
    response = graph.get_object(friend_id)
    Friend.new(graph, friend_id, response['name'])
  end
    
  def friends    
    @friends ||= graph.get_connections(uid, 'friends').sort {
      |f1, f2| f1['name'] <=> f2['name']
    }    
  end

  def likes
    @likes ||= graph.get_connections(uid, 'likes')
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end
end
