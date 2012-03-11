class Friend
  
  attr_accessor :uid, :graph, :name

  def initialize(graph, uid, name)
    self.graph  = graph
    self.uid    = uid
    self.name   = name
  end

  def entries(max_to_fetch = 100)    
    Rails::logger.debug("Fetching feed")
    feed = graph.get_connections(uid, 'feed')
    Rails::logger.debug("Fetched " + feed.count.to_s)    
    result = feed
    until (feed.empty? || result.count >= max_to_fetch)
      Rails::logger.debug("Fetching the next page")
      feed = feed.next_page
      result += feed
      Rails::logger.debug("Result size is #{result.count}")
    end
    result.count > max_to_fetch ? result[0, max_to_fetch] : result
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
    talkers.sort { |t1, t2| t2[:count] <=> t1[:count] }
    
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
      graph.get_object(entry['id'])['comments']['data']
    end
  end
  
end
