class Auction
  include MongoMapper::Document

  # Keys
  key :title,            String
  key :auction_date,     Date
  key :description,      String

  validates_presence_of :title
end