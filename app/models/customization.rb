class Customization
  include MongoMapper::Document

  key :model, :required => true
  many :custom_fields

  ##
  # Fetch (or create) the given Customization record by model name
  #
  def self.get_by_model_name(model_name)
    Customization.first_or_create(:model => model_name)
  end

  def self.get_by_model(model)
    model_name = model.class.name.underscore.downcase
    get_by_model_name(model_name)
  end

  def required_fields
    required = []
    custom_fields.each{|field| required << field if field.required? }
    required
  end

end