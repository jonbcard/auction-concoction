class AuctionDetails
  include MongoMapper::Document

  many :bidders
  many :sales
  many :lots
  
  belongs_to :auction

  ##
  # Add a detached bidder to this auction. This will set the bidder
  # status to 'ACTIVE', validate, then update and save the record.
  #
  def add_bidder(bidder)
    bidder.status = "ACTIVE"
    bidder.valid? &&
      validate_bidder_unique(bidder) &&
      push(:bidders => bidder.to_mongo) &&
      bidders << bidder
  end
  
  def next_bidder_num
    max = 0
    bidders.each { |bidder| max = bidder.number.to_i if bidder.number.to_i > max}
    return max+1
  end

  ##
  # Validate then save an existing bidder.
  #
  def update_bidder(bidder)
    if(bidder.valid? && validate_bidder_unique(bidder))
      # TODO : More effective way to write this as an in-place update?
      AuctionDetails.set({:_id => id, "bidders._id" => bidder.id},
        "bidders.$" => bidder.to_mongo)
      reload
      return true
    else
      return false
    end
  end

  ##
  # Check whether the given bidder number corresponds to an 'ACTIVE' bidder
  # in this auction. Return false if either the bidder number does not exist, or
  # the bidder is 'INACTIVE'.
  #
  def has_active_bidder?(bidder_number)
    active_bidders.include?(bidder_number)
  end


  def add_sale(sale)
    sale.sale_time = Time.now
    sale.valid? &&
      validate_bidder_exists(sale) &&
      push(:sales => sale.to_mongo) &&
      sales << sale && 
      auction.increment(:total_sale_count => 1)
  end

  def remove_sale(sale_id)
    sale = sales.find(sale_id)
    has_active_bidder?(sale.bidder) &&
      pull(:sales => {:_id => BSON::ObjectId(sale_id)}) &&
      auction.decrement(:total_sale_count => 1)
  end

  def add_lot(lot)
    lot.valid? &&
      validate_lot_unique(lot) &&
      push(:lots => lot.to_mongo) &&
      lots << lot && 
      auction.increment(:total_lot_count => 1)
      
  end

  def remove_lot(lot_id)
    pull(:lots => {:_id => BSON::ObjectId(lot_id)}) &&
      auction.decrement(:total_lot_count => 1)
  end

  def sales_and_lots
    "#{sales.size}/#{lots.size}"
  end

  # Stats methods
  
  def gross_sales
    sales.sum{ |s| s.price * s.quantity }
  end

  private
    def validate_bidder_unique(new_bidder)
      bidders.each do |bidder|
        if(bidder.id != new_bidder.id && bidder.number == new_bidder.number)
          new_bidder.errors.add(:number, "cannot be duplicate")
          return false
        end
      end
      return true
    end
    
    def validate_bidder_exists(sale)
      unless active_bidders.include?(sale.bidder)
        sale.errors.add(:bidder, "number must be registered and active.")
        return false
      end
      return true
    end

    def validate_lot_unique(new_lot)
      lots.each do |lot|
        if(lot.id != new_lot.id && lot.number == new_lot.number)
          new_lot.errors.add(:number, "cannot be duplicate")
          return false
        end
      end
      return true
    end

    def active_bidders
      nums = []
      bidders.each { |bidder| nums << bidder.number if bidder.status=="ACTIVE" || bidder.status=="NEW"}
      nums
    end
    
    
end