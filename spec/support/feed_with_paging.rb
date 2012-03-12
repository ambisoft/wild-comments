class FeedWithPaging
        
  attr_accessor :data, :page_size

  def initialize(data, page_size)
    self.data = data   
    self.page_size = page_size
    @page = 0
  end

  def empty?
    count == 0
  end
  
  def next_page
    @page += 1
    self
  end
  
  def count
    to_a.count
  end

  def to_a    
    from_idx = @page * page_size
    if from_idx >= data.count
      []
    else      
      to_idx = [from_idx + page_size, data.count].min
      data[from_idx ... to_idx]
    end
    
  end        
    
end   