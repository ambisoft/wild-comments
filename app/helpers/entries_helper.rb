module EntriesHelper  
  def entry_partial(entry)    
    types = ['status', 'video', 'link', 'photo']
    name = types.include?(entry['type']) ? entry['type'] : 'status'
    "entries/#{name}"    
  end
  
  def entry_date(date_string)
    Time.parse(date_string).strftime('%Y-%m-%d %I:%M %p %Z')
  end
  
end
