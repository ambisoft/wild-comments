class Friend
  
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    self.graph = graph
    self.uid = uid
  end

  def entries(max_to_fetch = 100)
    result = []
    feed = graph.get_connections(uid, 'feed')
    while feed.present? && result.count < max_to_fetch
      result += feed
      feed = feed.next_page
    end
    result
  end
    
  def max_talkers(entries)
    
    talkers = {}    
    entries.each do |entry|      
      comments = comments_for_entry(entry)
      comments.each do |comment|
        author = comment['from']
        talkers[author['id']] ||= {
              :uid    => author['id'],
              :name   => author['name'],
              :count  => 0
        }        
        talkers[author['id']][:count] += 1
      end
    end
    
    # sort the talkers based on # of the comments:
    talkers.sort { |t1, t2| t1[:count] <=> t2[:count] }
    
  end
  
  #
  # Sometimes a feed entry record contains all the comments, but 
  # sometimes it does not.
  #  
  def comments_for_entry(entry)
    comments = entry['comments']
    if comments['count'] == comments['data'].count
      comments['data']
    else
      graph.object_get(entry['id'])['comments']['data']
    end
  end
  
end
