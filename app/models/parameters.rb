class Parameters
  include MongoMapper::Document
  
  plugin MongoMapper::Plugins::IdentityMap
  
  key  :standard_fee_pct,   Integer
  
end