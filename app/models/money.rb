class Money
  
  def self.to_mongo(value) 
    if value.is_a?(Integer)
      value
    elsif value.nil? 
      nil
    else   
      value = Integer.to_mongo(value.to_money.cents) 
    end
  end 
 
  def self.from_mongo(value) 
    if value.is_a?(Money) 
      value 
    else 
      value ? new(value) : new(0) 
    end 
  end
  
  def as_json(options)
    # Not currently reflexive
    format
  end
end