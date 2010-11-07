class Auction
  include MongoMapper::Document

  many :bidders
  
  # Keys
  key :title,            String
  key :auction_date,     Date
  key :description,      String
  

  validates_presence_of :title
  validates_associated  :bidders
end