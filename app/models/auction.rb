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

  def create_receipt(bidder_id)
    bidder = bidders.find(bidder_id)
    bidder_receipt = BidderReceipt.new(
      :auction    => self,
      :bidder_id  => bidder.id,
      :number     => bidder.number,
      :first_name => bidder.first_name,
      :last_name  => bidder.last_name,
      :id_number  => bidder.id_number
    )
   
    bidder_sales = sales.find_all {|s| s.bidder == bidder_receipt.number}
    bidder_sales.each do |sale|
      sale_hash = sale.to_mongo
      sale_hash.delete(:bidder)
      bidder_receipt.purchases << Purchase.new(sale_hash)
    end
    bidder_receipt.calculate_totals
    bidder_receipt
  end

  def checkout_bidder(bidder_id)
    receipt = create_receipt(bidder_id)
    receipt.save!

    bidder = bidders.find(bidder_id)
    bidder.status = "INACTIVE"
    bidder.receipt = receipt
    update_bidder(bidder)
    receipt
  end

  def bidder_numbers
    nums = []
    bidders.each { |bidder| nums << bidder.number }
    nums
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
      unless bidder_numbers.include?(sale.bidder)
        sale.errors.add(:bidder, "number must be registered.")
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
end