class AppParameters
  include MongoMapper::Document
  plugin Joint
  plugin MongoMapper::Plugins::IdentityMap

  def self.get
    AppParameters.first_or_create({})
  end

  key  :company_name,      String, :required => true
  key  :tax_line1_name,    String
  key  :tax_line1_percent, Integer
  key  :tax_line2_name,    String
  key  :tax_line2_percent, Integer
  
  key  :bidder_autonumber_start, Integer
  key  :permanent_autonumber_start, Integer
  key  :allow_bidder_autoregister, Boolean

  one  :default_profile,   :class_name => 'Profile'
  many :surcharge_types
  
  attachment :file
  
  # Validations
  validates_numericality_of :tax_line1_percent, :if => lambda {not tax_line1_percent.blank? }
  validates_numericality_of :tax_line2_percent, :if => lambda {not tax_line2_percent.blank? }
  validates_presence_of :tax_line1_name, :if => lambda { not tax_line1_percent.blank? }
  validates_presence_of :tax_line2_name, :if => lambda { not tax_line2_percent.blank? }
  
  def all_taxes
    taxes = []
    taxes << {:name => tax_line1_name, :percent => tax_line1_percent} if not tax_line1_name.blank?
    taxes << {:name => tax_line2_name, :percent => tax_line2_percent} if not tax_line2_name.blank?
    taxes
  end
end

class SurchargeType
  include MongoMapper::EmbeddedDocument

  key  :text,         String,  :required => true
  key  :amount,       Money,   :required => true
    
end