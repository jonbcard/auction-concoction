class CatalogItem
  include MongoMapper::EmbeddedDocument

  # Keys
  key  :consignee_id, BSON::ObjectId
  key  :number,       String, :required => true, :unique => true
  key  :description,  String, :required => true
  key  :qty_available,Integer, :required => true
  
  embedded_in :auction
    
end