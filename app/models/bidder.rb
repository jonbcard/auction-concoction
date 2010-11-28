class Bidder
  include MongoMapper::EmbeddedDocument

  BIDDER_STATES = ["ACTIVE", "INACTIVE"]

  # Keys
  key  :number,     String, :required => true
  key  :first_name, String, :required => true
  key  :last_name,  String, :required => true
  key  :id_number,  String, :required => true
  key  :status,     String

  embedded_in :auction

  validate :validate_number
  validate :validate_status

  private

  def validate_number
    auction.bidders.each do |bidder|
      if(bidder.id != id && bidder.number == number)
        errors.add(:number, "cannot be duplicate")
      end
    end
  end

  def validate_status
    unless !status.nil? || BIDDER_STATES.include?(status)
      errors.add(:status, "is not a valid state")
    end
  end
end