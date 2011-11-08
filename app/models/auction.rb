class Auction
  include MongoMapper::Document
  plugin  MongoMapper::Plugins::CustomFieldPlugin
  #plugin  MongoMapper::Plugins::MetaData

  
  # Keys
  key :title,            String, :required => true
  key :start,            Time
  key :end,              Time
  key :description,      String
  key :location_id,      BSON::ObjectId
  
  many :bidders
  many :sales
  many :lots
  one  :location
  
  validate_custom
  
  def self.from_map(auction_map)
    auction = Auction.new()
    auction.title = auction_map['title']
    auction.description = auction_map['description']
    auction.start = Time.parse(auction_map['start'])
    auction.end   = Time.parse(auction_map['end'])
    auction.location_id = auction_map['location_id']
    return auction
  end
  
  def update_from_map(auction_map)
    self.title = auction_map['title']
    self.description = auction_map['description']
    self.start = Time.parse(auction_map['start'])
    self.end   = Time.parse(auction_map['end'])
    self.location_id = auction_map['location_id']
  end

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

  ##
  # Validate then save an existing bidder.
  #
  def update_bidder(bidder)
    if(bidder.valid? && validate_bidder_unique(bidder))
      # TODO : More effective way to write this as an in-place update?
      Auction.set({:_id => id, "bidders._id" => bidder.id},
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
      sales << sale
  end

  def remove_sale(sale_id)
    sale = sales.find(sale_id)
    has_active_bidder?(sale.bidder) &&
      pull(:sales => {:_id => BSON::ObjectId(sale_id)})
  end

  def add_lot(lot)
    lot.valid? &&
      validate_lot_unique(lot) &&
      push(:lots => lot.to_mongo) &&
      lots << lot
  end

  def remove_lot(lot_id)
    pull(:lots => {:_id => BSON::ObjectId(lot_id)})
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
      bidders.each { |bidder| nums << bidder.number if bidder.status=="ACTIVE"}
      nums
    end
end