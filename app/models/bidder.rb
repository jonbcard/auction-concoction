class Bidder
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::Timestamps

  # Keys
  key  :number,     String, :required => true
  key  :first_name, String, :required => true
  key  :last_name,  String, :required => true
  key  :id_number,  String, :required => true
  timestamps!

  embedded_in :auction

  validate :validate_number

  private
  def validate_number
    auction.bidders.each do |bidder|
      if(bidder.id != id && bidder.number == number)
        errors.add(:number, "cannot be duplicate")
      end
    end
  end
end