class AppParameters
  include MongoMapper::Document
  plugin Joint
  plugin MongoMapper::Plugins::IdentityMap

  def self.get
    AppParameters.first_or_create({})
  end

  key  :company_name,      String, :required => true
  key  :fee_percent,       Integer
  key  :tax_line1_name,    String
  key  :tax_line1_percent, Integer
  key  :tax_line2_name,    String
  key  :tax_line2_percent, Integer

  attachment :file
  
  # Validations
  validates_numericality_of :fee_percent, :if => lambda {not fee_percent.blank? }
  validates_numericality_of :tax_line1_percent, :if => lambda {not tax_line1_percent.blank? }
  validates_numericality_of :tax_line2_percent, :if => lambda {not tax_line2_percent.blank? }
  validates_presence_of :tax_line1_name, :if => lambda { not tax_line1_percent.blank? }
  validates_presence_of :tax_line2_name, :if => lambda { not tax_line2_percent.blank? }
end
