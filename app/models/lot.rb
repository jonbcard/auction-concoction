class Lot
  include MongoMapper::EmbeddedDocument

  # Keys
  key  :number,       String, :required => true
  key  :consignee_id, BSON::ObjectId
  key  :description,  String, :required => true
  key  :low,          Money
  key  :high,         Money
  key  :qty_available,Integer, :required => true
  
  embedded_in :auction

  #validate :validate_number

  private
    def validate_number
      auction.lots.each do |lot|
        if(lot.id != id && lot.number == number)
          errors.add(:number, "cannot be duplicate")
        end
      end
    end
    
    
end