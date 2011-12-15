class Auction
  include MongoMapper::Document
  
  # Keys
  key :title,            String,           :required => true
  key :start,            Time,             :required => true
  key :end,              Time,             :required => true          
  key :description,      String
  key :location_id,      BSON::ObjectId

  key :active_bidders,    Integer, :default => 0
  key :total_lot_count,   Integer, :default => 0
  key :total_sale_count,  Integer, :default => 0
  key :total_sales,       Money,   :default => Money.new(0)

  one :details, :class_name => 'AuctionDetails'
  
  def self.from_map(auction_map)
    auction = Auction.new(
      :title => auction_map['title'],
      :description => auction_map['description'],
      :start => Time.parse(auction_map['start']),
      :end => Time.parse(auction_map['end']),
      :location_id => auction_map['location_id']
    )
    auction.details = AuctionDetails.new()
    return auction
  end
  
  def update_from_map(auction_map)
    self.title = auction_map['title']
    self.description = auction_map['description']
    self.start = Time.parse(auction_map['start'])
    self.end   = Time.parse(auction_map['end'])
    self.location_id = auction_map['location_id']
  end
end