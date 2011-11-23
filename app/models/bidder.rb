class Bidder
  include MongoMapper::EmbeddedDocument
  # TODO: Custom field plug-in is causing errors after dynamic class
  # reloading. Disabled for now.
  #plugin  MongoMapper::Plugins::CustomFieldPlugin

  BIDDER_STATES = ["NEW", "ACTIVE", "INACTIVE"]

  # Keys
  key  :number,     String, :required => true
  key  :first_name, String, :required => true
  key  :last_name,  String, :required => true
  key  :id_number,  String, :required => true
  key  :status,     String
  key  :customer_id,BSON::ObjectId

  one  :receipt, :class_name => 'BidderReceipt'
  
  embedded_in :auction

  validate :validate_status

  def create_receipt
    bidder_receipt = BidderReceipt.new(
      :auction    => auction,
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
    auction.update_bidder(self)
    receipt
  end

  private
    def validate_status
      unless !status.nil? || BIDDER_STATES.include?(status)
        errors.add(:status, "is not a valid state")
      end
    end

    def all_sales
      auction.sales.find_all {|s| s.bidder == number}
    end
end