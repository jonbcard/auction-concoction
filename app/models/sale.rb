class Sale
  include MongoMapper::EmbeddedDocument

  # Keys
  key  :lot,          String,  :required => true
  key  :description,  String,  :required => true
  key  :bidder,       String,  :required => true
  key  :price,        Money,   :required => true
  key  :quantity,     Integer, :required => true
  
  embedded_in :auction
  
  # Validations
  # Why is the lot # not required unique? The same lot #
  # can be resold multiple times (at different prices) to 
  # different bidders when there is a quantity of more than 1.
  # Lots are not an indivisible unit.
  #validate :validate_bidder TODO: bring back validate_bidder (somehow)
  validate :validate_price

  private
  def validate_bidder
    unless auction.bidder_numbers.include?(bidder)
      errors.add(:bidder, "number must be registered.")
    end
  end
  
  def validate_price
    unless price.cents > 0 
      errors.add(:price, "must be in valid form and greater than zero")
    end
  end
end