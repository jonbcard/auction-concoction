class AuctionRollup
  include MongoMapper::Document
  
  # Keys
  key :title,            String, :required => true
  key :auction_date,     Date,   :required => true
  key :auction_time,     Time
  key :description,      String

  key :active_bidders,      Integer
  key :total_lots_created,  Integer
  key :total_lots_sold,     Integer
  key :total_sales,         Money

  many :lots_sold
  many :gross_sales

  def add_sale(sale)
    lots_sold << IntegerDataPoint.new(:time => sale.sale_time, :value => sale.quantity)
    gross_sales << MoneyDataPoint.new(:time => sale.sale_time, :value => price*quantity)
  end


end

class IntegerDataPoint
  include MongoMapper::EmbeddedDocument

  key :time,            Time
  key :value,           Integer

  def to_js
    year = time.getlocal.year
    month = time.getlocal.month
    day = time.getlocal.day
    hour = time.getlocal.hour
    min = (time.getlocal.min / 10)*10
    "[new Date(#{year}, #{month}, #{day}, #{hour}, #{min}, 0), #{value}]"
  end
end

class MoneyDataPoint
  include MongoMapper::EmbeddedDocument

  key :time,            Time
  key :value,           Money

  def to_js
    year = time.getlocal.year
    month = time.getlocal.month
    day = time.getlocal.day
    hour = time.getlocal.hour
    min = (time.getlocal.min / 10)*10
    "[new Date(#{year}, #{month}, #{day}, #{hour}, #{min}, 0), #{value}]"
  end
end