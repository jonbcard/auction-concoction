class AppParameters
  include MongoMapper::Document
  plugin MongoMapper::Plugins::IdentityMap

  def self.get
    AppParameters.first_or_create({})
  end

  key  :standard_fee_pct,   Integer

  # Validations
  validates_numericality_of :standard_fee_pct
end