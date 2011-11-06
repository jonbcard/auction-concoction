class Consignee
  include MongoMapper::Document

  # Keys
  key :code,             String     # Alpha-numeric code for the location
  key :name,             String     # Display name for the consignee
  key :address,          String     
  key :city,             String
  key :state,            String
  key :external_code,    String     # Link to external accounting system

  # Validations
  validates_length_of       :code,    :within => 3..16
  validates_format_of       :code,    :with => /[A-Z0-9]/m
  validates_uniqueness_of   :code,    :case_sensitive => false
  validates_length_of       :name,    :within => 3..25
end