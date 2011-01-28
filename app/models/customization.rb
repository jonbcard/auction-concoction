class Customization
  include MongoMapper::Document
  #plugin MongoMapper::Plugins::IdentityMap
  
  key :model, :required => true

  many :custom_fields

end