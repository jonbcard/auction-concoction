class Auction
  include MongoMapper::Document
  
  # Keys
  key :title,            String
  key :start,            Time
  key :end,              Time
  key :description,      String
  key :location_id,      BSON::ObjectId
  key :auction_id,       BSON::ObjectId

  key :active_bidders,      Integer
  key :total_lots_created,  Integer
  key :total_lots_sold,     Integer
  key :total_sales,         Money

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