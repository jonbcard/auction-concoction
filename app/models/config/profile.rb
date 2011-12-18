class Profile
  include MongoMapper::Document

  PREMIUM_TYPES = ["NONE", "FIXED", "PERCENT"]
  COMMISSION_TYPES = ["NONE", "FIXED", "PERCENT"]
  
  # Keys
  key :name,                   String, :required => true
  key :buyer_premium_type,     String
  key :buyer_premium_amount,   Integer
  key :commission_type,        String
  key :commission_amount,      Integer  # TODO : probably ends up being a complex-type

  # Validations
  validates_uniqueness_of   :name,    :case_sensitive => false
end