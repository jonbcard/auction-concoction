class CatalogItem
  include MongoMapper::Document

  # Keys
  key  :number,       String, :required => true, :unique => true
  key  :consignee_id, BSON::ObjectId
  key  :description,  String, :required => true
  key  :qty_available,Integer, :required => true
  
end