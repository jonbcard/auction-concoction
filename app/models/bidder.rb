class Bidder
  include MongoMapper::EmbeddedDocument
  
  BIDDER_STATES = ["NEW", "ACTIVE", "INACTIVE"]

  # Keys
  key  :number,     String, :required => true
  key  :first_name, String, :required => true
  key  :last_name,  String, :required => true
  key  :id_number,  String, :required => true
  key  :status,     String
  key  :customer_id,BSON::ObjectId

  one  :receipt, :class_name => 'BidderReceipt'
  many :invoices, :class_name => 'BidderInvoice'
  
  embedded_in :auction_details

  validate :validate_status


  ## 
  # Stub an invoice using all currently uninvoiced sales for this bidder.
  # If there are no uninvoiced sales for this bidder this method will return nil.
  def create_initial_invoice
    if uninvoiced_sales.empty?
      return nil
    end
    
    bidder_invoice = BidderInvoice.new(
      :auction    => auction_details.auction,
      :bidder_id  => id,
      :number     => number,
      :first_name => first_name,
      :last_name  => last_name,
      :id_number  => id_number
    )
    uninvoiced_sales.each do |sale|
      sale_hash = sale.to_mongo
      sale_hash.delete(:bidder)
      bidder_invoice.purchases << Purchase.new(sale_hash)
    end
    bidder_invoice
  end
    
  def create_receipt
    bidder_receipt = BidderReceipt.new(
      :auction    => auction_details.auction,
      :bidder_id  => id,
      :number     => number,
      :first_name => first_name,
      :last_name  => last_name,
      :id_number  => id_number
    )

    all_sales.each do |sale|
      sale_hash = sale.to_mongo
      sale_hash.delete(:bidder)
      bidder_receipt.purchases << Purchase.new(sale_hash)
    end
    bidder_receipt.calculate_totals
    bidder_receipt
  end

  def checkout
    receipt = create_receipt
    receipt.save!

    self.status = "INACTIVE"
    self.receipt = receipt
    auction_details.update_bidder(self)
    receipt
  end
  
  def all_sales
    auction_details.sales.find_all {|s| s.bidder == number}
  end
  
  ##
  # Provides a lits of all sales for this bidder that are not yet part of a
  # created invoice.
  #
  def uninvoiced_sales
    sales_to_remove = invoiced_sales
    filtered = all_sales.find_all do |sale|
      sales_to_remove.none? {|to_remove| to_remove.lot == sale.lot && to_remove.price = sale.price }
    end
    return filtered
  end
  
  ##
  # Flattens all invoiced sales into a single list
  #
  def invoiced_sales
    invoices.map{ |inv| inv.purchases }.flatten 
  end

  private
    def validate_status
      unless !status.nil? || BIDDER_STATES.include?(status)
        errors.add(:status, "is not a valid state")
      end
    end
  
end