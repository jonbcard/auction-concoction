class Consignee
  include MongoMapper::Document

  # Scopes
  scope :by_code,  lambda { |code| where(:code => code) }
  
  # General keys
  key :code,             String     # Alpha-numeric code for the location
  key :name,             String     # Display name for the consignee
  key :address,          String     
  key :city,             String
  key :state,            String
  key :external_code,    String     # Link to external accounting system
  
  # Primary contact keys
  key :first_name,       String     # First name of the primary contact
  key :last_name,        String     # Last name of the primary contact
  key :phone,            String     # Phone of the primary contact
  key :phone_ext,        String     # Phone extension (these still exist, right?)

  # Validations
  validates_length_of       :code,    :within => 3..16
  validates_format_of       :code,    :with => /[A-Z0-9]/m
  validates_uniqueness_of   :code,    :case_sensitive => false
  validates_length_of       :name,    :within => 3..25
end