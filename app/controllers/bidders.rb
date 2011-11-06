AuctionNow.controllers :bidders, :parent => :auctions do

  before do
    @auction = Auction.find(params[:auction_id])
  end
  
  # Regular browser endpoints
  get :index, :provides => [:html, :json] do
    # /auctions/#{params[:auction_id]}/bidders"
    case content_type
      when :html
        render 'bidders/index'
      when :json
        @auction.bidders.to_json
    end
  end

  post :new, :provides => [:json] do
    @bidder = Bidder.new(parse_json(request))
    if @auction.add_bidder(@bidder)
      return @bidder.to_json
    else
      return {:errors => @bidder.errors}.to_json
    end
  end

  get :checkout, :with=> :id, :provides => [:html, :pdf] do
    bidder = @auction.bidders.find(params[:id])
    @receipt =  !bidder.receipt.nil? ? bidder.receipt : bidder.create_receipt
    case content_type
      when :html    
        render 'bidders/checkout'
      when :pdf
        content_type 'application/pdf'
        prawn :'reports/bidder_receipt'
    end
  end

  post :checkout, :with => :id, :provides => :html do
    bidder = @auction.bidders.find(params[:id])
    # TODO : add some sort of checksum to make sure bidder has not changed
    bidder.checkout
    flash[:notice] = 'Bidder successfully checked out.'
    redirect "/auctions/#{params[:auction_id]}/bidders"
  end

  get :index, :with => :id, :provides => :json do
    return @auction.bidders.find(params[:id]).to_json
  end

  post :index, :with => :id, :provides => :json do
    @bidder = Bidder.new(parse_json(request))
    success = @auction.update_bidder(@bidder)
    if(!success)
      return {:errors => @bidder.errors}.to_json
    else
      return @bidder.to_json
    end
  end
end