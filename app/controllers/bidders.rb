AuctionNow.controllers :bidders, :parent => :auctions do
  
  get :index do
    # /auctions/#{params[:auction_id]}/bidders"
    @auction = Auction.find(params[:auctions_id])
    render 'bidders/index'
  end
  
  get :new do
    @auction = Auction.find(params[:auctions_id])
    render 'bidders/new'
  end

  post :new do
    @auction = Auction.find(params[:auctions_id])
    @auction.bidders << Bidder.new(params[:bidder])
    if @auction.save
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
    @bidder = @auction.bidders.detect {|bidder| bidder.id.to_s == params[:id]}
    if @bidder.update_attributes(params[:bidder])
      puts "UPDATED ATTRIBUTES"
      flash[:notice] = 'Bidder was successfully updated.'
      redirect url(:bidders, :index, :auctions_id => params[:auctions_id])
    else
      puts "COULD NOT UPDATE ATTRIBUTES"
      render 'bidders/edit'
    end
  end
end