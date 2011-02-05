class CustomField
  include MongoMapper::EmbeddedDocument

  key :label,     String, :required => true
  key :field,     String, :required => true
  key :required,  Boolean
  
  embedded_in :customization

  def field_name
    "cust_" + field
  end

  def required?
    required
  end
end