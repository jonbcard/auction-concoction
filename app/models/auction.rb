class Auction
  include MongoMapper::Document
  # TODO: Using IdentityMap doesn't end up working out
  # too well with some of the patterns being used.
  # Need to reconsider this.
  # plugin MongoMapper::Plugins::IdentityMap
  
  # Keys
  key :title,            String, :required => true
  key :auction_date,     Date,   :required => true
  key :description,      String

  many :bidders
  many :sales

  def add_bidder_and_save(bidder)
    bidder.status = "ACTIVE"
    bidders << bidder
    bidder.valid? && save
  end

  def add_sale_and_save(sale)
    sales << sale
    sale.valid? && save
  end

  def bidder_numbers
    nums = []
    bidders.each { |bidder| nums << bidder.number }
    nums
  end
end