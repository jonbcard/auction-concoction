class Auction
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap

  many :bidders
  many :sales
  
  # Keys
  key :title,            String
  key :auction_date,     Date
  key :description,      String
  
  validates_presence_of :title
end