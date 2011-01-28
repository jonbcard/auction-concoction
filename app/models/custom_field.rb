class CustomField
  include MongoMapper::EmbeddedDocument

  key :label
  key :field
  key :required
  
  embedded_in :customization

end