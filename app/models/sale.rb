class Sale
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::Timestamps 

  # Keys
  key  :lot,          String, :required => true
  key  :description,  String, :required => true
  key  :bidder,       String, :required => true
  key  :price,        String, :required => true
  key  :quantity,     String, :required => true
  timestamps!
  
  embedded_in :auction
  
  # Validations
  # Why is the lot # not required unique? The same lot #
  # can be resold multiple times (at different prices) to 
  # different bidders when there is a quantity of more than 1.
  # Lots are not an indivisible unit.
  validate :validate_bidder

  private
  def validate_bidder
    unless auction.bidder_numbers.include?(bidder)
      errors.add(:bidder, "number must be registered.")
    end
  end
end