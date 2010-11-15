class Bidder
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::Timestamps 

  # Keys
  key  :number,     String, :required => true
  key  :first_name, String, :required => true
  key  :last_name,  String, :required => true
  key  :id_number,  String, :required => true
  timestamps!

  belongs_to :auction

  validate :validate_number

  private
  def validate_number
    self.auction.bidders.each { |bidder|
      if(not bidder.number.equal?(self) && bidder.number == number)
        errors.add(:number, "cannot be duplicate")
      end
    }
    #self.auction.bidders.find { |bidder|
    #  true
    #}

    #unless self.auction.bidders { |b| b != self && b.number == number}.nil?
    #  errors.add(:number, "cannot be null")
    #end
  end
end