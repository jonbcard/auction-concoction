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
    if @auction.add_bidder_and_save(@bidder)
      flash[:notice] = 'Bidder was successfully created.'
      redirect url(:bidders, :index, :auctions_id => params[:auctions_id])
    else
      render 'bidders/new'
    end
  end
  
  get :edit, :with => :id do
    @auction = Auction.find(params[:auctions_id])
    # TODO : should be written better
    @bidder = @auction.bidders.detect { |bidder| bidder.id.to_s == params[:id]}
    render 'bidders/edit'
  end

  put :edit, :with => :id do
    @auction = Auction.find(params[:auctions_id])
    existing_bidder = @auction.bidders.detect {|bidder|  bidder.id.to_s == params[:id] }
    # TODO: ugly as heck 
    @bidder = Bidder.new(params[:bidder])
    if @bidder.valid? && existing_bidder.update_attributes(params[:bidder])
      flash[:notice] = 'Bidder was successfully updated.'
      redirect url(:bidders, :index, :auctions_id => params[:auctions_id])
    else
      render 'bidders/edit'
    end
  end
end