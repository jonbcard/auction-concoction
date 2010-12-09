class Auction
  include MongoMapper::Document
  
  # Keys
  key :title,            String, :required => true
  key :auction_date,     Date,   :required => true
  key :description,      String
  
  many :bidders
  many :sales
  many :lots

  def add_bidder(bidder)
    bidder.status = "ACTIVE"
    bidder.valid? &&
      validate_bidder_unique(bidder) &&
      push(:bidders => bidder.to_mongo) &&
      bidders << bidder
  end

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

  def add_sale(sale)
    sale.valid? &&
      validate_bidder_exists(sale) &&
      push(:sales => sale.to_mongo) &&
      sales << sale
  end

  def add_lot(lot)
    lot.valid? &&
      validate_lot_unique(lot) &&
      push(:lots => lot.to_mongo) &&
      lots << lot
  end

  def remove_lot(lot_id)
    pull(:lots => {:_id => lot_id})
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