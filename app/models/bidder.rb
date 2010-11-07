class Bidder
  include MongoMapper::EmbeddedDocument

  # Keys
  key  :number,     String
  key  :first_name, String
  key  :last_name,  String
  key  :id_number,  String

  # Validations
  #validates_presence_of :first_name
  #validates_associated  :bidders
  # Validations
  #validates_presence_of     :title
  #validates_length_of       :title, :within => 1..40
  
end