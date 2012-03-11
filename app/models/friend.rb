class Friend
  
  attr_accessor :uid, :graph, :name

  def initialize(graph, uid, name)
    self.graph  = graph
    self.uid    = uid
    self.name   = name
  end
  
  def self.url_picture(id)
    "http://graph.facebook.com/#{id}/picture"
  end
  
  def url_profile_picture
    Friend.url_picture(uid)    
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
    
    Rails::logger.debug('Max talkers: entries count is ' + entries.count.to_s)
        
    talkers = {}
    
    entries.each_with_index do |entry, i|
      
      Rails::logger.debug("Processing entry #{i}")
      
      comments = comments_for_entry(entry)
      
      #Rails::logger.debug('Comments for entry: ' + comments.count.to_s)
      
      comments.each do |comment|
        author = comment['from']
        
        #Rails::logger.debug('Comment author')
        #Rails::logger.debug(author)
        
        talkers[author['id']] ||= {
              :uid    => author['id'],
              :name   => author['name'],
              :count  => 0
        }        
        talkers[author['id']][:count] += 1
      end
    end
    
    #Rails::logger.debug("Talkers")
    #Rails::logger.debug(talkers.values)
    
    sort_talkers(talkers.values)
        
  end
  
  def sort_talkers(talkers)
    talkers.sort { |t1, t2| t2[:count] <=> t1[:count] }
  end
  
  #
  # Sometimes a feed entry record contains all the comments, but 
  # sometimes it does not.
  #  
  def comments_for_entry(entry)
    
    comments = entry['comments']
    
    if comments
      if comments['count'] == comments['data'].to_a.count
        comments['data'].to_a
      else
        graph.get_object(entry['id'])['comments']['data']
      end
    else
      []
    end
  end
  
end
