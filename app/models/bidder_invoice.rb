class BidderInvoice
  include MongoMapper::Document

  belongs_to  :auction

  # Keys
  key  :bidder_id,  BSON::ObjectId, :index => true
  key  :customer_id,BSON::ObjectId, :index => true
  key  :number,     String, :required => true
  key  :first_name, String, :required => true
  key  :last_name,  String, :required => true
  key  :id_number,  String, :required => true

  key  :fee_percent, Integer
  key  :fee_amount,  Money
  
  key  :sub_total,   Money,  :required => true
  key  :total,       Money,  :required => true

  many :purchases
  many :tax_lines
  many :surcharges

  def calculate_totals
    # First, calculate the subtotal
    sum = Money.new(0)
    purchases.each do |purchase|
      sum += purchase.item_total
    end
    self.sub_total = sum

    # Add the bidder's fee
    params = AppParameters.get
    self.fee_percent = params.fee_percent.nil? ? 0 : params.fee_percent
    self.fee_amount = fee_percent.nil? ? Money.new(0) : Money.new(sub_total.cents * (self.fee_percent/100.0))

    # Finally, add the taxes
    add_tax_line(params.tax_line1_name, params.tax_line1_percent) unless params.tax_line1_percent.blank?
    add_tax_line(params.tax_line2_name, params.tax_line2_percent) unless params.tax_line2_percent.blank?

    self.total = sub_total + fee_amount + (@tax_total || Money.new(0))
  end

  private
    def add_tax_line(name, percent)
      tax_line = TaxLine.new(:name => name, :percent => percent)
      tax_line.amount = Money.new(sub_total.cents * (percent/100.0))
      tax_lines << tax_line
      @tax_total = Money.new(0) if @tax_total.nil?
      @tax_total += tax_line.amount
    end
end

 class TaxLine
    include MongoMapper::EmbeddedDocument

    key  :name,         String,  :required => true
    key  :percent,      Integer, :required => true
    key  :amount,       Money,   :required => true
    
  end

class Purchase
  include MongoMapper::EmbeddedDocument

  key  :lot,          String,  :required => true
  key  :description,  String,  :required => true
  key  :price,        Money,   :required => true
  key  :quantity,     Integer, :required => true

  def item_total
    Money.new(price.cents*quantity)
  end
end

class Surcharge
  include MongoMapper::EmbeddedDocument

  key  :surcharge_text,          String
  key  :price,        Money,   :required => true
end


class Payment
  include MongoMapper::EmbeddedDocument

  key  :payment_type,    String,  :required => true
  key  :payment_key,     String
  key  :payment_amount,  String,  :required => true

end