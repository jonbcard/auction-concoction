AuctionNow.controllers :bidders, :parent => :auctions do

  before do
    @details = Auction.find(params[:auction_id]).details
  end
  
  # Regular browser endpoints
  get :index, :provides => [:html, :json] do
    case content_type
      when :html
        render 'bidders_index'
      when :json
        @details.bidders.to_json
    end
  end
  
  get :purchases, :with => :id, :provides => [:html] do
    bidder = @details.bidders.find(params[:id])
    @purchases = bidder.all_sales
    partial "templates/bidder_purchases"
  end
  
  get :invoices, :with => :id, :provides => [:html] do
    bidder = @details.bidders.find(params[:id])
    @invoices = Array.new(bidder.invoices) || []
    temp_invoice = bidder.create_initial_invoice
    if not temp_invoice.nil?
      @invoices.unshift(temp_invoice)
    end
    
    @app_params = AppParameters.get
    
    partial "templates/bidder_invoices"
  end
    
  get :next_number, :provides => [:json] do
    # TODO: better support for multi-user registration w/ reservation system
    val = @details.next_bidder_num
    return {:next => val}.to_json
  end

  post :new, :provides => [:json] do
    # TODO : omit certain fields for each
    bidder_map = parse_json(request)
    @bidder = Bidder.new(bidder_map)
    
    bidder_map['id'] = bidder_map['customer_id'] if bidder_map.has_key?('customer_id')
    @customer = Customer.new(bidder_map)
    
    # Run as much pre-validation as we can to try to guarantee save
    # success. Early-out if there are validation errors.
    if( not(@customer.valid? & @bidder.valid?) )
      merged_errors = @bidder.errors.to_hash.merge(@customer.errors.to_hash) 
      return {:errors => merged_errors}.to_json
    end
    
    @customer.save!
    @bidder.customer_id = @customer.id
    
    if @details.add_bidder(@bidder)
      return @bidder.to_json
    else
      # Weird repitition. Right now this is because the add_bidder call does
      # an additional check against bidder uniqueness.
      return {:errors => @bidder.errors}.to_json
    end
  end
  
  post :index, :with => :id, :provides => :json do
    # TODO : omit certain fields for each
    bidder_map = parse_json(request)
    @bidder = Bidder.new(bidder_map)
    
    bidder_map['id'] = bidder_map['customer_id'] if bidder_map.has_key?('customer_id')
    @customer = Customer.new(bidder_map)
    
    # Run as much pre-validation as we can to try to guarantee save
    # success. Early-out if there are validation errors.
    if( not(@customer.valid? & @bidder.valid?) )
      merged_errors = @bidder.errors.to_hash.merge(@customer.errors.to_hash) 
      return {:errors => merged_errors}.to_json
    end
    
    @customer.save!
    
    if @details.update_bidder(@bidder)
      return @bidder.to_json
    else
      return {:errors => @bidder.errors}.to_json
    end
  end

  get :checkout, :with=> :id, :provides => [:html, :pdf] do
    bidder = @details.bidders.find(params[:id])
    @receipt =  !bidder.receipt.nil? ? bidder.receipt : bidder.create_receipt
    case content_type
      when :html    
        render 'bidders_checkout'
      when :pdf
        content_type 'application/pdf'
        prawn :'reports/bidder_receipt'
    end
  end

  post :checkout, :with => :id, :provides => :html do
    bidder = @details.bidders.find(params[:id])
    # TODO : add some sort of checksum to make sure bidder has not changed
    bidder.checkout
    flash[:notice] = 'Bidder successfully checked out.'
    redirect "/auctions/#{params[:auction_id]}/bidders"
  end

  get :index, :with => :id, :provides => :json do
    return @auction.bidders.find(params[:id]).to_json
  end

  
end