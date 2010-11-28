class Lot
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::Timestamps 

  # Keys
  key  :number,       String, :required => true
  key  :description,  String, :required => true
  key  :qty_available,Integer, :required => true
  timestamps!
  
  embedded_in :auction
end