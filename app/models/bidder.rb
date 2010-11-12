class Bidder
  include MongoMapper::EmbeddedDocument
  plugin MongoMapper::Plugins::Timestamps 

  # Keys
  key  :number,     String, :required => true
  key  :first_name, String
  key  :last_name,  String
  key  :id_number,  String
  timestamps!
  
  belongs_to :auction

  # Validations
  #validates_presence_of :first_name
  #validates_associated  :bidders
  # Validations
  #validates_presence_of     :title
  #validates_length_of       :title, :within => 1..40
  
end