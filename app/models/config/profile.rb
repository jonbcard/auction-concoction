class Profile
  include MongoMapper::Document

  # Keys
  key :name,             String

  # Validations
  validates_uniqueness_of   :name,    :case_sensitive => false
end