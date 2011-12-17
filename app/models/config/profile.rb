class Profile
  include MongoMapper::Document

  PREMIUM_TYPES = ["FIXED", "PERCENT"]
  
  # Keys
  key :name,             String, :required => true
  key :premium_type,     String
  key :premium_amount,   Integer
  key :is_default,       Boolean

  # Validations
  validates_uniqueness_of   :name,    :case_sensitive => false
end