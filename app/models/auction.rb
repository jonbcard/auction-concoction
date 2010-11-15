class Auction
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap
  
  # Keys
  key :title,            String, :required => true
  key :auction_date,     Date
  key :description,      String

  many :bidders
  many :sales

  def add_bidder_and_save(bidder)
    bidder.auction = self
    bidders << bidder
    bidder.valid? && save
  end

  def bidder_numbers
    nums = []
    bidders.each { |bidder|
      nums << bidder.number
    }
    nums
  end
end