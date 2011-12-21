class Sale
  include MongoMapper::EmbeddedDocument

  SALES_STATES = ['PENDING', 'SETTLED']
  
  # Keys
  key  :lot,          String,  :required => true
  key  :consignee_id, BSON::ObjectId
  key  :description,  String,  :required => true
  key  :bidder,       String,  :required => true
  key  :price,        Money,   :required => true
  key  :quantity,     Integer, :required => true
  key  :sale_time,    Time,    :required => true
  key  :state,        String
  
  embedded_in :auction_details
  
  # Validations
  # Why is the lot # not required unique? The same lot #
  # can be resold multiple times (at different prices) to 
  # different bidders when there is a quantity of more than 1.
  # Lots are not an indivisible unit.
  validate :validate_price
  
  def validate_price
    unless price.cents > 0 
      errors.add(:price, "must be in valid form and greater than zero")
    end
  end

  # Chart Visualization methods
  def js_datapoints
    "[#{truncated_js_time}, #{quantity}, #{price*quantity}]"
  end

  private
    def truncated_js_time
      year = sale_time.getlocal.year
      month = sale_time.getlocal.month
      day = sale_time.getlocal.day
      hour = sale_time.getlocal.hour
      min = (sale_time.getlocal.min / 10)*10
      "new Date(#{year}, #{month}, #{day}, #{hour}, #{min}, 0)"
    end
end