AuctionNow.controllers :bidders, :parent => :auctions do
  
  get :index do
    # /auctions/#{params[:auction_id]}/bidders"
    @auction = Auction.find(params[:auctions_id])
    render 'bidders/index'
  end
  
  get :new do
    @auction = Auction.find(params[:auctions_id])
    @bidder = Bidder.new()
    render 'bidders/new'
  end

  post :new do
    @bidder = Bidder.new(params[:bidder])
    @auction = Auction.find(params[:auctions_id])
    if @auction.add_bidder(@bidder)
      flash[:notice] = 'Bidder was successfully created.'
      redirect url(:bidders, :index, :auctions_id => params[:auctions_id])
    else
      render 'bidders/new'
    end
  end
  
  get :edit, :with => :id do
    @auction = Auction.find(params[:auctions_id])
    @bidder = @auction.bidders.find(params[:id])
    render 'bidders/edit'
  end

  put :edit, :with => :id do
    @auction = Auction.find(params[:auctions_id])
    @bidder = Bidder.new(params[:bidder])
    @bidder.id = params[:id]
    if(@auction.update_bidder(@bidder))
      flash[:notice] = 'Bidder was successfully updated.'
      redirect url(:bidders, :index, :auctions_id => params[:auctions_id])
    else
      render 'bidders/edit'
    end
  end

  get :checkout, :with=> :id do
    @auction = Auction.find(params[:auctions_id])
    bidder = @auction.bidders.find(params[:id])
    @receipt =  !bidder.receipt.nil? ? bidder.receipt : @auction.create_receipt(params[:id])
    render 'bidders/checkout'
  end

  post :checkout, :with => :id do
    auction = Auction.find(params[:auctions_id])
    # TODO : add some sort of checksum to make sure bidder has not changed
    auction.checkout_bidder(params[:id])
    flash[:notice] = 'Bidder successfully checked out.'
    redirect url(:bidders, :index, :auctions_id => params[:auctions_id])
  end
end