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

  get :new, :provides => :html do
    @bidder = Bidder.new()
    render 'bidders/new'
  end

  post :new, :provides => [:html, :json] do
    case content_type
      when :html
        @bidder = Bidder.new(params[:bidder])
        if @auction.add_bidder(@bidder)
          flash[:notice] = 'Bidder was successfully created.'
          redirect "/auctions/#{params[:auction_id]}/bidders"
        else
          render 'bidders/new'
        end
      when :json
        @bidder = Bidder.new(JSON.parse(CGI::unescape(request.body.read)))
        if @auction.add_bidder(@bidder)
          return @bidder.to_json
        elset
          return {:errors => @bidder.errors}.to_json
        end
    end

  end

  get :edit, :with => :id, :provides => :html do
    @bidder = @auction.bidders.find(params[:id])
    render 'bidders/edit'
  end

  put :edit, :with => :id, :provides => :html do
    @bidder = Bidder.new(params[:bidder])
    @bidder.id = params[:id]
    if(@auction.update_bidder(@bidder))
      flash[:notice] = 'Bidder was successfully updated.'
      redirect "/auctions/#{params[:auction_id]}/bidders"
    else
      render 'bidders/edit'
    end
  end

  get :checkout, :with=> :id, :provides => :html do
    bidder = @auction.bidders.find(params[:id])
    @receipt =  !bidder.receipt.nil? ? bidder.receipt : bidder.create_receipt
    render 'bidders/checkout'
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
    @bidder = Bidder.new(JSON.parse(CGI::unescape(request.body.read)))
    success = @auction.update_bidder(@bidder)
    if(!success)
      return {:errors => @bidder.errors}.to_json
    else
      return @bidder.to_json
    end
  end
end